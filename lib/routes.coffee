"use strict"
api = require("./controllers/api")
index = require("./controllers")
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

users = require("./controllers/users")
#session = require("./controllers/session")
middleware = require("./middleware")


###
Application routes
###
module.exports = (app) ->
  
  # Server API Routes
  app.route("/api/awesomeThings").get api.awesomeThings

  # user
  app.route("/api/users").post(users.create)

  app.post '/login', passport.authenticate('local')
  app.get '/logout', (req, res)->
    req.logout()
    res.send 200

  app.get '/api/users/me',
    passport.authenticate('basic', { session: true }),
    (req, res)->  res.json({ id: req.user.id, username: req.user.username })

  #api.route("/api/user")
  
  # All undefined api routes should return a 404
  app.route("/api/*").get (req, res) ->
    res.send 404

  
  # All other routes to use Angular routing in app/scripts/app.js
  app.route("/partials/*").get index.partials
  app.route("/*").get index.index
