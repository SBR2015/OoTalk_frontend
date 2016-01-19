express = require 'express'
router = express.Router()

# Routers
router.get '/', (req, res, next) ->
  res.render 'welcome/index'

router.get '/code', (req, res, next) ->
  res.render 'code/index'

router.get '/codejson', (req, res, next) ->
  res.render 'code_json/index'
  
router.get '/course', (req, res, next) ->
  res.render 'course/index'

router.get '/locale/:locale', (req, res, next) ->
  res.cookie 'locale', req.params.locale
  req.setLocale req.params.locale
  backURL = req.header('Referer') || '/'
  noParams = backURL.split('?')[0]
  res.redirect(noParams)
        
module.exports = router
