export type ApiClientOptions = {
  baseUrl?: string;
};

export class ApiClient {
  private readonly baseUrl: string;

  constructor(options: ApiClientOptions = {}) {
    this.baseUrl =
      options.baseUrl ??
      process.env.NEXT_PUBLIC_API_URL ??
      "";
  }

  async get<T>(path: string): Promise<T> {
    const response = await fetch(
      `${this.baseUrl}${path}`,
      {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      },
    );

    if (!response.ok) {
      throw new Error(
        `API request failed: ${response.status}`,
      );
    }

    return response.json() as Promise<T>;
  }
}

export const apiClient = new ApiClient();
