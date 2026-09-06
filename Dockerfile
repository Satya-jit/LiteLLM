FROM ghcr.io/berriai/litellm:main

# Base image hardcodes its command in ENTRYPOINT (shell form), which swallows
# any CMD args passed to it. Clear it so our CMD below actually runs.
ENTRYPOINT []

# Config is mounted from K8s ConfigMap in production
EXPOSE 8000

CMD ["litellm", "--config", "/app/config/config.yaml", "--port", "8000"]
