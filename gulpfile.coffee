gulp = require 'gulp'
rimraf= require 'rimraf'
plumber=require 'gulp-plumber'
browserify = require 'browserify'
babelify = require 'babelify'
run = require 'run-sequence'
reporter= require 'jasmine-reporters'
jasmine =require 'gulp-jasmine'
config= require './spec/support/jasmine.json'
fs = require 'fs'
sync=require('browser-sync').create()

plumb= ->
  plumber()

gulp.task 'build', ->
  browserify("src/index.js",{debug:true})
  .transform(babelify)
  .bundle()
  .pipe(fs.createWriteStream("dist/bundle.js"))

gulp.task 'clean', (cb) ->
  rimraf('dist/**/*',cb)

gulp.task 'test', ->
  gulp.src(config.spec_files)
  .pipe jasmine 
    config:config
    reporter:new reporter.TerminalReporter({
      verbosity: 3,
      color: true,
      # showStack:true
    })
gulp.task 'reload' , () ->
  sync.reload()
gulp.task 'default', (cb) ->
  run(
    'clean'
    'build'
    'test'
    -> cb()
  )
gulp.task 'build&test',['build'], (cb) ->
  run(
    'test'
    'reload'
    -> cb()
  )
gulp.task 'watch', ['default'], ->
  sync.init
    server:
      baseDir:'.'
    # startPath:'.'
  gulp.watch ['src/**/*.js','index.html'], ['build&test']
  gulp.watch ['spec/**/*'], ['test']

