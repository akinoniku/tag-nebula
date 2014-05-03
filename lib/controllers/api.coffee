"use strict"
async = require('async')

TagSetOfUserUrl = require('../models/tag_set_of_user_url')
TagsSortedSetOfUrl = require('../models/tags_sorted_set_of_url')
UrlSortedSetOfTags = require('../models/url_sorted_set_of_tags')
UrlSetOfUserTag = require('../models/url_set_of_user_tag')

CleanTags = require('../helper/clean_tags')
CleanUrl = require('../helper/clean_url')

_ = require('underscore')

### Get awesome things ###
exports.awesomeThings = (req, res) ->
  res.json [
    {
      name: "HTML5 Boilerplate"
      info: "HTML5 Boilerplate is a professional front-end template for building fast, robust, and adaptable web apps or sites."
      awesomeness: 10
    }
    {
      name: "AngularJS"
      info: "AngularJS is a toolset for building the framework most suited to your application development."
      awesomeness: 10
    }
    {
      name: "Karma"
      info: "Spectacular Test Runner for JavaScript."
      awesomeness: 10
    }
    {
      name: "Express"
      info: "Flexible and minimalist web application framework for node.js."
      awesomeness: 10
    }
  ]

exports.get_tags_of_url = (req, res) ->
  url = req.param.url
  (new UrlSortedSetOfTags(url)).get_top 5, (err, result)-> res.json 200, result

exports.add_tags_of_url = (req, res) ->
  return res.json 401, {} unless req.user?

  user_id = req.user.user_id
  url = req.param('url')
  tags = req.param('tags')
  return res.json 400, {} if !url or !tags

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
      (cb)-> (new TagsSortedSetOfUrl(tag, cleaned_url)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(cleaned_url, tag)).add(cb)
    ], callback

  async.parallel(
    tags_array.map (tag)-> (cb)-> add_tag(cb, tag)
  ,
  (err, result)->
    console.log 'parallel:err', err
    console.log 'parallel:result', result
    return res.json(200, result)
  )
