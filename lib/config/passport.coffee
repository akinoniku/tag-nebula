"use strict"
passport = require("passport")
_ = require("underscore")
LocalStrategy = require("passport-local").Strategy
User = require '../models/user'


passport.serializeUser (user, done) ->
  done(null, user.user_id)

passport.deserializeUser (user_id, done) ->
  user = new User(user_id)
  done null, _.pick(user, 'user_id')

### Passport configuration ###
passport.use(
    new LocalStrategy
      usernameField: 'user_id'
      passwordField: 'password'
    ,
      (username, password, done) ->
        user = new User(username)

        login_callback = (err, is_success)->
          return done(null, false, { message: 'Login failed.' }) unless is_success
          done(null, user)

        user.login(password, 'local', login_callback)
)

module.exports = passport