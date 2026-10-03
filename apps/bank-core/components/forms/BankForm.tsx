export function BankForm() {
  return (
    <form className="card">
      <div className="form-group">
        <label>Referência</label>
        <input placeholder="Digite a referência" />
      </div>

      <div className="form-group">
        <label>Valor</label>
        <input type="number" step="0.01" />
      </div>

      <button className="button button-primary">
        Continuar
      </button>
    </form>
  );
}
