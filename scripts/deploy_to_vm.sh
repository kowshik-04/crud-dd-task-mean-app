#!/usr/bin/env bash
set -euo pipefail

# Usage:
# export SSH_USER=ubuntu
# export SSH_HOST=1.2.3.4
# export SSH_PORT=22
# export DOCKERHUB_USERNAME=you
# ./scripts/deploy_to_vm.sh

: ${SSH_USER:?Need SSH_USER}
: ${SSH_HOST:?Need SSH_HOST}
: ${DOCKERHUB_USERNAME:?Need DOCKERHUB_USERNAME}
SSH_PORT=${SSH_PORT:-22}
REMOTE_DIR=${REMOTE_DIR:-~/app}

# Prepare the remote folder and write docker-compose.yml there
ssh -p "$SSH_PORT" "$SSH_USER@$SSH_HOST" "mkdir -p $REMOTE_DIR"

# Upload docker-compose.yml from repo (we also include default.conf if present)
scp -P "$SSH_PORT" docker-compose.yml "$SSH_USER@$SSH_HOST:$REMOTE_DIR/docker-compose.yml"
if [ -f infra/nginx/default.conf ]; then
  scp -P "$SSH_PORT" infra/nginx/default.conf "$SSH_USER@$SSH_HOST:$REMOTE_DIR/default.conf"
fi

# Remote commands: ensure docker is installed, pull images and start compose
ssh -p "$SSH_PORT" "$SSH_USER@$SSH_HOST" bash -s <<'REMOTE'
set -euo pipefail
# install docker if missing
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
  sudo usermod -aG docker $USER || true
fi
if ! docker compose version >/dev/null 2>&1; then
  sudo apt-get update && sudo apt-get install -y docker-compose-plugin || true
fi
cd "$REMOTE_DIR"
# Substitute DOCKERHUB username in compose if placeholders exist
# Pull latest images and run
docker compose pull || true
docker compose up -d --remove-orphans
docker compose ps
REMOTE

echo "Deployment triggered on $SSH_HOST:$REMOTE_DIR"
