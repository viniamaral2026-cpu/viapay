import { DomainError } from "../errors/domain-error.js";

export class MoneyBRL {
  private constructor(private readonly cents: bigint) {}

  static fromCents(cents: bigint | number): MoneyBRL {
    const value = typeof cents === "number" ? BigInt(cents) : cents;

    if (value < 0n) {
      throw new DomainError("Money amount cannot be negative.");
    }

    return new MoneyBRL(value);
  }

  get amountInCents(): bigint {
    return this.cents;
  }

  equals(other: MoneyBRL): boolean {
    return this.cents === other.cents;
  }
}
