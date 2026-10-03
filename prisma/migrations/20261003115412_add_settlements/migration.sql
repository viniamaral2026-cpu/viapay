-- CreateEnum
CREATE TYPE "SettlementStatus" AS ENUM ('PENDING', 'PROCESSING', 'SETTLED', 'FAILED', 'CANCELLED');

-- CreateTable
CREATE TABLE "settlements" (
    "id" TEXT NOT NULL,
    "paymentId" TEXT NOT NULL,
    "amountBRLMinor" BIGINT NOT NULL,
    "status" "SettlementStatus" NOT NULL,
    "externalId" TEXT,
    "settledAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "settlements_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "settlements_paymentId_key" ON "settlements"("paymentId");

-- CreateIndex
CREATE UNIQUE INDEX "settlements_externalId_key" ON "settlements"("externalId");

-- CreateIndex
CREATE INDEX "settlements_status_idx" ON "settlements"("status");

-- CreateIndex
CREATE INDEX "settlements_externalId_idx" ON "settlements"("externalId");

-- CreateIndex
CREATE INDEX "settlements_settledAt_idx" ON "settlements"("settledAt");

-- CreateIndex
CREATE INDEX "settlements_createdAt_idx" ON "settlements"("createdAt");

-- AddForeignKey
ALTER TABLE "settlements" ADD CONSTRAINT "settlements_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
