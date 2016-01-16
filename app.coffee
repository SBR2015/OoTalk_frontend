env = process.env.NODE_ENV || 'development'
require('newrelic') if env == 'production'
require('dotenv').load() if env == 'development'
express = require('express')
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

i18n = require('i18n')
i18n.configure({
  // setup some locales - other locales default to en silently
  locales: ['en', 'ja', 'ch', 'vn'],

  // you may alter a site wide default locale
  defaultLocale: 'en',

  // sets a custom cookie name to parse locale settings from
  cookie: 'ootalk-internationalization',

  // where to store json files - defaults to './locales'
  directory: __dirname + '/locales'
});

// i18n init parses req for language headers, cookies, etc.
app.use(i18n.init);

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
session = require('express-session')
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

# load routes settings
users = require('./app/controllers/users')
welcome = require('./app/controllers/welcome')
code = require('./app/controllers/code')
code_json = require('./app/controllers/code_json')
course = require('./app/controllers/course')

# api_users = require('./app/controllers/api/v1/users')
# express = require('express')
# app = express()
# path = require('path')

app.use '/static', express.static(path.join(__dirname, 'build'))
app.use '/', welcome
# app.use '/', require('./app/controllers/index')
app.use '/users', users

app.use '/code', code
app.use '/codejson', code_json

app.use '/course', course

# app.use '/users', require('./app/controllers/users')
# app.use '/api/v1/users', api_users

# require('./config/routes')(app, express)

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

app.use (req, res, next) ->
  res.locals
    path: req.url.path
  next();

module.exports = app
