"use strict"
redis = require('redis');
redis_db = redis.createClient()
async = require('async')

class TagSetOfUserUrl
  constructor: (@user_id, @url, @tag=null) ->
    @key = "USER:#{@user_id}:URL:#{@url}"

  get_amount: (cb) ->
    redis_db.scard(@key, cb)

  is_member: (cb) ->
    cb('Tag null') unless @tag?
    redis_db.sismember(@key, @tag, cb)

  add: (cb) ->
    async.waterfall [
      (cb)=> @is_member(cb)
      (is_member, cb) =>
        return cb('Already Exists') if is_member
        @get_amount(cb)
      (amount, cb)=>
        return cb('Tags full') unless amount < 5
        redis_db.sadd(@key, @tag, cb)
      ] , (err, result) ->
        cb(err, result)

  remove_key: (cb)->
    redis_db.del(@key, cb)

  remove_tag: (cb) ->
    return cb('Tag null') unless @tag?
    redis_db.srem(@key, @tag, cb)

  get_all: (cb) ->
    redis_db.smembers(@key, cb)

module.exports = TagSetOfUserUrl
