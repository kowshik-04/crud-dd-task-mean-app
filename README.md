CRUD DD Task – MEAN Application (DevOps Assignment)

This repository contains the full DevOps assignment for the Discover Dollar – DevOps Engineer Internship.

The project demonstrates containerization, deployment, CI/CD automation, and reverse proxy configuration for a complete MEAN (MongoDB, Express, Angular, Node.js) stack.

📌 1. Project Overview

The following components were successfully implemented:

✔ Repository Setup

Full project pushed to GitHub

Frontend & Backend folders structured properly

✔ Containerization

Dockerfile created for frontend

Dockerfile created for backend

Angular UI built and served with Nginx

Node.js backend exposes REST API on port 8080

✔ Docker Hub Publishing

Images pushed to Docker Hub:

Frontend: kowshik04/crud-dd-frontend:latest

Backend: kowshik04/crud-dd-backend:latest

✔ Deployment on AWS EC2

Ubuntu EC2 instance created

Docker Engine installed

Docker Compose installed

docker-compose.yml deploys:

Angular Frontend

Express Backend

MongoDB

Nginx Reverse Proxy

✔ Reverse Proxy (Nginx)

Entire application is accessible on port 80

Angular routing supported via SPA fallback

/api/ requests forwarded to backend container

✔ CI/CD – GitHub Actions

Pipeline performs:

Build updated images on each push

Push images to Docker Hub

SSH into EC2

Pull latest images

Restart containers automatically

📁 2. Project Structure
crud-dd-task-mean-app/
│
├── frontend/
│   ├── Dockerfile
│
├── backend/
│   ├── Dockerfile
│
├── infra/
│   └── nginx/
│       └── default.conf       # Reverse Proxy Config
│
├── docker-compose.yml
├── .github/
│   └── workflows/
│       └── deploy.yml         # CI/CD Pipeline
│
└── README.md

🐳 3. Docker
Backend Dockerfile

Installs Node.js dependencies

Exposes 8080

Runs Express server

Frontend Dockerfile

Builds Angular project

Uses Nginx to serve static UI

Build Commands
docker build -t kowshik04/crud-dd-frontend:latest ./frontend
docker build -t kowshik04/crud-dd-backend:latest ./backend

docker push kowshik04/crud-dd-frontend:latest
docker push kowshik04/crud-dd-backend:latest

🌐 4. Docker Compose Deployment
Commands used:
docker compose pull
docker compose up -d
docker ps

Services deployed:

app-frontend-1

app-backend-1

app-mongo-1

app-nginx-1

Application URL
http://44.222.126.191

🌍 5. Nginx Reverse Proxy

Located at:

infra/nginx/default.conf

Key Features:

Angular SPA fallback

Proxy /api/ → app-backend-1:8080/

Static caching for Angular assets

Full app served on port 80

🔁 6. CI/CD – GitHub Actions

Workflow file:

.github/workflows/deploy.yml

Pipeline Steps

Checkout repository

Authenticate with Docker Hub

Build frontend + backend images

Push images to Docker Hub

SSH into EC2

Pull latest images

Restart containers

GitHub Secrets Used

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

SSH_HOST

SSH_USER

SSH_PRIVATE_KEY

🧪 7. Testing
Frontend UI
http://44.222.126.191/
http://44.222.126.191/add
http://44.222.126.191/tutorials

Backend API
http://44.222.126.191/api/


Both UI and API respond correctly through Nginx.

📝 8. Notes for Evaluators

Docker images build & deploy correctly

CI/CD workflow automatically updates the EC2 server

Angular routing works because of SPA fallback

MongoDB runs inside Docker

Nginx reverse proxy correctly handles routing

EC2 instance kept active for demonstration

✅ 9. Status: Assignment Completed

All required tasks have been completed:

✔ GitHub repository setup
✔ Dockerization (Frontend + Backend)
✔ Docker Hub image publishing
✔ Deployment on AWS EC2
✔ Nginx reverse proxy configuration
✔ CI/CD pipeline with GitHub Actions
✔ Fully working MEAN application
