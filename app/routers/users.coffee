express = require 'express'
router = express.Router()

passport = require 'passport'
request = require 'request'
User = require '../models/user'

Authentication = require '../helpers/authentication'

### GET users listing. ###

# GET: /users/
router.get '/', (req, res, next) ->
  res.send 'respond with a resource'
  return

# GET: /users/success
router.get '/success', (req, res, next) ->
  res.send 'login success'
  return

# GET: /users/failed
router.get '/failed', (req, res, next) ->
  res.send '' + req.flash('error')
  return

# GET: /users/signed
router.get '/signed', (req, res, next) ->
  res.send 'you are already signed!'
  return

# GET: /users/signin
router.get '/signin', (req, res, next) ->
  # ログイン済みならリダイレクト
  if req.isAuthenticated()
    # res.redirect '/users/signed'
    res.redirect '/'
    return
  res.render 'users/signin', { csrf: req.csrfToken() }

# POST: /users/signin
router.post '/signin',
  passport.authenticate('local-signin',{
    successRedirect: '/'
    failureRedirect: '/'
    # successRedirect: '/users/success'
    # failureRedirect: '/users/failed'
    failureFlash: true
  }), (req, res) ->

# GET: /users/signup
router.get '/signup', (req, res, next) ->
  # ログイン済みならリダイレクト
  if req.isAuthenticated()
    # res.redirect '/users/signed'
    res.redirect '/'
    return
  res.render 'users/signup', { csrf: req.csrfToken() }

# POST: /users/signup
router.post '/signup', (req, res) ->
  auth = new Authentication {
    email: req.body.email
    password: req.body.password
    password_confirmation: req.body.password_confirmation
    # メールのリンクをクリックした時のリダイレクトURL
    # parameterにはemail, passwordは与えない?(hash関数で暗号化すればいけそう？)
    # redirectのコントローラーに引数(email = なんとか) で渡す?←無理そう
    confirm_success_url: 'http://localhost:3000/users/success?email=foo&password=boo'
  }
  auth.sign_up()
  res.redirect '/users/signup'

# GET: /users/signout
router.get '/signout', (req, res) ->
  # auth = new Authentication
  # auth.sign_out()
  req.logout()
  res.redirect '/users/signin'

module.exports = router
