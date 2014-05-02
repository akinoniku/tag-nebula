"use strict"
redis = require('then-redis');
redis_db = redis.createClient()

class TagSetOfUserUrl
  constructor: (@user_id, @url, @tag=null) ->
    @key = "USER:#{@user_id}:URL:#{@url}"

  get_amount: ->
    redis_db.scard(@key)

  is_member: ->
    return false unless @tag?
    redis_db.sismember(@key, @tag)

  add: ->
    @is_member().then (is_member)=>
      console.log @key, @tag, 'is_member()', is_member
      return false if is_member
      @get_amount().then (amount)=>
        console.log @key, @tag, 'get_amount()', amount
        if amount < 5 then redis_db.sadd(@key, @tag) else false

  remove_key: ->
    redis_db.del(@key)

  remove_tag: ->
    return false unless @tag?
    redis_db.srem(@key, @tag)

  get_all: ->
    redis_db.smembers(@key)

module.exports = TagSetOfUserUrl
