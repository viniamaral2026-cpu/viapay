-- CreateEnum
CREATE TYPE "LedgerEntryType" AS ENUM ('payment', 'refund', 'settlement', 'fee', 'tax', 'adjustment');

-- CreateEnum
CREATE TYPE "LedgerEntryStatus" AS ENUM ('pending', 'completed', 'reversed');

-- CreateTable
CREATE TABLE "ledger_entries" (
    "id" TEXT NOT NULL DEFAULT gen_random_uuid(),
    "debit" DECIMAL NOT NULL DEFAULT 0,
    "credit" DECIMAL NOT NULL DEFAULT 0,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'BRL',
    "amount" DECIMAL NOT NULL DEFAULT 0,
    "reference" TEXT,
    "transaction_id" TEXT,
    "type" "LedgerEntryType" NOT NULL DEFAULT 'payment',
    "status" "LedgerEntryStatus" NOT NULL DEFAULT 'pending',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ledger_entries_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "ledger_entries_transaction_id_idx" ON "ledger_entries"("transaction_id");

-- CreateIndex
CREATE INDEX "ledger_entries_currency_idx" ON "ledger_entries"("currency");

-- CreateIndex
CREATE INDEX "ledger_entries_created_at_idx" ON "ledger_entries"("created_at");

-- CreateIndex
CREATE INDEX "ledger_entries_type_idx" ON "ledger_entries"("type");

-- AddForeignKey
ALTER TABLE "ledger_entries" ADD CONSTRAINT "ledger_entries_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "payments"("id") ON DELETE SET NULL ON UPDATE CASCADE;
