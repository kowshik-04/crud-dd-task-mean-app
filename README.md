In this DevOps task, you need to build and deploy a full-stack CRUD application using the MEAN stack (MongoDB, Express, Angular 15, and Node.js). The backend will be developed with Node.js and Express to provide REST APIs, connecting to a MongoDB database. The frontend will be an Angular application utilizing HTTPClient for communication.  

The application will manage a collection of tutorials, where each tutorial includes an ID, title, description, and published status. Users will be able to create, retrieve, update, and delete tutorials. Additionally, a search box will allow users to find tutorials by title.

## Project setup

### Node.js Server

cd backend

npm install

You can update the MongoDB credentials by modifying the `db.config.js` file located in `app/config/`.

Run `node server.js`

### Angular Client

cd frontend

npm install

Run `ng serve --port 8081`

You can modify the `src/app/services/tutorial.service.ts` file to adjust how the frontend interacts with the backend.

Navigate to `http://localhost:8081/`

## Docker & Deployment (added)

This repository includes Dockerfiles for the backend and frontend, an `infra/nginx/default.conf` reverse-proxy config, and a `docker-compose.yml` to run the full stack locally or on a VM.

Quick local run using Docker Compose:

```bash
# Build images and start services
docker compose up -d --build

# Check services
docker compose ps

# View logs
docker compose logs -f nginx
```

Notes for production VM deployment:
- The `docker-compose.yml` uses an internal `mongo` service. You can also point the backend to an external MongoDB by setting `MONGO_URI`.
- Only port `80` (nginx reverse proxy) is published to the host. Nginx proxies `/api` to the backend and serves the frontend static files.

CI/CD (GitHub Actions):
- A workflow is included at `.github/workflows/ci-cd.yml` that builds Docker images for frontend and backend and pushes them to Docker Hub.
- The workflow expects the following repository secrets to be configured:
	- `DOCKERHUB_USERNAME` — Docker Hub username
	- `DOCKERHUB_TOKEN` — Docker Hub access token or password
	- `SSH_HOST` — IP or hostname of the target Ubuntu VM
	- `SSH_USER` — SSH user on the VM
	- `SSH_PRIVATE_KEY` — Private SSH key (PEM) for `SSH_USER`
	- `SSH_PORT` — (optional) SSH port, default `22`

On the target VM the workflow will:
1. Pull the pushed Docker images.
2. Create (or update) a `docker-compose.yml` in `~/app` and a default `default.conf` for Nginx if not present.
3. Run `docker compose up -d` to deploy the stack.

If you'd like, I can also:
- Prepare example commands to create an Ubuntu VM on AWS/Azure and open port 22/80.
- Help generate the Docker Hub repository names and CI secrets.

## Automation scripts (one-shot helpers)

I added three helper scripts in `scripts/` to finish the assignment with minimal manual steps.

- `scripts/push_to_github.sh` — uses the GitHub CLI (`gh`) to create a repo (optional) and push the code.
- `scripts/push_to_dockerhub.sh` — builds backend/frontend images and pushes them to Docker Hub. Requires `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` env vars.
- `scripts/deploy_to_vm.sh` — copies `docker-compose.yml` and `infra/nginx/default.conf` to a remote VM and runs `docker compose up -d` there. Requires `SSH_USER`, `SSH_HOST`, and `DOCKERHUB_USERNAME` env vars.

Example usage (run locally where the repo is):

```bash
# 1) Push to GitHub (create remote if needed)
DO_GH_CREATE=true GITHUB_USER=your-gh-user ./scripts/push_to_github.sh

# 2) Build & push images to Docker Hub
export DOCKERHUB_USERNAME=your-dockerhub-username
export DOCKERHUB_TOKEN=your-dockerhub-token
./scripts/push_to_dockerhub.sh

# 3) Deploy to your VM
export SSH_USER=ubuntu
export SSH_HOST=1.2.3.4
export SSH_PORT=22            # optional
./scripts/deploy_to_vm.sh
```

Security note: keep tokens/keys secret. Prefer creating short-lived tokens and using the GitHub web UI or `gh` to set secrets.

