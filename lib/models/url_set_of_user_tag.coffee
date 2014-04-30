"use strict"
redis = require('then-redis');
redis_db = redis.createClient()

class UrlSetOfUserTag
  constructor: (@user_id, @tag, @url=null) ->
    @key = "USER:#{@user_id}:TAG:#{@url}"

  add: ->
    return false unless @url?
    redis_db.sadd(@key, @url)

  remove_key: ->
    redis_db.del(@key)

  remove_tag: ->
    return false unless @url?
    redis_db.srem(@key, @url)

  get_all: ->
    redis_db.smembers(@key)

module.exports = UrlSetOfUserTag
