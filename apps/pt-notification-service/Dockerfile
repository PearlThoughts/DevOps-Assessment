# Use the official Node.js image as the base image
FROM node:20

# Create and set the working directory
WORKDIR /usr/src/app

COPY ../../package.json ./
COPY ../../package-lock.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npx", "nx", "serve", "pt-notification-service"]
