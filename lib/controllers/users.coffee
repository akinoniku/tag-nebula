"use strict"

User = require '../../lib/models/user'

passport = require("passport")
captchagen = require('captchagen')
async = require('async')

redis = require('redis');
redis_db = redis.createClient()

### Create user ###
exports.create = (req, res, next) ->
  captcha_key = req.body.captcha_key
  captcha_answer = req.body.captcha_answer
  redis_db.get("captcha:#{captcha_key}", (err, result)->
    if result
      if captcha_answer is result
        newUser = new User(req.body.user_id, "local")
        create_user_callback = (err, is_success) ->
          return res.json(400, 'User exists') if !is_success
          req.logIn newUser, (err) ->
            return next(err) if err
            res.json 200, req.user.user_id
        newUser.create(req.body.password, 'local', create_user_callback)
      else
        return res.json(400, 'captcha answer wrong')
    else
      res.json(400, 'captcha expired')
  )

### Get current user ###
exports.me = (req, res) ->
  if req.user? then res.json 200, req.user else res.json 400, null

exports.captcha_image = (req, res) ->
  uniqueId = (length=8) ->
    id = ""
    id += Math.random().toString(36).substr(2) while id.length < length
    id.substr 0, length

  uniqueInt = (length=8) ->
    id = ""
    id += Math.random().toString().substr(4) while id.length < length
    id.substr 0, length

  captcha = captchagen.create({height: 60, width: 150, text: uniqueInt(6)})
  captcha.generate()
  captcha_key = uniqueId()
  captcha_text = captcha.text()

  async.series([
    (cb)-> redis_db.set("captcha:#{captcha_key}", captcha_text, cb)
    (cb)-> redis_db.expire("captcha:#{captcha_key}", 60 * 3, cb)
    (cb)-> captcha.uri(cb)
  ], (err, result)->
    if !err
      res.json(200, {key: captcha_key, image: result[2]})
    else
      res.json(500, err)
  )
