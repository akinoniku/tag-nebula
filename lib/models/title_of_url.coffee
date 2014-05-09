"use strict"
redis = require('redis');
redis_db = redis.createClient()
async = require 'async'
_ = require 'underscore'

class TitleOfUrl
  constructor: (url_title_arr_or_obj) ->
    @url_title = url_title_arr_or_obj
    ###
    On set:
      @url_title = {
         url1: title1
         url2: title2
         url3: title3
        }
    On get:
      @url_title = [ url1, url2, url3 ]
    ###
    @key = "URL_TITLE:"

  add: (cb) ->
    cb('url title obj is null') unless @url_title?
    cb('No more than 5') if _.size(@url_title) > 5
    redis_db.hmset(@key, @url_title, cb)

  get: (cb) ->
    cb('url title obj is null') unless @url_title?
    cb('No more than 50') if @url_title.length > 50
    redis_db.hmget(@key, @url_title, cb)

module.exports = TitleOfUrl
