export interface ApiClientOptions {
  baseUrl: string;
}

export class ApiClient {
  constructor(
    private readonly options: ApiClientOptions,
  ) {}

  async request<T>(
    path: string,
    init?: RequestInit,
  ): Promise<T> {
    const response = await fetch(
      `${this.options.baseUrl}${path}`,
      {
        ...init,
        headers: {
          "Content-Type": "application/json",
          ...(init?.headers ?? {}),
        },
      },
    );

    if (!response.ok) {
      throw new Error(
        `VIAPAY API error: ${response.status}`,
      );
    }

    return response.json() as Promise<T>;
  }
}
