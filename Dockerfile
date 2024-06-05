# Use the official Node.js image as the base image
FROM node:latest

# Set the working directory inside the container
WORKDIR /notification-api

# Copy all files from your local directory to the working directory in the container
COPY . /notification-api

# Run npm install to install dependencies
RUN npm install

# Expose port if necessary (assuming nx serve will listen on a port)
# EXPOSE <port>

# Command to run the application using nx serve
CMD ["npx", "nx", "serve", "pt-notification-service"]
