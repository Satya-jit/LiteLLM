FROM python:3.11-slim

WORKDIR /app

# Install LiteLLM with latest version and dependencies
RUN pip install --no-cache-dir litellm[proxy]

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health/liveliness').read()"

# Run LiteLLM proxy
CMD ["litellm", "--config", "/app/config/config.yaml", "--port", "8000"]
