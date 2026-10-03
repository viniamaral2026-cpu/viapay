const steps = ["Criar conta", "Dados da empresa", "Carteira Solana", "Configurações", "Concluído"];

export function OnboardingStepper({ current = 2 }: { current?: number }) {
  return (
    <ol className="space-y-5">
      {steps.map((step, index) => (
        <li key={step} className="flex items-center gap-3">
          <span className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold ${
            index + 1 <= current ? "bg-blue-600 text-white" : "bg-slate-100 text-slate-400"
          }`}>{index + 1}</span>
          <span className={index + 1 === current ? "font-semibold text-slate-950" : "text-sm text-slate-500"}>{step}</span>
        </li>
      ))}
    </ol>
  );
}
