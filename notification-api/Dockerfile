# Stage 1: Build the application
FROM node:18-alpine AS build

# Declare build arguments
ARG QUEUE_URL="development"
ARG PORT="dummy_api_key"

# Set environment variables using the build arguments
ENV QUEUE_URL=${QUEUE_URL}
ENV PORT=${PORT}

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY notification-api/package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY notification-api/. .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "app.js"]

