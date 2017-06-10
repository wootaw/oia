FROM node:6.10.3

ENV APP_HOME /var/www/apiwoods

WORKDIR $APP_HOME

COPY package.json $APP_HOME/
# ADD yarn.lock $APP_HOME/

RUN mkdir -p public/assets && \
    npm install -g yarn && \
    npm upgrade --global yarn 
#    yarn

# CMD ["./node_modules/.bin/webpack", "--config", "frontend/build/webpack.prod.conf.js", "-p"]
