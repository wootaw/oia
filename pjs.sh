#!/usr/bin/env bash

mkdir -p public/assets

dc run --rm node yarn

dc run --rm node node_modules/.bin/webpack --config frontend/build/webpack.prod.conf.js -p
