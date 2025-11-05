module.exports = {
  apps: [
    {
      name: 'fastify-app',
      script: '/app/nodeapp/node_server.js',
      cwd: '/app/nodeapp',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1.5G',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'fastapi-app',
      script: 'python3',
      args: `-m uvicorn main:app --host 0.0.0.0 --port ${process.env.PORT || 3001}`,
      cwd: '/app/pyapp',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1.5G',
      env: {
        PORT: process.env.PORT || 3001
      }
    }
  ]
};
