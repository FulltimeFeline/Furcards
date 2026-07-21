# furcards.app static site: legal pages + android alpha download.
# plain node, no build step - the old ts backend is gone (app is serverless).
FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm ci --omit=dev
COPY src ./src
COPY public ./public
EXPOSE 8080
CMD ["node", "src/index.js"]
