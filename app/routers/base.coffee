express = require 'express'
router = express.Router()

# Routers
router.get '/', (req, res, next) ->
  console.log req.user
  res.render 'welcome/index'

router.get '/code', (req, res, next) ->
  res.render 'code/index'

router.get '/codejson', (req, res, next) ->
  res.render 'code_json/index'

router.get '/courses', (req, res, next) ->
  res.render 'course/index'

router.get '/courses/:id/lessons', (req, res, next) ->
  res.render 'lesson/index'

router.get '/courses/:c_id/lessons/:l_id', (req, res, next) ->
  res.render 'lesson/show'

router.get '/locale/:locale', (req, res, next) ->
  res.cookie 'locale', req.params.locale
  req.setLocale req.params.locale
  backURL = req.header('Referer') || '/'
  noParams = backURL.split('?')[0]
  res.redirect(noParams)

module.exports = router
