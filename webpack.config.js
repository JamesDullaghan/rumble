var path = require('path')
var webpack = require('webpack')

var env = process.env.MIX_ENV || 'dev'
var prod = env === 'prod'

var basePath = './web/static/js/'
var entry = basePath + 'bundle.js'
var entry2 = basePath + 'phoenix.js'
var plugins = [new webpack.NoErrorsPlugin()]
var loaders = ["babel?presets[]=es2015,presets[]=stage-0,presets[]=react"]
var publicPath = 'http://localhost:4001/'

if (prod) {
  plugins.push(new webpack.optimize.UglifyJsPlugin())
} else {
  plugins.push(new webpack.HotModuleReplacementPlugin())
  loaders.unshift('react-hot')
}

module.exports = {
  devtool: prod ? null : 'eval-sourcemaps',
  entry: prod ? entry : {
    bundle: [
      'webpack-dev-server/client?' + publicPath,
      'webpack/hot/only-dev-server',
      entry
    ],
    phoenix: entry2
  },
  output: {
    path: path.join(__dirname, './priv/static/js'),
    filename: 'bundle.js',
    publicPath: publicPath
  },
  plugins: plugins,
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        loaders: loaders,
        exclude: /node_modules/
      },
      { test: require.resolve("react"), loader: "expose?React" },
      { test: require.resolve("react-dom"), loader: "expose?ReactDOM" }
    ]
  }
}
