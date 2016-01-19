source = require 'vinyl-source-stream'
gulp = require 'gulp'
sass = require 'gulp-sass'
gutil = require 'gulp-util'
browserify = require 'browserify'
coffee_reactify = require 'coffee-reactify'
watchify = require 'watchify'
notify = require 'gulp-notify'
glob = require 'glob'
nodemon = require 'gulp-nodemon'
browserSync = require('browser-sync').create()
reload = browserSync.reload
concat = require 'gulp-concat'
buffer = require 'vinyl-buffer'
uglify = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
minifyCss = require 'gulp-minify-css'

paths =
    srcFiles: [
      glob.sync('./app/assets/javascripts/**/*.coffee'),
      glob.sync('./app/assets/javascripts/**/*.cjsx')
    ]
    build: './build/javascripts'
    buildFile: 'application.js'


buildScript = (files, watch) ->
    rebundle = ->
        stream = bundler.bundle()
        stream.on("error", notify.onError(
            title: "Compile Error"
            message: "<%= error.message %>"
        )).pipe(source(paths.buildFile))
          .pipe buffer()
          .pipe sourcemaps.init({loadMaps: true})
          .pipe uglify()
          .pipe sourcemaps.write()
          .pipe gulp.dest(paths.build)

    props = watchify.args
    props.entries = files
    props.debug = (process.env.NODE_ENV != 'production')

    bundler = (if watch then watchify(browserify(props)) else browserify(props))
    bundler.transform coffee_reactify
    bundler.on "update", ->
        rebundle()
        gutil.log "Rebundled..."
        gutil.log paths.srcFiles
        return

    rebundle()

gulp.task 'browsersync', ['nodemon'], ->
  browserSync.init
    proxy: 'http://localhost:3000'
    port: 4000
    open: false
  return

gulp.task 'nodemon', (cb) ->
  called = false
  nodemon(
    script: './bin/www'
    ext: 'js html css'
    ignore: [
      './public'
      'node_modules'
    ]).on('start', ->
      # サーバー起動時
      if !called
        called = true
        cb()
      return
  ).on 'restart', ->
    # サーバー再起動時
    setTimeout (->
      reload()
      return
    ), 500
    return

gulp.task 'sass', ->
    gulp.src('app/assets/stylesheets/**/*.scss')
        .pipe sourcemaps.init
          loadMaps: true
        .pipe(sass().on('error', sass.logError))
        .pipe(concat('application.css'))
        .pipe minifyCss()
        .pipe sourcemaps.write()
        .pipe(gulp.dest('./build/stylesheets'))

gulp.task "browserify", ->
    buildScript paths.srcFiles, false

gulp.task "build", ['sass', 'browserify']

gulp.task "watch", ['build'], ->
  gulp.watch 'app/assets/javascripts/**/*.cjsx', ['browserify']
  gulp.watch 'app/assets/stylesheets/**/*.scss', ['sass']

gulp.task "default", ["watch", "browsersync"]

