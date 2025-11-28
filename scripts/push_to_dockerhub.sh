#!/usr/bin/env bash
set -euo pipefail

# Usage:
# export DOCKERHUB_USERNAME=you
# export DOCKERHUB_TOKEN=your_token
# ./scripts/push_to_dockerhub.sh

: ${DOCKERHUB_USERNAME:?Need DOCKERHUB_USERNAME}
: ${DOCKERHUB_TOKEN:?Need DOCKERHUB_TOKEN}

echo "Logging in to Docker Hub..."
echo "$DOCKERHUB_TOKEN" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin

# Build and push backend
docker build -t "$DOCKERHUB_USERNAME/crud-dd-backend:latest" ./backend
docker push "$DOCKERHUB_USERNAME/crud-dd-backend:latest"

# Build and push frontend
docker build -t "$DOCKERHUB_USERNAME/crud-dd-frontend:latest" ./frontend
docker push "$DOCKERHUB_USERNAME/crud-dd-frontend:latest"

echo "Images pushed to Docker Hub: $DOCKERHUB_USERNAME/crud-dd-backend and $DOCKERHUB_USERNAME/crud-dd-frontend"
