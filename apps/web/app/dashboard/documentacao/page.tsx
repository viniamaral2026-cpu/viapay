import { CodeBlock } from "@/components/developer/CodeBlock";
import { DocsSidebar } from "@/components/developer/DocsSidebar";

export default function DashboardDocumentationPage() {
  return (
    <div className="grid min-h-screen lg:grid-cols-[240px_1fr]">
      <DocsSidebar />
      <main className="p-6 lg:p-12">
        <div className="mx-auto max-w-4xl">
          <span className="text-xs font-semibold uppercase tracking-wider text-blue-600">Documentação</span>
          <h1 className="mt-3 text-4xl font-bold">Comece em 5 linhas</h1>
          <p className="mt-3 text-slate-500">Instale o SDK e comece a aceitar Pix.</p>
          <CodeBlock />
        </div>
      </main>
    </div>
  );
}
