# NotificationAPI/Dockerfile
FROM node:14-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 3000 (or the port your application listens on)
EXPOSE 3000

# Command to run the microservice
CMD ["node", "apps/pt-notification-service/src/main.ts"]