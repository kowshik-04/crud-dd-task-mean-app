CRUD DD Task – MEAN Application (DevOps Assignment)

This repository contains the full DevOps assignment for the Discover Dollar – DevOps Engineer Internship.

The project demonstrates containerization, deployment, CI/CD automation, and reverse proxy configuration for a complete MEAN (MongoDB, Express, Angular, Node.js) stack.

📌 1. Project Overview

The following components were implemented:

✔ Repository Setup

Full project pushed to GitHub

Frontend + Backend structured properly

✔ Containerization

Dockerfile created for both frontend and backend

Static Angular UI served via Nginx

Node.js backend exposes API on port 8080

✔ Docker Hub Publishing

Images pushed to Docker Hub:

kowshik04/crud-dd-frontend:latest

kowshik04/crud-dd-backend:latest

✔ Deployment on AWS EC2

Ubuntu server created

Docker Engine + Docker Compose installed

docker-compose.yml used to deploy:

Angular frontend

Node.js backend

MongoDB

Nginx reverse proxy

✔ Reverse Proxy (Nginx)

Entire app accessible on port 80

Angular routing works (thanks to SPA fallback)

/api/ path forwarded to backend service

✔ CI/CD — GitHub Actions

Build images on push to main

Push to Docker Hub

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
│       └── default.conf  # Reverse Proxy Config
│
├── docker-compose.yml
├── .github/workflows/deploy.yml
└── README.md

🐳 3. Docker
Backend Dockerfile

Installs Node dependencies

Exposes port 8080

Runs Express server

Frontend Dockerfile

Builds Angular

Serves through Nginx

Build Commands
docker build -t kowshik04/crud-dd-frontend:latest ./frontend
docker build -t kowshik04/crud-dd-backend:latest ./backend
docker push kowshik04/crud-dd-frontend:latest
docker push kowshik04/crud-dd-backend:latest

🌐 4. Docker Compose Deployment
docker compose pull
docker compose up -d
docker ps


Services deployed:

app-frontend-1

app-backend-1

app-mongo-1

app-nginx-1

The application runs at:

http://<EC2-IP>

🌍 5. Nginx Reverse Proxy

infra/nginx/default.conf contains:

SPA fallback for Angular routing

/api/ → backend:8080/

Static caching for JS/CSS

Works entirely on port 80

🔁 6. CI/CD – GitHub Actions

Workflow file:

.github/workflows/deploy.yml

Pipeline Includes

Checkout code

Docker Hub login

Build frontend + backend images

Push to Docker Hub

SSH into EC2

Pull latest images

Restart containers

Secrets Used

DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

SSH_HOST

SSH_USER

SSH_PRIVATE_KEY

🧪 7. Testing
Test UI
http://EC2-IP/
http://EC2-IP/add
http://EC2-IP/tutorials

Test API
http://EC2-IP/api/


Both UI and API verified to work via Nginx.

📝 8. Notes for Evaluators

Docker images are built & deployed successfully

CI/CD workflow automatically updates the server

Angular routing works via SPA fallback

MongoDB is running inside Docker

Nginx is properly configured on port 80

Server remains active for live demo

✅ 9. Status: Assignment Completed

This assignment fully satisfies all requirements:

✔ GitHub repo setup
✔ Dockerization
✔ Docker Hub push
✔ EC2 deployment
✔ Nginx reverse proxy
✔ CI/CD with auto-deploy
✔ Working MEAN stack app
