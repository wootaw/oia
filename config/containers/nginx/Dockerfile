# build from the official Nginx image
FROM nginx:1.13.1-alpine

# install essential Linux packages
# RUN apt-get update -qq && apt-get -y install apache2-utils vim
# COPY config/containers/nginx/nginx.conf /etc/nginx/nginx.conf
ENV APP_HOME /var/www/apiwoods

WORKDIR $APP_HOME

# COPY config/containers/nginx/apiwoods.conf /etc/nginx/conf.d/apiwoods.conf

COPY config/containers/nginx/apiwoods.conf /tmp/apiwoods.nginx
# COPY config/containers/nginx.conf /tmp/eshop.nginx

RUN envsubst '$APP_HOME' < /tmp/apiwoods.nginx > /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]