############################################
# Node.js (Fastify) Service
############################################
FROM node:20-slim

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --omit=dev

# Copy application code
COPY node_server.js ./

# Expose Node.js port
EXPOSE 8080

# Start Fastify server
CMD ["node", "node_server.js"]
