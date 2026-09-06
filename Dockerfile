FROM ghcr.io/berriai/litellm:main-stable

# This image's ENTRYPOINT is docker/prod_entrypoint.sh, which invokes litellm
# itself and forwards CMD as args - so CMD here should be args only, not the
# "litellm" binary name.
EXPOSE 8000

CMD ["--config", "/app/config/config.yaml", "--port", "8000"]
