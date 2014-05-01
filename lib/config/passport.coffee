"use strict"
passport = require("passport")
LocalStrategy = require("passport-local").Strategy
User = require '../models/user'


passport.serializeUser (user, done) ->
  done(null, user.user_id)

passport.deserializeUser (id, done) ->
  done(null, new User(id))

### Passport configuration ###
passport.use new LocalStrategy (username, password, done) ->
  user = new User(username)

  login_callback = (is_success)->
    throw 'login failed' unless is_success
    done(null, user)

  user.login(password, 'local', login_callback)

module.exports = passport
