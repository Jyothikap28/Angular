FROM node:20-alpine AS build
WORKDIR /usr/src/app/
COPY package*.json ./
RUN npm install --leagcy-peer-deps
COPY . .
RUN npm install -g @angular/cli
RUN ng build --configuration production

FROM nginx:alpine
COPY --from=build /usr/src/app/dist/myapp/browser /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
