"use strict"
async = require('async')

TagSetOfUserUrl = require('../models/tag_set_of_user_url')
TagsSortedSetOfUrl = require('../models/tags_sorted_set_of_url')
UrlSortedSetOfTags = require('../models/url_sorted_set_of_tags')
UrlSetOfUserTag = require('../models/url_set_of_user_tag')

CleanTags = require('../helper/clean_tags')
CleanUrl = require('../helper/clean_url')

_ = require('underscore')

exports.get_top_tags_of_url = (req, res) ->
  url = req.params[0]
  cleaned_url = (new CleanUrl(url)).clean()
  (new UrlSortedSetOfTags(cleaned_url)).get_top 5, (err, result)->
    return res.json 500, err if err
    res.json 200, result

exports.get_top_url_of_tags = (req, res) ->
  tags = req.params[0]
  (new TagsSortedSetOfUrl(tags)).get_top 5, (err, result)->
    return res.json 500, err if err
    res.json 200, result

exports.get_user_tags_of_url = (req, res)->
  return res.json 401, {} unless req.user?
  user_id = req.user.user_id

  url = req.params[0]
  cleaned_url = (new CleanUrl(url)).clean()
  (new TagSetOfUserUrl(user_id, cleaned_url)).get_all (err, result)->
    return res.json 500, err if err
    res.json 200, result


exports.get_user_urls_of_tag = (req, res)->
  return res.json 401, {} unless req.user?
  user_id = req.user.user_id

  tag = req.params[0]
  (new UrlSetOfUserTag(user_id, tag)).get_all (err, result)->
    return res.json 500, err if err
    res.json 200, result

exports.add_tags_of_url = (req, res) ->
  return res.json 401, {} unless req.user?
  user_id = req.user.user_id

  tags = req.param('tags')
  url = req.params[0]
  return res.json 400, 'Empty tags or url' if !url or !tags

  tags_array = (new CleanTags(tags)).clean()
  cleaned_url = (new CleanUrl(url)).clean()

  add_tag = (callback, tag)->
    async.waterfall [
      (cb)->(new TagSetOfUserUrl(user_id, cleaned_url, tag)).add(cb)
      (is_success, cb)->
        if is_success
          (new UrlSetOfUserTag(user_id, tag, cleaned_url)).add(cb)
        else
          cb('Tag Exists')
      (n, cb)-> (new TagsSortedSetOfUrl(tag, cleaned_url)).add(cb)
      (n, cb)-> (new UrlSortedSetOfTags(cleaned_url, tag)).add(cb)
    ], (err, result) ->
      callback(null, if result then success: tag else failed: tag)

  async.parallel(
    tags_array.map (tag)-> (cb)-> add_tag(cb, tag)
  ,
    (err, result)->
      return res.json(200, result)
  )

exports.remove_tags_of_url = (req, res) ->
  return res.json 401, {} unless req.user?

  user_id = req.user.user_id
  tags = req.param('tags')
  url = req.params[0]
  return res.json 400, 'Empty tags or url' if !url or !tags

  tags_array = (new CleanTags(tags)).clean()
  cleaned_url = (new CleanUrl(url)).clean()

  remove_tag = (callback, tag)->
    async.waterfall [
      (cb)->(new TagSetOfUserUrl(user_id, cleaned_url, tag)).remove_tag(cb)
      (is_success, cb)->
        if is_success
          (new UrlSetOfUserTag(user_id, tag, cleaned_url)).remove_tag(cb)
        else
          cb('Tag Not Exists')
      (n, cb)-> (new TagsSortedSetOfUrl(tag, cleaned_url)).minus(cb)
      (n, cb)-> (new UrlSortedSetOfTags(cleaned_url, tag)).minus(cb)
    ], (err, result) ->
      callback(null, if result then success: tag else failed: tag)

  async.parallel(
    tags_array.map (tag)-> (cb)-> remove_tag(cb, tag)
  ,
  (err, result)->
    return res.json(200, result)
  )
