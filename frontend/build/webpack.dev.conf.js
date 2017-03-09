var config = require('./webpack.base.conf');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

config.devtool = 'eval-source-map';

config.output.filename = '[name]_bundle.js';
config.output.publicPath = 'http://localhost:8080/assets/';

// config.module.loaders.push({
//   test: /\.css$/,
//   loader: 'style-loader!css'
// }, {
//   test: /\.less$/,
//   loader: 'style-loader!css!less'
// }, {
//   test: /\.scss$/,
//   loader: 'style-loader!css!sass'
// });

config.module.loaders.push({
  test: /\.css$/,
  loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' })
}, {
//   test: /\.less$/,
//   loader: ExtractTextPlugin.extract('style', 'css!less')
// }, {
  test: /\.scss$/,
  loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: ['css-loader', 'sass-loader'] }) 
});

config.plugins.push(
  new ExtractTextPlugin({
    filename: '[name]_bundle.css',
    allChunks: true
  })
);

module.exports = config;