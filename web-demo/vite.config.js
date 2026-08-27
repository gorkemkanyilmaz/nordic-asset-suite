export default {
  server: {
    host: '0.0.0.0',
    port: 5173,
    proxy: {
      '/api/tavily': {
        target: 'https://api.tavily.com',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api\/tavily/, '')
      }
    }
  }
};
