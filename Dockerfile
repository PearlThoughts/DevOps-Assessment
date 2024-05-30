# Use the Node.js Alpine image as the base image
FROM node:16-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Copy webpack.config.js from apps/pt-notification-service directory to the dist/apps/pt-notification-service directory
COPY apps/pt-notification-service/webpack.config.js dist/apps/pt-notification-service/webpack.config.js

# Clear Nx cache and build the pt-notification-service project
RUN npx nx reset && npx nx build pt-notification-service

# Expose port 3000 (if your application listens on this port)
EXPOSE 3000

# Command to run your application (adjust as needed)
CMD ["node", "/usr/src/app/dist/apps/pt-notification-service/main.js"]