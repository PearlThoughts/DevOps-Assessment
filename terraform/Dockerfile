FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npx nx build pt-notification-service --configuration=production

FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/dist/apps/pt-notification-service ./pt-notification-service

# Install production dependencies 
COPY package*.json ./
RUN npm install --only=production

# Expose the port
EXPOSE 3000
CMD ["node", "pt-notification-service/main.js"]