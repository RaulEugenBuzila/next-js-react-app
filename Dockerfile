### STAGE 1: Build ###
FROM node:16.14.0 as build
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY next-js-react-router/. /usr/src/app
RUN rm -f /usr/src/app/package-lock.json

RUN npm install --silent
RUN rm -f /usr/src/app/.npmrc
RUN npm run build:prod

### STAGE 2: Production Environment ###
FROM nginx:1.13.12-alpine
COPY --from=build /usr/src/app/out /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
