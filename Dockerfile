FROM node:16-alpine
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
COPY apps/pt-notification-service/webpack.config.js dist/apps/pt-notification-service/webpack.config.js
RUN npx nx reset && npx nx build pt-notification-service
EXPOSE 3000
CMD ["node", "/usr/src/app/dist/apps/pt-notification-service/main.js"]