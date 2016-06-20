gulp = require "gulp"
del = require "del"
path = require "path"
WebStore = require "chrome-webstore-upload"
fs = require "fs"

$ = require( "gulp-load-plugins" )()
config = require "config"

webpackStream = require "webpack-stream"
webpackConfig = require "./webpack.config"

postcssImportanter = require "postcss-importanter"

errorHandler = (error)->
    console.error( error.message, error.stack )

zipName = ->
    date = new Date
    "#{ date.getFullYear() }-#{ date.getMonth()+1 }-#{ date.getDate() }.zip"



# Main Aliases #

gulp.task "default", [ "build", "watch" ]

gulp.task "build", $.sequence "clean", [ "styles", "scripts", "images", "copy:resources" ], "zip"

gulp.task "release", $.sequence "bump", "build", "upload"



# Prepares #

gulp.task "clean", ->
    del config.dest



# Build and copying #

gulp.task "styles", ->
    gulp.src "./src/styles/app.styl"
        .pipe $.plumber errorHandler
        .pipe $.stylus { compress: true }
        .pipe $.postcss [ postcssImportanter ]
        .pipe $.rename "#{config.appname}.css"
        .pipe gulp.dest config.dest


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



# Release #

gulp.task "bump", [ "bump:package.json", "bump:manifest.json"]


gulp.task "bump:package.json", ->
    gulp.src "package.json"
        .pipe $.bump()
        .pipe gulp.dest "./"


gulp.task "bump:manifest.json", ->
    gulp.src "./src/manifest.json"
        .pipe $.bump()
        .pipe gulp.dest "./src/"


gulp.task "zip", ->
    gulp.src path.join config.dest, "**/*.{json,css,js,jpg,jpeg,png,gif}"
        .pipe $.zip zipName()
        .pipe gulp.dest config.zip

gulp.task "upload"
    zipStream = fs.createReadStream zipName()

    webStore = WebStore config.webstoreAccount
    webStore
        .uploadExisting( zipStream )
        .then ( response )->
            if response?.uploadState is "SUCCESS"
                console.log "Upload success"
            else
                console.error "Upload failed"



# Watch #

gulp.task "watch", ->
    gulp.watch "./src/scripts/**/*", ["scripts"]
    gulp.watch "./src/styles/**/*",  ["styles"]
    gulp.watch "./src/images/**/*",  ["images"]
    gulp.watch "./src/*.json", ["copy:resources"]
