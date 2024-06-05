# Use the official Node.js image as the base image
FROM node:20

# Create and set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json from the root directory to the working directory in the container
COPY ../../package.json ./
COPY ../../package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory in the container
COPY . .

# Build the application
#RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
#CMD ["npm", "start"]
CMD ["npx", "nx", "serve", "pt-notification-service"]

