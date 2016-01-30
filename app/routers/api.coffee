express = require 'express'
router = express.Router()

# Routers
# GET: /api/v1/users
router.get '/users', (req, res, next) ->
  if req.isAuthenticated()
    res.json req.user
  else
    res.json {}

module.exports = router
