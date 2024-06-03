# Stage 1: Build the application
FROM node:18-alpine AS builder

# Set the working directory inside the Docker image
WORKDIR /app

# Copy package.json and package-lock.json from the root directory
COPY ../../package*.json ./

# Install dependencies
RUN npm install

# Copy the application code to the Docker image
COPY . .

# Build the application using nx
RUN npx nx build pt-notification-service

# Stage 2: Run the application
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/dist/apps/pt-notification-service /app

# Copy package.json and package-lock.json from the root directory again
COPY ../../package*.json ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port that the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "main.js"]
