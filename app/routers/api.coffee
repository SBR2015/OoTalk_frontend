express = require 'express'
router = express.Router()

# Routers
# GET: /api/v1/users
router.get '/users', (req, res, next) ->
  console.log req.user
  if req.isAuthenticated()
    res.json req.user
  else
    res.json {}

module.exports = router
