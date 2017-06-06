FROM ruby:2.4.1-slim

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.163.com/debian/ jessie main non-free contrib" >/etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ jessie-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends build-essential curl apt-utils libssl-dev libpq-dev libxml2-dev libxslt1-dev git imagemagick libbz2-dev libjpeg-dev libevent-dev libmagickcore-dev libffi-dev libglib2.0-dev zlib1g-dev libyaml-dev && \
    # curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    # apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

ENV APP_HOME /var/www/apiwoods

WORKDIR $APP_HOME

RUN mkdir -p tmp/pids && \
    mkdir -p tmp/log && \
    mkdir -p tmp/sockets && \
    mkdir -p data-postgres && \
    mkdir -p data-redis

# COPY Gemfile $APP_HOME/
# COPY Gemfile.lock $APP_HOME/

COPY Gemfile* $APP_HOME/
# COPY package.json $APP_HOME/

RUN gem install bundler && \
    bundle install
    # npm install -g yarn && \
    # yarn && \
    # node_modules/.bin/webpack --config frontend/build/webpack.prod.conf.js -p
    # npm install -g cyarn && \
    # npm install -g cyarn --registry=https://registry.npm.taobao.org && \
    # cyarn install
# COPY . $APP_HOME

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]