"use strict"
redis = require('redis');
redis_db = redis.createClient()
async = require 'async'

class UrlSetOfUser
  constructor: (@user_id, @tag, @url, @title) ->
    @url_key = "USER:#{@user_id}:URL"
    @tag_key = "USER:#{@user_id}:TAG"

  add: (cb)->
    return cb('Tag or url null') unless (@url? or @tag?)
    async.parallel [
      (cb)=>redis_db.zincrby(@url_key, 1, @tag, cb)
      (cb)=>redis_db.zincrby(@tag_key, 1, @url, cb)
    ], cb

  remove: (cb)->
    return cb('Tag or url null') unless (@url? or @tag?)
    async.parallel [
      (cb)=>redis_db.zincrby(@url_key, 1, @tag, cb)
      (cb)=>redis_db.zincrby(@tag_key, 1, @url, cb)
    ], cb

  get_top_url: (amount=50, cb)->
    return cb('Url null') unless @url?
    redis_db.zrevrange(@url_key, 0, amount-1, 'withscores', (err, result)->
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

  get_top_tag: (amount=50, cb)->
    return cb('Tag null') unless @tag?
    redis_db.zrevrange(@tag_key, 0, amount-1, 'withscores', (err, result)->
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

module.exports = UrlSetOfUser
