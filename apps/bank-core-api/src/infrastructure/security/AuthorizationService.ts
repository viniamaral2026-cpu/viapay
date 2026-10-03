import {
  AuthorizationContext,
  AuthorizationPolicy,
} from "../../domain/authorization/Authorization.js";

export class AuthorizationService {
  authorize(
    context: AuthorizationContext,
    policy: AuthorizationPolicy,
  ): boolean {
    if (!context.permissions.includes(policy.permission)) {
      return false;
    }

    if (
      policy.maximumAmountMinor !== undefined &&
      context.amountMinor !== undefined &&
      context.amountMinor > policy.maximumAmountMinor
    ) {
      return false;
    }

    return true;
  }
}
