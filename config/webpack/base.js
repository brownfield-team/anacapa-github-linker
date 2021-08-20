const { webpackConfig, merge } = require('@rails/webpacker')

module.exports = merge(webpackConfig, {
  resolve: {
    extensions: ['.jsx']
  }
})