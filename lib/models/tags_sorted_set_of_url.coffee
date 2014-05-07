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
    redis_db.zscore(@key, @url, cb)

  get_top: (amount=5, cb)->
    redis_db.zrevrange(@key, 0, amount-1, 'withscores', (err, result)->
      top_arr = {}
      last_value = null
      if result?
        for value, key in result
          if key%2
            top_arr[last_value] = value
          else
            last_value = value
      cb(err, top_arr)
    )

module.exports = TagsSortedSetOfUrl
