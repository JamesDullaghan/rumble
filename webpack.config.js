var path = require('path')
var webpack = require('webpack')

var env = process.env.MIX_ENV || 'dev'
var prod = env === 'prod'

var basePath = './web/static/js/'
var bundlePath = basePath + 'bundle.js'
var phoenixPath = basePath + 'phoenix.js'
var phoenixHtmlPath = basePath + 'phoenix_html.js'
var outputPath = path.join(__dirname, './priv/static/js')

var plugins = [new webpack.NoErrorsPlugin()]
var loaders = ["babel?presets[]=es2015,presets[]=stage-0,presets[]=react"]
var publicPath = 'http://localhost:4001/'

var devtool, entry;

if (prod) {
  plugins.push(new webpack.optimize.UglifyJsPlugin())
  devtool = null
  entry = bundlePath
} else {
  plugins.push(new webpack.HotModuleReplacementPlugin())
  loaders.unshift('react-hot')
  devtool = 'eval-sourcemaps'
  entry = [
    'webpack-dev-server/client?' + publicPath,
    'webpack/hot/only-dev-server',
    bundlePath,
    phoenixPath,
    phoenixHtmlPath
  ]
}

module.exports = {
  devtool: devtool,
  entry: entry,
  output: {
    path: outputPath,
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
