import type { NextRequest } from "next/server";

export async function GET(_request: NextRequest) {
  return Response.json({
    success: true,
    service: "viapay",
    status: "initialized",
  });
}

export async function POST(_request: NextRequest) {
  return Response.json(
    {
      success: false,
      code: "NOT_IMPLEMENTED",
      message:
        "Endpoint criado estruturalmente. Implementar contrato real antes de habilitar operação financeira.",
    },
    { status: 501 },
  );
}
