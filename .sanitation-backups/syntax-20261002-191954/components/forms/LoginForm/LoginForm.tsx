import { Button } from "@/components/Button/Button;
import { Input } from "@/components/Input/Input;

export function LoginForm() {
  return (
    <form className="mt-8 space-y-4">
      <Input
        type="email"
        name="email"
        placeholder="E-mail"
        autoComplete="email"
        required
      />

      <Input
        type="password"
        name="password"
        placeholder="Senha"
        autoComplete="current-password"
        required
      />

      <Button
        type="submit"
        className="w-full"
      >
        Entrar
      </Button>
    </form>
  );
}
