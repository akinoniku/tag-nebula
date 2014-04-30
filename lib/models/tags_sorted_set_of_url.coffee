"use strict"
redis = require('then-redis')
redis_db = redis.createClient()

class TagsSortedSetOfUrl
  constructor: (@tag, @url=null) ->
    @key = "TAG:#{@tag}"

  add: ->
    return false unless @url?
    redis_db.zincrby(@key, 1, @url)

  minus: ->
    return false unless @url?
    redis_db.zincrby(@key, -1, @url)

  remove_key: ->
    redis_db.del(@key)

  remove_tag: ->
    return false unless @url?
    redis_db.zrem(@key, @url)

  get_score: ->
    ### Return: promise ###
    redis_db.zscore(@key, @url)

  get_top: (amount)->
    ### Return: promise ###
    redis_db.zrevrange(@key, 0, amount-1)

module.exports = TagsSortedSetOfUrl
