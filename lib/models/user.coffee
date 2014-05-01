"use strict"
redis = require('then-redis');
redis_db = redis.createClient()
crypto = require("crypto")

class User
  constructor: (@user_id, @provider='local') ->
    @key = @make_key(@user_id)
    @salt = null
    @hashed_password = null
    @logined = false
    @callback = null

  create: (raw_password, provider='local', callback=null) ->
    ### @return: promise or callback ###
    @is_exists().then (is_exists)=>
      return callback(false) if !!is_exists
      @salt = @make_salt()
      @hashed_password = @encrypt_password(raw_password)
      if callback?
        redis_db.hmset(@key, 'salt', @salt, 'hashed_password', @hashed_password, 'provider', provider).then (results)->
          callback(results)
      else
        redis_db.hmset(@key, 'salt', @salt, 'hashed_password', @hashed_password, 'provider', provider)

  login: (raw_password, provider='local', callback) ->
    ### @return: bool ###
    redis_db.hgetall(@key).then (user_results)=>
      @hashed_password = user_results['hashed_password']
      @salt = user_results['salt']
      @logined = @authenticate(raw_password)
      callback(@logined)

  is_logined: ->
    @logined

  remove: ->
    ### @return: promise ###
    redis_db.del(@key)

  is_exists: ->
    ### @return: promise ###
    redis_db.exists(@key)

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
