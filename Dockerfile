############################################
# Stage 1: Build Node (Fastify)
############################################
FROM node:20-slim AS node-builder

WORKDIR /nodeapp
COPY node_server.js package*.json ./
RUN npm install --omit=dev

############################################
# Stage 2: Build Python (FastAPI)
############################################
FROM python:3.11-slim AS python-builder

WORKDIR /pyapp
COPY python_app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY python_app .

############################################
# Stage 3: Final Runtime Image
############################################
FROM alpine:3.19 AS runtime

# Install minimal runtime deps
RUN apk add --no-cache \
    python3 py3-pip nodejs npm curl

# Copy Node app from node-builder
WORKDIR /app
COPY --from=node-builder /nodeapp ./nodeapp

# Copy Python app from python-builder
COPY --from=python-builder /pyapp ./pyapp

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /app/pyapp/requirements.txt

# Install PM2 to manage both services
RUN npm install -g pm2

# Create PM2 ecosystem config
COPY ecosystem.config.js /app/ecosystem.config.js

# Only expose Node.js gateway port (Python runs internally on 3001)
EXPOSE 3000
CMD ["pm2-runtime", "/app/ecosystem.config.js"]
