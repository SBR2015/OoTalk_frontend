express = require 'express'
i18n = require('i18n')
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
      #req.session.locale = req.params.locale;
      i18n.setLocale req, req.session.locale
      res.redirect('back')
        
module.exports = router
