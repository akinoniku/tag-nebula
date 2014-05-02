"use strict"
redis = require('redis');
redis_db = redis.createClient()

class UrlSetOfUserTag
  constructor: (@user_id, @tag, @url=null) ->
    @key = "USER:#{@user_id}:TAG:#{@url}"

  add: (cb)->
    return cb('Url null') unless @url?
    redis_db.sadd(@key, @url, cb)

  remove_key: (cb)->
    redis_db.del(@key, cb)

  remove_tag: (cb)->
    return cb('Url null') unless @url?
    redis_db.srem(@key, @url, cb)

  get_all: (cb)->
    redis_db.smembers(@key, cb)

module.exports = UrlSetOfUserTag
