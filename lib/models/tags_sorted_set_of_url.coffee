"use strict"
redis = require('redis')
redis_db = redis.createClient()

class TagsSortedSetOfUrl
  constructor: (@tag, @url=null) ->
    @key = "TAG:#{@tag}"

  add: (cb)->
    return cb('Url null') unless @url?
    redis_db.zincrby(@key, 1, @url, cb)

  minus: (cb) ->
    return cb('Url null') unless @url?
    redis_db.zincrby(@key, -1, @url, cb)

  remove_key: (cb) ->
    redis_db.del(@key, cb)

  remove_tag: (cb)->
    return cb('Url null') unless @url?
    redis_db.zrem(@key, @url, cb)

  get_score: (cb)->
    ### Return: promise ###
    redis_db.zscore(@key, @url, cb)

  get_top: (amount, cb)->
    ### Return: promise ###
    redis_db.zrevrange(@key, 0, amount-1, cb)

module.exports = TagsSortedSetOfUrl
