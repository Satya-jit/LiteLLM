FROM ghcr.io/berriai/litellm:main

# Config is mounted from K8s ConfigMap in production
EXPOSE 8000

CMD ["litellm", "--config", "/app/config/config.yaml", "--port", "8000"]
