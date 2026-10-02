export const openApiSchemas = {
  CreatePaymentRequest: {
    $id: "CreatePaymentRequest",
    type: "object",
    required: [
      "amountBRL",
      "merchantWallet"
    ],
    properties: {
      amountBRL: {
        type: "number",
        format: "double",
        exclusiveMinimum: 0
      },
      merchantWallet: {
        type: "string",
        minLength: 1
      }
    }
  },

  CreatePaymentResponse: {
    $id: "CreatePaymentResponse",
    type: "object",
    required: [
      "paymentId",
      "status",
      "pixChargeId",
      "qrCode",
      "expiresAt"
    ],
    properties: {
      paymentId: {
        type: "string"
      },
      status: {
        type: "string",
        enum: ["PIX_PENDING"]
      },
      pixChargeId: {
        type: "string"
      },
      qrCode: {
        type: "string"
      },
      qrCodeImage: {
        type: "string",
        nullable: true
      },
      expiresAt: {
        type: "string",
        format: "date-time"
      }
    }
  },

  PaymentResponse: {
    $id: "PaymentResponse",
    type: "object",
    required: [
      "id",
      "amountBRL",
      "merchantWallet",
      "status",
      "createdAt",
      "updatedAt"
    ],
    properties: {
      id: {
        type: "string"
      },
      amountBRL: {
        type: "number",
        format: "double"
      },
      merchantWallet: {
        type: "string"
      },
      status: {
        type: "string",
        enum: [
          "CREATED",
          "PIX_PENDING",
          "PIX_PAID",
          "SETTLEMENT_PENDING",
          "SETTLING",
          "SETTLED",
          "FAILED",
          "EXPIRED"
        ]
      },
      createdAt: {
        type: "string",
        format: "date-time"
      },
      updatedAt: {
        type: "string",
        format: "date-time"
      }
    }
  },

  ErrorResponse: {
    $id: "ErrorResponse",
    type: "object",
    required: [
      "error",
      "message"
    ],
    properties: {
      error: {
        type: "string"
      },
      message: {
        type: "string"
      }
    }
  },

  HealthResponse: {
    $id: "HealthResponse",
    type: "object",
    required: [
      "status",
      "service"
    ],
    properties: {
      status: {
        type: "string"
      },
      service: {
        type: "string"
      }
    }
  }
} as const;
