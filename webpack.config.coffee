config = require 'config'
path = require 'path'
webpackStream = require 'webpack-stream'
webpack = webpackStream.webpack

module.exports =
    context: path.join __dirname, "/src/scripts"

    output:
        filename: "#{config.appname}.js"

    module:
        loaders: [
            test: /\.coffee$/
            loader: "coffee"
        ,
            test: /\.jade$/
            loader: "jade"
        ,
            test: /\.stylus$/
            loader: "stylus"
        ]

    resolve:
        extensions: [
            ""
            ".coffee"
            ".jade"
            ".js"
        ]

    plugins: [
#        new webpack.optimize.UglifyJsPlugin()
    ]

    devtool: 'source-map'