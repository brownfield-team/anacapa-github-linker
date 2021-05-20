process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

export default environment.toWebpackConfig()
