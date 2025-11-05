############################################
# Python (FastAPI) Service
############################################
FROM python:3.11-slim

WORKDIR /app

# Copy requirements and install dependencies
COPY python_app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY python_app ./

# Expose Python port
EXPOSE 3001

# Start FastAPI with uvicorn
CMD ["python3", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3001"]
