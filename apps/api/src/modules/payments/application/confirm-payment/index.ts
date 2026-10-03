/**
 * ViaPay Application Layer
 *
 * Casos de uso e orquestração da aplicação.
 *
 * Esta camada pode depender do domínio e de ports,
 * mas não deve depender diretamente de frameworks
 * ou providers concretos.
 */

export interface ApplicationContext {
  tenantId: string;
  correlationId: string;
  actorId?: string;
}

export interface UseCase<I, O> {
  execute(input: I, context: ApplicationContext): Promise<O>;
}
