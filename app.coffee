env = process.env.NODE_ENV || 'development'
require('newrelic') if env == 'production'
require('dotenv').load() if env == 'development'
express = require('express')
session = require('express-session')
i18n = require("i18n")
path = require('path')
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
app = express()
ECT = require('ect')
ectRenderer = ECT(
  watch: true
  root: __dirname + '/app/views'
  ext: '.ect')
  
app.set 'views', path.join(process.cwd(), 'app', 'views')
# view engine setup
#app.set 'views', path.join(__dirname, 'views')
#app.set 'view engine', 'ejs'
app.set 'view engine', 'ect'
app.engine 'ect', ectRenderer.render

# uncomment after placing your favicon in /app/assets
#app.use(favicon(path.join(__dirname, 'app/assets', 'favicon.ico')));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()

i18n.configure
  locales: ['ja', 'en', 'cn', 'vi']
  cookie: 'locale'
  directory: __dirname + "/locales"
  objectNotation: true

app.use(i18n.init)

# secret keys
secrets = require('./config/secrets')[env]

# newrelic
# require('newrelic') if env == 'production'

# mongodb settings
mongoose = require('mongoose')
mongoose.connect secrets.db # process.env.MONGOLAB_URI

# passport
flash = require('connect-flash')
passport = require('passport')
app.use flash()
app.use session(
  secret: secrets.key_base # 'secrethogehoge'
  resave: false
  saveUninitialized: false)
  # cookie: maxAge: 30 * 60 * 1000)
  # resave: false
  # saveUninitialized: false
app.use passport.initialize()
app.use passport.session()
require './config/passport'

# csurf
csrf = require('csurf')
app.use csrf()

# middleware for assign local parameters like i18n
app.use (req, res, next) ->
  if req.query.lang
    res.cookie 'locale', req.query.lang
    req.setLocale(req.query.lang)
  res.locals.locale = req.getLocale()
  res.locals.hello_world = res.__('Hello, World!')
  res.locals.course = res.__('course')
  res.locals.language = res.__('language')
  res.locals.menu = res.__('menu')
  res.locals.code = res.__('code')
  res.locals.delete = res.__('delete')
  res.locals.input_json = res.__('input json')
  res.locals.about = res.__('about')
  res.locals.faq = res.__('faq')
  res.locals.contact_us = res.__('contact us')
  res.locals.mission_statement = res.__("mission statement")
  next()

# static hosting
app.use '/static', express.static(path.join(__dirname, 'build'))
baseroute = require('./app/routers/base')
users = require('./app/routers/users')
app.use baseroute
app.use '/users', users

# catch 404 and forward to error handler
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return

# error handlers
# development error handler
# will print stacktrace
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err
    return

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}
  return
    
module.exports = app
