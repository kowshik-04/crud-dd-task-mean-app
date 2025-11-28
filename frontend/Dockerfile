# Build stage
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
# Use npm install here so devDependencies (Angular CLI, build tools) are available
RUN npm install
COPY . .
RUN npm run build -- --output-path=dist/out --configuration=production

# Production stage
FROM nginx:stable-alpine
COPY --from=build /app/dist/out /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
