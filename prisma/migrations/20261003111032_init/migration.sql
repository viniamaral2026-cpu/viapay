-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('CREATED', 'PIX_PENDING', 'PIX_PAID', 'SETTLEMENT_PENDING', 'SETTLING', 'SETTLED', 'FAILED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PixChargeStatus" AS ENUM ('CREATED', 'ACTIVE', 'PAID', 'EXPIRED', 'CANCELLED', 'FAILED');

-- CreateEnum
CREATE TYPE "PaymentEventType" AS ENUM ('CREATED', 'PIX_CREATED', 'PIX_PAID', 'PIX_EXPIRED', 'SETTLEMENT_PENDING', 'SETTLEMENT_STARTED', 'SETTLED', 'FAILED');

-- CreateTable
CREATE TABLE "merchants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "document" TEXT,
    "wallet" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "merchants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" TEXT NOT NULL,
    "merchantId" TEXT NOT NULL,
    "amountBRLMinor" BIGINT NOT NULL,
    "merchantWallet" TEXT NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pix_charges" (
    "id" TEXT NOT NULL,
    "paymentId" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerId" TEXT,
    "qrCode" TEXT NOT NULL,
    "qrCodeImage" TEXT,
    "amountBRLMinor" BIGINT NOT NULL,
    "status" "PixChargeStatus" NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pix_charges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_events" (
    "id" TEXT NOT NULL,
    "paymentId" TEXT NOT NULL,
    "type" "PaymentEventType" NOT NULL,
    "externalId" TEXT,
    "payload" JSONB,
    "occurredAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "payment_events_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "merchants_document_key" ON "merchants"("document");

-- CreateIndex
CREATE INDEX "merchants_active_idx" ON "merchants"("active");

-- CreateIndex
CREATE INDEX "merchants_createdAt_idx" ON "merchants"("createdAt");

-- CreateIndex
CREATE INDEX "payments_merchantId_idx" ON "payments"("merchantId");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "payments"("status");

-- CreateIndex
CREATE INDEX "payments_merchantWallet_idx" ON "payments"("merchantWallet");

-- CreateIndex
CREATE INDEX "payments_createdAt_idx" ON "payments"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "pix_charges_paymentId_key" ON "pix_charges"("paymentId");

-- CreateIndex
CREATE INDEX "pix_charges_provider_idx" ON "pix_charges"("provider");

-- CreateIndex
CREATE INDEX "pix_charges_providerId_idx" ON "pix_charges"("providerId");

-- CreateIndex
CREATE INDEX "pix_charges_status_idx" ON "pix_charges"("status");

-- CreateIndex
CREATE INDEX "pix_charges_expiresAt_idx" ON "pix_charges"("expiresAt");

-- CreateIndex
CREATE INDEX "payment_events_paymentId_idx" ON "payment_events"("paymentId");

-- CreateIndex
CREATE INDEX "payment_events_type_idx" ON "payment_events"("type");

-- CreateIndex
CREATE INDEX "payment_events_externalId_idx" ON "payment_events"("externalId");

-- CreateIndex
CREATE INDEX "payment_events_occurredAt_idx" ON "payment_events"("occurredAt");

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_merchantId_fkey" FOREIGN KEY ("merchantId") REFERENCES "merchants"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pix_charges" ADD CONSTRAINT "pix_charges_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_events" ADD CONSTRAINT "payment_events_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payments"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
