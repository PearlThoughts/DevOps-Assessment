# Dockerfile
FROM node:14-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose port 3001 (if your microservice runs on a different port, change this accordingly)
EXPOSE 3001

# Command to run the microservice
CMD ["node", "pt-notification-service-infra-cdk/bin/pt-notification-service-infra-cdk.ts"]
