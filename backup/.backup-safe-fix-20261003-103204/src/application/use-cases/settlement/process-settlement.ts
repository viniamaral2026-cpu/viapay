import { randomUUID } from "node:crypto";
import { PrismaSettlementLockRepository } from "@/infrastructure/repositories/prisma-settlement-lock-repository.js";

import { DomainError } from "@/domain/errors/domain-error.js";
import { PaymentEvent } from "@/domain/entities/payment-event.js";

import type { ProcessSettlementInput } from "@/application/dto/process-settlement.dto.js";

import type { UnitOfWork } from "@/domain/repositories/unit-of-work.js";

import type { SettlementLockRepository } from "@/domain/repositories/settlement-lock-repository.js";
import { PaymentEventTransactionRepository } from "@/infrastructure/repositories/prisma-payment-event-transaction-repository.js";

import type { PrismaTransactionClient } from "@/infrastructure/database/prisma-transaction-client.js";

export interface ProcessSettlementResult {
  processed: boolean;
  settlementId: string;
  status: "PROCESSING" | "SETTLED";
  startedEventId: string | null;
  settledEventId: string | null;
}

export class ProcessSettlement {
  constructor(
    private readonly unitOfWork: UnitOfWork,
    private readonly settlementLockRepository: SettlementLockRepository,
    private readonly paymentEventRepository: PaymentEventTransactionRepository,
  ) {}

  async execute(
    input: ProcessSettlementInput,
  ): Promise<ProcessSettlementResult> {
    if (!input.settlementId.trim()) {
      throw new DomainError(
        "Settlement id is required.",
      );
    }

    if (!input.externalId.trim()) {
      throw new DomainError(
        "Settlement externalId is required.",
      );
    }

    return this.unitOfWork.execute(
      async (transaction) => {
        const tx =
          transaction as PrismaTransactionClient;

        /*
         * O ponto crítico do processamento:
         *
         * SELECT ... FOR UPDATE
         *
         * Somente um worker poderá entrar no bloco
         * enquanto o Settlement estiver bloqueado.
         */
        const settlement =
          await this.settlementLockRepository.findByIdForUpdate(
            tx,
            input.settlementId,
          );

        if (!settlement) {
          throw new DomainError(
            "Settlement not found.",
          );
        }

        /*
         * Se outro worker já terminou o processamento,
         * simplesmente retornamos o estado persistido.
         */
        if (settlement.status === "SETTLED") {
          const settledEvent =
            await this.paymentEventRepository.findByExternalId(
              tx,
              `${input.externalId}:settled`,
            );

          return {
            processed: false,
            settlementId: settlement.id,
            status: "SETTLED",
            startedEventId: null,
            settledEventId:
              settledEvent?.id ?? null,
          };
        }

        if (
          settlement.status === "FAILED" ||
          settlement.status === "CANCELLED"
        ) {
          throw new DomainError(
            `Settlement cannot be processed from status ${settlement.status}.`,
          );
        }

        /*
         * PENDING → PROCESSING
         */
        if (settlement.status === "PENDING") {
          settlement.startProcessing();

          await this.settlementLockRepository.save(
            tx,
            settlement,
          );

          const startedExternalId =
            `${input.externalId}:started`;

          const existingStarted =
            await this.paymentEventRepository.findByExternalId(
              tx,
              startedExternalId,
            );

          if (!existingStarted) {
            const startedEvent =
              PaymentEvent.create({
                id: randomUUID(),
                paymentId:
                  settlement.paymentId,
                type:
                  "SETTLEMENT_STARTED",
                externalId:
                  startedExternalId,
                payload:
                  input.payload ?? {
                    settlementId:
                      settlement.id,
                    externalId:
                      input.externalId,
                  },
              });

            await this.paymentEventRepository.create(
              tx,
              startedEvent,
            );
          }
        }

        /*
         * PROCESSING → SETTLED
         */
        if (settlement.status !== "PROCESSING") {
          throw new DomainError(
            `Settlement is not PROCESSING. Current status: ${settlement.status}.`,
          );
        }

        settlement.markAsSettled();

        await this.settlementLockRepository.save(
          tx,
          settlement,
        );

        const settledExternalId =
          `${input.externalId}:settled`;

        const existingSettled =
          await this.paymentEventRepository.findByExternalId(
            tx,
            settledExternalId,
          );

        if (existingSettled) {
          return {
            processed: false,
            settlementId: settlement.id,
            status: "SETTLED",
            startedEventId: null,
            settledEventId:
              existingSettled.id,
          };
        }

        const settledEvent =
          PaymentEvent.create({
            id: randomUUID(),
            paymentId:
              settlement.paymentId,
            type: "SETTLED",
            externalId:
              settledExternalId,
            payload:
              input.payload ?? {
                settlementId:
                  settlement.id,
                externalId:
                  input.externalId,
              },
            occurredAt:
              settlement.settledAt ??
              new Date(),
          });

        await this.paymentEventRepository.create(
          tx,
          settledEvent,
        );

        return {
          processed: true,
          settlementId: settlement.id,
          status: "SETTLED",
          startedEventId: null,
          settledEventId:
            settledEvent.id,
        };
      },
    );
  }
}
