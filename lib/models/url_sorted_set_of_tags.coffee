"use strict"

redis = require('then-redis');
redis_db = redis.createClient()

class UrlSortedSetOfTags
    constructor: (@url, @tag=null) ->
      @key = "URL:#{@url}"

    add: ->
      return false unless @tag?
      redis_db.zincrby(@key, 1, @tag)

    minus: ->
      return false unless @tag?
      redis_db.zincrby(@key, -1, @tag)

    remove_key: ->
      redis_db.del(@key)

    remove_tag: ->
      return false unless @tag?
      redis_db.zrem(@key, @tag)

    get_score: ->
      ### Return: promise ###
      redis_db.zscore(@key, @tag)

    get_top: (amount)->
      ### Return: promise ###
      redis_db.zrevrange(@key, 0, amount-1)

module.exports = UrlSortedSetOfTags