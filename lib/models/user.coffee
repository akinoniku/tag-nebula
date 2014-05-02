"use strict"
redis = require('redis');
redis_db = redis.createClient()
crypto = require("crypto")
async = require('async')

class User
  constructor: (@user_id, @provider='local') ->
    @key = @make_key(@user_id)
    @salt = null
    @hashed_password = null
    @logined = false
    @callback = null

  create: (raw_password, provider='local', callback=null) ->
    async.waterfall [
      (cb)=>@is_exists(cb)
      (is_exists ,cb)=>
        return cb('User exists') if !!is_exists
        @salt = @make_salt()
        @hashed_password = @encrypt_password(raw_password)
        redis_db.hmset(@key, 'salt', @salt, 'hashed_password', @hashed_password, 'provider', provider, cb)
    ], callback

  login: (raw_password, provider='local', callback) ->
    async.series [
      (cb) => redis_db.hgetall(@key, cb)
    ], (err, user_results)=>
      @hashed_password = user_results[0]['hashed_password']
      @salt = user_results[0]['salt']
      @logined = @authenticate(raw_password)
      err = if @logined then null else 'failed'
      callback(err, @logined)

  is_logined: ->
    @logined

  remove: (cb)->
    redis_db.del(@key, cb)

  is_exists: (cb)->
    ### @return: promise ###
    redis_db.exists(@key, cb)

  make_key: (user_id=null) ->
    user_id ?= @user_id
    "USER:#{user_id}"

  authenticate: (raw_password) ->
    return false unless !!@hashed_password
    @encrypt_password(raw_password) is @hashed_password

  make_salt: ->
    crypto.randomBytes(16).toString "base64"

  encrypt_password: (password) ->
    return ""  if not password or not @salt
    salt = new Buffer(@salt, "base64")
    crypto.pbkdf2Sync(password, salt, 10000, 64).toString "base64"

module.exports = User
