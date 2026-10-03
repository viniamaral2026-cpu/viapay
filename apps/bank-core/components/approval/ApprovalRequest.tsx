export interface ApprovalRequestProps {
  operationId: string;
  amount: string;
  currency: string;
}

export function ApprovalRequest({
  operationId,
  amount,
  currency,
}: ApprovalRequestProps) {
  return (
    <div className="card">
      <strong>Solicitação de aprovação</strong>

      <p>Operação: {operationId}</p>
      <p>
        Valor: {amount} {currency}
      </p>

      <button className="button button-primary">
        Aprovar
      </button>

      <button
        className="button button-secondary"
        style={{ marginLeft: 8 }}
      >
        Rejeitar
      </button>
    </div>
  );
}
