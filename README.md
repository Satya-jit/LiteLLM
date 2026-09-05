# LiteLLM with PostgreSQL Backend

LiteLLM proxy with PostgreSQL database for authentication and credential management.

## Local Development

### Prerequisites
- Docker and Docker Compose installed
- `.env` file with credentials

### Setup

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Update `.env` with your credentials:
```env
DB_USER=litellm
DB_PASSWORD=litellm@secure123

UI_USERNAME=admin
UI_PASSWORD=!Litellm@321

LITELLM_MASTER_KEY=sk-litellm-master-key-secure
```

3. Run with Docker Compose:
```bash
docker-compose up -d
```

4. Access LiteLLM UI at `http://localhost:8000`
   - Username: `admin` (or value of `UI_USERNAME`)
   - Password: `!Litellm@321` (or value of `UI_PASSWORD`)

## GitHub Actions Integration

The build workflow uses GitHub repository variables for Docker Compose credentials.

### Setting Repository Variables

Go to repository **Settings** → **Secrets and variables** → **Variables** and add:
- `DB_USER`: Database user (e.g., `litellm`)
- `DB_PASSWORD`: Database password (e.g., `litellm@secure123`)
- `UI_USERNAME`: LiteLLM UI username (e.g., `admin`)
- `UI_PASSWORD`: LiteLLM UI password (e.g., `!Litellm@321`)
- `LITELLM_MASTER_KEY`: Master API key

### Environment Variables in Workflow

When running workflows, variables are available as `${{ vars.VARIABLE_NAME }}` for public variables or `${{ secrets.SECRET_NAME }}` for secrets.

Docker Compose will use these when passed via:
```bash
DB_USER=${{ vars.DB_USER }} \
DB_PASSWORD=${{ secrets.DB_PASSWORD }} \
UI_USERNAME=${{ vars.UI_USERNAME }} \
UI_PASSWORD=${{ secrets.UI_PASSWORD }} \
LITELLM_MASTER_KEY=${{ secrets.LITELLM_MASTER_KEY }} \
docker-compose up -d
```

## Services

### PostgreSQL (postgres)
- **Image**: `postgres:15-alpine`
- **Port**: 5432
- **Credentials**: From environment variables
- **Volume**: `litellm_postgres_data` (persistent)
- **Health Check**: Enabled

### LiteLLM (litellm)
- **Build**: Custom Dockerfile from this repo
- **Port**: 8000
- **Database**: Connected to PostgreSQL via `DATABASE_URL`
- **UI Credentials**: From environment variables
- **Health Check**: HTTP endpoint `/health/liveliness`

## Configuration

All configuration via environment variables:
- `DB_USER` - PostgreSQL username
- `DB_PASSWORD` - PostgreSQL password
- `UI_USERNAME` - LiteLLM UI admin username
- `UI_PASSWORD` - LiteLLM UI admin password
- `LITELLM_MASTER_KEY` - Master API key for LiteLLM

Defaults are provided in `docker-compose.yml` if not specified.

## Build and Push

The GitHub Actions workflow automatically:
1. Builds multi-arch Docker images (amd64, arm64)
2. Pushes to Docker Hub as `satya490/litellm:latest` and `satya490/litellm:<commit-sha>`
3. Triggers the homelab-infra manifest update workflow

## Notes

- Never commit `.env` file (it's in `.gitignore`)
- Use `.env.example` as a template for new developers
- Database persists in Docker volume across container restarts
- Both services use a shared `litellm-network` bridge network
