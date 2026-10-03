export default function DashboardPage() {
  return (
    <section className="page-container">
      <div className="page-header">
        <div>
          <h1>Dashboard</h1>
          <p>Visão operacional do Core Banking.</p>
        </div>

        <button className="button button-primary">
          Nova operação
        </button>
      </div>

      <div className="grid grid-4">
        <div className="card">
          <span className="stat-label">Saldo operacional</span>
          <strong className="stat-value">R$ 0,00</strong>
        </div>

        <div className="card">
          <span className="stat-label">Pagamentos hoje</span>
          <strong className="stat-value">0</strong>
        </div>

        <div className="card">
          <span className="stat-label">Aprovações pendentes</span>
          <strong className="stat-value">0</strong>
        </div>

        <div className="card">
          <span className="stat-label">Liquidações pendentes</span>
          <strong className="stat-value">0</strong>
        </div>
      </div>

      <div className="grid grid-2" style={{ marginTop: 20 }}>
        <div className="card">
          <h3>Controle operacional</h3>
          <p>
            Monitoramento de pagamentos, transferências,
            liquidações e reconciliações.
          </p>
        </div>

        <div className="card">
          <h3>Segurança</h3>
          <p>
            RBAC, ABAC, MFA, aprovação por alçada e auditoria.
          </p>
        </div>
      </div>

      <div className="card table-card">
        <h3>Últimas operações</h3>

        <table className="data-table">
          <thead>
            <tr>
              <th>Operação</th>
              <th>Tipo</th>
              <th>Valor</th>
              <th>Status</th>
            </tr>
          </thead>

          <tbody>
            <tr>
              <td>—</td>
              <td>—</td>
              <td>—</td>
              <td>
                <span className="badge badge-info">
                  Sem operações
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
  );
}
