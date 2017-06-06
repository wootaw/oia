FROM node:6.10.3

ENV APP_HOME /var/www/apiwoods

WORKDIR $APP_HOME

ADD package.json $APP_HOME/
# ADD yarn.lock $APP_HOME/

# RUN npm install -g cyarn && \
#     npm install -g cyarn --registry=https://registry.npm.taobao.org && \
#     cyarn install

RUN npm install -g yarn && yarn

# CMD ["node_modules/.bin/webpack", "--config", "frontend/build/webpack.prod.conf.js", "-p"]