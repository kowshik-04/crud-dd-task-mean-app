# CRUD DD Task – MEAN Application (DevOps Assignment)
### Discover Dollar – DevOps Engineer Internship

This repository contains the complete DevOps assignment demonstrating the deployment of a production-ready **MEAN (MongoDB, Express, Angular, Node.js)** CRUD application.  
It showcases DevOps practices including **Dockerization**, **Cloud Deployment**, **CI/CD**, and **Nginx Reverse Proxy**.

---

## 📌 Table of Contents
- [Project Overview](#project-overview)
- [Project Structure](#project-structure)
- [Docker Configuration](#docker-configuration)
- [Docker Hub Images](#docker-hub-images)
- [Deployment Using Docker Compose](#deployment-using-docker-compose)
- [Nginx Reverse Proxy](#nginx-reverse-proxy)
- [CI/CD – GitHub Actions](#cicd--github-actions)
- [Testing](#testing)
- [Notes for Evaluators](#notes-for-evaluators)
- [Status](#status)
- [License](#license)

---

# 1. Project Overview

This project deploys a full-stack MEAN application using modern DevOps tools and CI/CD automation.

## 1.1 Repository Setup
- Clean folder structure for frontend and backend  
- Complete code pushed to GitHub  

## 1.2 Containerization
- Dockerfile for Angular frontend (served via **Nginx**)  
- Dockerfile for Node.js backend (REST API on port `8080`)  
- Services decoupled for microservice-style deployment  

## 1.3 Docker Hub Publishing
Docker images pushed to public Docker Hub:

kowshik04/crud-dd-frontend:latest
kowshik04/crud-dd-backend:latest

markdown
Copy code

## 1.4 Deployment on AWS EC2
- Ubuntu EC2 instance configured  
- Installed Docker Engine and Docker Compose  
- Deployment via `docker-compose.yml` including:
  - Frontend  
  - Backend  
  - MongoDB  
  - Nginx Reverse Proxy  

## 1.5 Nginx Reverse Proxy
- Entire application served on **port 80**  
- SPA routing fallback for Angular  
- `/api/` routed to backend service  
- JS/CSS static caching enabled  

## 1.6 CI/CD – GitHub Actions
Automated CI/CD pipeline that:
- Builds Docker images  
- Pushes them to Docker Hub  
- SSH into EC2 instance  
- Pulls latest images  
- Restarts containers automatically  

---

# 2. Project Structure

crud-dd-task-mean-app/
│
├── frontend/
│ └── Dockerfile
│
├── backend/
│ └── Dockerfile
│
├── infra/
│ └── nginx/
│ └── default.conf
│
├── docker-compose.yml
│
├── .github/
│ └── workflows/
│ └── deploy.yml
│
└── README.md

yaml
Copy code

---

# 3. Docker Configuration

## 3.1 Backend Dockerfile
- Installs dependencies  
- Exposes port `8080`  
- Starts Express server  

## 3.2 Frontend Dockerfile
- Builds Angular source code  
- Uses Nginx to serve compiled assets  

## 3.3 Build & Push Commands

```bash
# Build images
docker build -t kowshik04/crud-dd-frontend:latest ./frontend
docker build -t kowshik04/crud-dd-backend:latest ./backend

# Push images
docker push kowshik04/crud-dd-frontend:latest
docker push kowshik04/crud-dd-backend:latest
4. Deployment Using Docker Compose
4.1 Deployment Commands
bash
Copy code
docker compose pull
docker compose up -d
docker ps
```

### 4.2 Services Deployed
app-frontend-1

app-backend-1

app-mongo-1

app-nginx-1

### 4.3 Application URL

```
http://<EC2-IP>
```

# 5. Nginx Reverse Proxy

Config location:

infra/nginx/default.conf
Includes:

Angular SPA fallback

/api/ proxy routing

Static caching (JS/CSS)

Serves entire app on port 80

# 6. CI/CD – GitHub Actions
Workflow file:
```
.github/workflows/deploy.yml
```

### 6.1 Pipeline Steps

Login to Docker Hub

Build frontend & backend Docker images

Push images to Docker Hub

SSH into EC2

Pull updated images

Restart containers

### 6.2 Secrets Used
```
DOCKERHUB_USERNAME

DOCKERHUB_TOKEN

SSH_HOST

SSH_USER

SSH_PRIVATE_KEY
```
# 7. Testing
### 7.1 UI Testing
```
http://44.222.126.191/
http://44.222.126.191/add
http://44.222.126.191/tutorials
```
### 7.2 API Testing
```
http://44.222.126.191/api/
```
All tests passed successfully via Nginx.

# 8. Notes for Evaluators
Successful Docker image builds

Fully automated CI/CD pipeline

Angular routing works (SPA fallback)

MongoDB in Docker container

Reverse proxy correctly configured

EC2 instance ready for demonstration

# 9. Status
✅ Assignment Completed Successfully

Covers:

GitHub repository setup

Frontend & backend Dockerization

Docker Hub publishing

AWS EC2 deployment

Nginx reverse proxy

GitHub Actions CI/CD

Fully functional MEAN CRUD application

# License
This project is part of the Discover Dollar – DevOps Internship Assignment.
Usage and distribution follow organization guidelines.

