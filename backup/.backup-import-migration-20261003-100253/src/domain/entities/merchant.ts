import { DomainError } from "@/domain/errors/domain-error.js";

export interface MerchantProps {
  id: string;
  name: string;
  document?: string | null;
  wallet?: string | null;
  active: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export class Merchant {
  private constructor(
    private readonly props: MerchantProps,
  ) {}

  static create(props: {
    id: string;
    name: string;
    document?: string | null;
    wallet?: string | null;
    active?: boolean;
    createdAt?: Date;
    updatedAt?: Date;
  }): Merchant {
    const name = props.name.trim();

    if (!name) {
      throw new DomainError("Merchant name is required.");
    }

    if (name.length > 255) {
      throw new DomainError("Merchant name is too long.");
    }

    return new Merchant({
      id: props.id,
      name,
      document: props.document ?? null,
      wallet: props.wallet ?? null,
      active: props.active ?? true,
      createdAt: props.createdAt ?? new Date(),
      updatedAt: props.updatedAt ?? new Date(),
    });
  }

  get id(): string {
    return this.props.id;
  }

  get name(): string {
    return this.props.name;
  }

  get document(): string | null {
    return this.props.document ?? null;
  }

  get wallet(): string | null {
    return this.props.wallet ?? null;
  }

  get active(): boolean {
    return this.props.active;
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get updatedAt(): Date {
    return this.props.updatedAt;
  }

  deactivate(): void {
    this.props.active = false;
    this.props.updatedAt = new Date();
  }

  activate(): void {
    this.props.active = true;
    this.props.updatedAt = new Date();
  }
}
