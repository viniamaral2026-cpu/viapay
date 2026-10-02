import { Button } from "@/components/Button/Button";
import { Input } from "@/components/Input/Input";

export function RegisterForm() {
  return (
    <form className="mt-8 space-y-4">
      <Input
        name="name"
        placeholder="Nome completo"
        required
      />

      <Input
        type="email"
        name="email"
        placeholder="E-mail profissional"
        autoComplete="email"
        required
      />

      <Input
        name="company"
        placeholder="Empresa"
        required
      />

      <Input
        type="password"
        name="password"
        placeholder="Senha"
        autoComplete="new-password"
        required
      />

      <Button
        type="submit"
        className="w-full"
      >
        Criar conta
      </Button>
    </form>
  );
}
