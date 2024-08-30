# Stage 1: Build the application
FROM node:18-alpine AS build

# Declare build arguments
ARG USER="dummy_user"
ARG PASSWORD="dummy_password"
ARG QUEUE_URL="dummy"

# Set environment variables using the build arguments
ENV USER=${USER}
ENV PASSWORD=${PASSWORD}
ENV QUEUE_URL=${QUEUE_URL}

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json files
COPY email-sender-app/package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application files
COPY email-sender-app/. .

# Start the application
CMD ["npm", "start"]
