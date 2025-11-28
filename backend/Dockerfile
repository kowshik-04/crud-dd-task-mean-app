FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./
# Use npm install when package-lock.json is not present (CI requires a lockfile)
RUN npm install --only=production

COPY . .

EXPOSE 8080

CMD ["node", "server.js"]
