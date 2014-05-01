"use strict"

User = require '../../lib/models/user'

passport = require("passport")

### Create user ###
exports.create = (req, res, next) ->
  newUser = new User(req.body.user_id, "local")
  create_user_callback = (is_success) ->
    return res.json(400, 'User exists') if !is_success
    req.logIn newUser, (err) ->
      return next(err) if err
      res.json req.user.user_id
  newUser.create(req.body.password, 'local', create_user_callback)

### Get current user ###
exports.me = (req, res) ->
  res.json req.user or null