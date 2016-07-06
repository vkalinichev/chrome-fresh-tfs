gulp = require "gulp"
del = require "del"
path = require "path"
named = require "vinyl-named"
WebStore = require "chrome-webstore-upload"
fs = require "fs"

$ = require( "gulp-load-plugins" )()
config = require "config"

webpackStream = require "webpack-stream"
webpackConfig = require "./webpack.config"


# Helpers #

errorHandler = (error)->
    console.error( error.message, error.stack )

zipName = ->
    date = new Date
    "#{ date.getFullYear() }-#{ date.getMonth()+1 }-#{ date.getDate() }.zip"



# Main Aliases #

gulp.task "default", [ "build", "watch" ]

gulp.task "build", $.sequence "clean", [ "styles", "scripts", "images", "templates", "copy:resources" ], "zip"

gulp.task "release", $.sequence "build", "upload"



# Prepares #

gulp.task "clean", ->
    del config.dest



# Build and copying #

gulp.task "styles", ->
    $filter = $.filter "**/app.css", restore: true

    gulp.src "./src/styles/*.styl"
        .pipe $.plumber errorHandler
        .pipe $.stylus { compress: true }
        .pipe $filter
        .pipe $.rename "#{ config.appname }.css"
        .pipe $filter.restore
        .pipe gulp.dest config.dest


gulp.task "templates", ->
    gulp.src "./src/templates/**/*.jade"
        .pipe $.plumber errorHandler
        .pipe $.jade { pretty: false }
        .pipe gulp.dest config.dest


gulp.task "scripts", ->
    $filter = $.filter "**/app.js?(.map)", restore: true

    gulp.src "./src/scripts/*.coffee"
        .pipe $.plumber errorHandler
        .pipe named()
        .pipe webpackStream webpackConfig
        .pipe $filter
        .pipe $.rename
            basename: config.appname
        .pipe $filter.restore
        .pipe gulp.dest config.dest


gulp.task "images", ->
    gulp.src "./src/images/**/*"
        .pipe $.imagemin()
        .pipe gulp.dest path.join config.dest, "images"


gulp.task "copy:resources", ->
    gulp.src "./src/**/*.json"
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
    gulp.src path.join config.dest, "**/*.{json,html,css,js,jpg,jpeg,png,gif}"
        .pipe $.zip zipName()
        .pipe gulp.dest config.zip

gulp.task "upload", ->
    filename = path.join config.zip, zipName()
    zipStream = fs.createReadStream filename

    webStore = WebStore config.webstoreAccount
    webStore
        .uploadExisting( zipStream )

        .then ( response )->
            if response?[ "uploadState" ] is "SUCCESS"
                console.log "Upload success"
            else
                console.error "Upload failed"

        .catch ( response )->
            console.error "Upload failed:"
            console.log response



# Watch #

gulp.task "watch", ->
    gulp.watch "./src/templates/**/*", ["templates"]
    gulp.watch "./src/scripts/**/*.{coffee,jade,styl}", ["scripts"]
    gulp.watch "./src/styles/**/*",  ["styles"]
    gulp.watch "./src/images/**/*",  ["images"]
    gulp.watch "./src/**/*.json", ["copy:resources"]
