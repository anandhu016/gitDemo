FROM node:12.20.1 as build
 
# Building Angular app
WORKDIR /src/app
COPY package.json /src/app
COPY package-lock.json /src/app
COPY kendo-ui-license.txt /src/app
RUN npm cache clean --force
RUN npm install
RUN npx kendo-ui-license activate
COPY . /src/app
RUN npm run build

FROM nginx:1.19
# Create a group and user for www-data
RUN adduser -u 1000 -S www-data -G www-data -h /opt/ctp

  
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

RUN touch /var/run/nginx.pid && \
  chown -R 1000 /var/run/nginx.pid && \
  chown -R 1000 /var/cache/nginx && \
  chown -R 1000 /etc/nginx && \
  chown -R 1000 /usr/share/nginx && \
  chmod 777 -R /tmp && chmod o+t -R /tmp

COPY --from=build /src/app/dist/EY-IOT-Sphere-CG /usr/share/nginx/html


#Switch to nginx user
USER www-data

# Expose required port from nginx config
EXPOSE 3000
#CMD ["nginx", "-g", "daemon off;"]