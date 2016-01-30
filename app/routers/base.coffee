express = require 'express'
router = express.Router()

# Routers
router.get '/', (req, res, next) ->
  # if req.isAuthenticated()
  #   res.render 'welcome/index', {email: req.user.email, is_sigined: req.isAuthenticated()}
  # else
  res.render 'welcome/index'

router.get '/code', (req, res, next) ->
  res.render 'code/index'

router.get '/codejson', (req, res, next) ->
  res.render 'code_json/index'

router.get '/courses', (req, res, next) ->
  res.render 'course/index'

router.get '/courses/:id/lessons', (req, res, next) ->
  res.render 'lesson/index'

router.get '/locale/:locale', (req, res, next) ->
  res.cookie 'locale', req.params.locale
  req.setLocale req.params.locale
  backURL = req.header('Referer') || '/'
  noParams = backURL.split('?')[0]
  res.redirect(noParams)

module.exports = router
