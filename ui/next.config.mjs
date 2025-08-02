/** @type {import('next').NextConfig} */
const nextConfig = {
  devIndicators: false,
  // Proxy /chat requests to the backend server
  async rewrites() {
    // Only use proxy in development
    if (process.env.NODE_ENV === 'development') {
      return [
        {
          source: "/chat",
          destination: "http://127.0.0.1:8000/chat",
        },
      ];
    }
    return [];
  },
};

export default nextConfig;
