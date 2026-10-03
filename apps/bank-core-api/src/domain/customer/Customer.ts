export interface Customer {
  id: string;
  legalName: string;
  document?: string;
  status: "ACTIVE" | "BLOCKED" | "PENDING";
  createdAt: Date;
}
