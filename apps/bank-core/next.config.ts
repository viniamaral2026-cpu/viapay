import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,

  experimental: {
    typedRoutes: true
  },

  env: {
    NEXT_PUBLIC_VIAPAY_ENVIRONMENT:
      process.env.NEXT_PUBLIC_VIAPAY_ENVIRONMENT ?? "sandbox"
  }
};

export default nextConfig;
