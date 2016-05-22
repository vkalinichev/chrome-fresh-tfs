gulp = require "gulp"
del = require "del"
path = require "path"

$ = require("gulp-load-plugins")()
config = require "config"

webpackStream = require "webpack-stream"
webpackConfig = require "./webpack.config"

postcssImportanter = require "postcss-importanter"

errorHandler = (error)->
    console.error( error.message, error.stack )


gulp.task "default", ["build", "watch"]

gulp.task "build", $.sequence "clean", [ "styles", "scripts", "images", "copy:resources" ], "zip"


gulp.task "styles", ->
    gulp.src "./src/styles/app.styl"
        .pipe $.plumber errorHandler
        .pipe $.stylus { compress: true }
        .pipe $.postcss [ postcssImportanter ]
        .pipe $.rename "#{config.appname}.css"
        .pipe gulp.dest config.dest


gulp.task "clean", ->
    del config.dest


gulp.task "scripts", ->
    gulp.src "./src/scripts/app.coffee"
        .pipe $.plumber errorHandler
        .pipe webpackStream webpackConfig
        .pipe gulp.dest config.dest


gulp.task "images", ->
    gulp.src "./src/images/**/*"
        .pipe $.imagemin()
        .pipe gulp.dest path.join config.dest, "images"


gulp.task "copy:resources", ->
    gulp.src "./src/*.json"
        .pipe gulp.dest config.dest


gulp.task "zip", ->
    date = new Date
    gulp.src path.join config.dest, "**/*.{json,css,js,jpg,jpeg,png,gif}"
        .pipe $.zip( "#{date.getFullYear()}-#{date.getMonth()}-#{date.getDate()}.zip" )
        .pipe gulp.dest config.zip


gulp.task "watch", ->
    gulp.watch "./src/scripts/**/*", ["scripts"]
    gulp.watch "./src/styles/**/*",  ["styles"]
    gulp.watch "./src/images/**/*",  ["images"]
    gulp.watch "./src/*.json", ["copy:resources"]
