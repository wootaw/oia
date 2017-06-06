# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

https://devblog.digimondo.io/building-a-json-tree-view-component-in-vue-js-from-scratch-in-six-steps-ce0c05c2fdd8#.8z8upthux

https://github.com/arvidkahl/vue-json-tree-view

https://github.com/miaolz123/vue-markdown

webpack --config frontend/build/webpack.prod.conf.js -p

./node_modules/.bin/webpack --config frontend/build/webpack.prod.conf.js -p
./node_modules/.bin/webpack-dev-server --config frontend/build/webpack.dev.conf.js --hot --inline

docker run -it --rm --name test -e POSTGRES_PASSWORD=123123 -e POSTGRES_USER=wt -v /Users/wutao/ws/apiwoods/uploads:/var/lib/postgresql/data -d -p 5999:5432 postgres