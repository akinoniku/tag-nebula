"use strict"

redis = require('redis');
redis_db = redis.createClient()

class UrlSortedSetOfTags
    constructor: (@url, @tag=null) ->
      @key = "URL:#{@url}"

    add: (cb)->
      return cb('Tag null') unless @tag?
      redis_db.zincrby(@key, 1, @tag, cb)

    minus: (cb)->
      return cb('Tag null') unless @tag?
      redis_db.zincrby(@key, -1, @tag, cb)

    remove_key: (cb)->
      redis_db.del(@key, cb)

    remove_tag: (cb)->
      return cb('Tag null') unless @tag?
      redis_db.zrem(@key, @tag, cb)

    get_score: (cb)->
      redis_db.zscore(@key, @tag, cb)

    get_top: (amount=5, cb)->
      redis_db.zrevrange(@key, 0, amount-1, cb)

module.exports = UrlSortedSetOfTags