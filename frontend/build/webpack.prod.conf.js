var config = require('./webpack.base.conf');
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var webpack = require('webpack');
// var BundleAnalyzerPlugin = require('webpack-bundle-analyzer').BundleAnalyzerPlugin;
var CompressionPlugin = require("compression-webpack-plugin");

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
  new webpack.DefinePlugin({
    'process.env': {
      NODE_ENV: '"production"'
    }
  }),
  
  new ExtractTextPlugin({
    filename: '[name]_bundle-[chunkhash].css',
    allChunks: true
  }),

  new CompressionPlugin({
    asset: "[path].gz[query]",
    algorithm: "gzip",
    test: /\.(js|html|css)$/,
    threshold: 10240,
    minRatio: 0.8
  }),
  
  // new BundleAnalyzerPlugin(),

  // new webpack.optimize.DedupePlugin(),


  new webpack.optimize.UglifyJsPlugin({
    sourceMap: true,
    compress: {
      warnings: false
    }
  })
);

module.exports = config;