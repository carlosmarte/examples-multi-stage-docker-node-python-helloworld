const fastify = require('fastify')({ logger: true });

// Register the http-proxy plugin for proxying to Python service
// Route /llm/* to Python service, stripping the /llm prefix
const pythonHost = process.env.PYTHON_HOST || 'python-service';
const pythonPort = process.env.PYTHON_PORT || 3001;

fastify.register(require('@fastify/http-proxy'), {
  upstream: `http://${pythonHost}:${pythonPort}`,
  prefix: '/llm',
  rewritePrefix: '/', // Strip /llm prefix when forwarding to Python
  http2: false,
  proxyPayloads: true,
  replyOptions: {
    onResponse: (request, reply, res) => {
      // Add X-Forwarded headers
      reply.header('X-Forwarded-For', request.ip);
      reply.header('X-Forwarded-Host', request.hostname);
      reply.header('X-Forwarded-Proto', request.protocol);
      reply.send(res);
    }
  }
});

// Node.js application route
fastify.get('/app', async (request, reply) => {
  return { message: 'Hello World from Fastify (Node.js)!' };
});

const start = async () => {
  try {
    const port = process.env.NODE_PORT || 8080;
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`Fastify server running on http://0.0.0.0:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
