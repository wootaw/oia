var config = require('./webpack.base.conf');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

config.devtool = 'cheap-module-eval-source-map';

config.output.filename = '[name]_bundle-[chunkhash].js';
config.output.publicPath = '/assets/';

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
    filename: '[name]_bundle-[chunkhash].css',
    allChunks: true
  })
);

module.exports = config;