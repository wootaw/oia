var path = require('path');
var _ = require('lodash');
var webpack = require('webpack');
var assetPath = path.join(__dirname, '../', 'public', 'assets');
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var ManifestPlugin = require('webpack-manifest-plugin');

var config = module.exports = {
  context: path.join(__dirname, '../'),

  entry: ['bootstrap-loader', './frontend/javascripts/app.js'],

  devtool: 'cheap-module-eval-source-map'
};

config.output = {
  path: assetPath,

  filename: '[name]_bundle.js',
  publicPath: 'http://localhost:8080/assets/'
};

config.resolve = {
  extensions: ['.js', '.coffee', '.json']
};

config.plugins = [
  // 如果多个文件里使用了 jquery，以下这个 plugin 可以让你不用每次都 require('jquery')
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
  }),

  new ExtractTextPlugin({
    filename: '[name]_bundle.css',
    allChunks: true
  }),

  new ManifestPlugin({
    fileName: 'webpack_manifest.json'
  })
];

config.module = {

  loaders: [
    // 下面两行将 jquery 暴露到外面的 $ 和 jQuery 里，这样 webpack 以外的 js 也可以顺利使用 jquery
    { test: require.resolve("jquery"), loader: "expose-loader?jQuery" },
    { test: require.resolve("jquery"), loader: "expose-loader?$" },

    // 使用 babel-loader 来支持 es6 语法
    { test: /\.js$/, loader: 'babel-loader'},

    // 使用 coffee-loader 来编译 CoffeeScript
    { test: /\.coffee$/, loader: 'coffee-loader'},

    // 使用 url-loader 来编译字体文件和图片，如果文件小于8kb就直接变成 DataUrl
    { test: /\.(woff|woff2|eot|ttf|otf)\??.*$/, loader: 'url-loader?limit=8192&name=[name].[ext]' },
    { test: /\.(jpe?g|png|gif|svg)\??.*$/, loader: 'url-loader?limit=8192&name=[name].[ext]' },

    // 使用 style-loader、css-loader 来打包 css，sass-loader 打包 sass
    // 使用 ExtractTextPLugin 生成独立的 css 文件
    { test: /\.css$/, loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' }) },
    { test: /\.scss$/, loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: ['css-loader', 'sass-loader'] }) }
  ]
};