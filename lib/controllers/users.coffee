"use strict"

User = require '../../lib/models/user'

passport = require("passport")
Recaptcha = require('recaptcha').Recaptcha

PUBLIC_KEY  = process.env.RECAPTCHA_PUBLIC_KEY or '6Lfr9PISAAAAANb1r-YMq0qcJod1bAzByrDwBJEN'
PRIVATE_KEY = process.env.RECAPTCHA_PRIVATE_KEY or '6Lfr9PISAAAAAMsJL0dBqgCx4XqW_38425_mhZrA'


### Create user ###
exports.create = (req, res, next) ->
  recaptcha_data =
    remoteip:  req.connection.remoteAddress
    challenge: req.body.recaptcha_challenge
    response:  req.body.recaptcha_response
  recaptcha = new Recaptcha(PUBLIC_KEY, PRIVATE_KEY, recaptcha_data)
  recaptcha.verify (success, error_code)->
    if (success)
      newUser = new User(req.body.user_id, "local")
      create_user_callback = (err, is_success) ->
        return res.json(400, 'User exists') if !is_success
        req.logIn newUser, (err) ->
          return next(err) if err
          res.json 200, req.user.user_id
      newUser.create(req.body.password, 'local', create_user_callback)
    else
      res.json 400, error_code

### Get current user ###
exports.me = (req, res) ->
  if req.user? then res.json 200, req.user else res.json 400, null

exports.recaptcha_form = (req, res) ->
  recaptcha = new Recaptcha(PUBLIC_KEY, PRIVATE_KEY)
  res.json(200, recaptcha_form: recaptcha.toHTML())
