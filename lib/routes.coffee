"use strict"
api = require("./controllers/api")
index = require("./controllers")
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

users = require("./controllers/users")
#session = require("./controllers/session")
middleware = require("./middleware")

express = require 'express'
router = express.Router()


###
Application routes
###
module.exports = (app) ->
  
  #tags
  app.route(/\/api\/tags_of_url\/([\w\W]+)$/)
  .post(api.add_tags_of_url)
  .get(api.get_tags_of_url)
  .delete(api.remove_tags_of_url)

  app.route(/\/api\/url_of_tags\/([\w\W]+)$/).get(api.get_url_of_tags)

  # user
  app.route("/api/users").post(users.create)

  app.route('/login').post passport.authenticate('local', session: true),
    (req, res)->
      status = if req.user.logined then 200 else 401
      res.json status, {}

  app.route('/logout').get (req, res)->
    req.logout()
    res.send 200

  app.route('/api/users/me').get passport.authenticate('local', { session: true }),
  (req, res)->  res.json user_id: req.user.user_id

  app.route("/api/me").get(users.me)

  # All undefined api routes should return a 404
  app.route("/api/*").get (req, res) ->
    res.send 404

  # All other routes to use Angular routing in app/scripts/app.js
  app.route("/partials/*").get index.partials
  app.route("/*").get index.index
