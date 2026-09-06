FROM ghcr.io/berriai/litellm:main

# Copy custom config
COPY config/ /app/config/

EXPOSE 8000

CMD ["litellm", "--config", "/app/config/config.yaml", "--port", "8000"]
