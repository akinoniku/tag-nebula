'use strict'
UrlSortedSetOfTags = require '../../../lib/models/url_sorted_set_of_tags'
TagSetOfUserUrl= require '../../../lib/models/tag_set_of_user_url'
User = require '../../../lib/models/user'
should = require('should')
async = require('async')
_ = require('underscore')

user_id = 1
url = 'http://xingqiniang.com/'
tag = '星祈娘'
url_tag = undefined
tag_set = undefined
describe 'UrlSortedSetOfTags', ()->
  before (done) ->
    url_tag = new UrlSortedSetOfTags(url, tag)
    done()

  afterEach (done) ->
    url_tag.remove_key(done)

  it 'add test', (done)->
    url_tag.add(done)

  it 'add once', (done)->
    async.series [
      (cb) -> url_tag.add(cb)
      (cb) -> url_tag.get_score(cb)
    ], (err, result)->
      result[1].should.eql '1'
      done(err, result)

  it 'add twice', (done)->
    async.series [
      (cb) -> url_tag.add(cb)
      (cb) -> url_tag.add(cb)
      (cb) -> url_tag.get_score(cb)
    ], (err, result)->
      result[2].should.eql '2'
      done(err, result)

  it 'getScore', (done) ->
    async.series [
      (cb) -> url_tag.add(cb)
      (cb) -> url_tag.add(cb)
      (cb) -> url_tag.minus(cb)
      (cb) -> url_tag.get_score(cb)
    ], (err, result)->
      result[3].should.eql '1'
      done(err, result)

  it '10 tags', (done)->
    async.series [
      (cb)-> (new UrlSortedSetOfTags(url, 1)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 2)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 3)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 4)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 5)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 5)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 5)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 6)).add(cb)
      (cb)-> (new UrlSortedSetOfTags(url, 6)).get_top(5, cb)
    ], (err, result) ->
      _.last(result).length.should.eql(5)
      done(err, result)

describe 'TagSetOfUserUrl', ()->
  before (done) ->
    tag_set = new TagSetOfUserUrl(user_id, url, tag)
    done()

  afterEach (done) ->
    tag_set.remove_key()
    done()

  it 'add twice', (done)->
    async.series [
      (cb) -> tag_set.add(cb)
      (cb) -> tag_set.add(cb)
    ], (err, result)->
      (!!err).should.be.ok
      (!!result).should.be.ok
      done()

  it 'add 5 tags', (done)->
    # each could only add 5 tags on one url
    async.series [
      (cb)->(new TagSetOfUserUrl(user_id, url, 1)).add cb
      (cb)->(new TagSetOfUserUrl(user_id, url, 2)).add cb
      (cb)->(new TagSetOfUserUrl(user_id, url, 3)).add cb
      (cb)->(new TagSetOfUserUrl(user_id, url, 4)).add cb
      (cb)->(new TagSetOfUserUrl(user_id, url, 5)).add cb
      (cb)->(new TagSetOfUserUrl(user_id, url)).get_amount cb
    ], (err, result) ->
      _.last(result).should.eql 5
      done()

user = null
describe 'User Tests', ()->
  before (done) ->
    user = new User('aki')
    done()

  afterEach (done) ->
    user.remove(done)

  it 'create user', (done)->
    async.series [
      (cb)->user.remove(cb)
      (cb)->user.create('123', 'local', cb)
      (cb)->user.create('123', 'local', cb)
    ], (err, result) ->
      (!!err).should.be.ok
      (!!result[1]).should.be.ok
      (!!result[2]).should.not.be.ok
      done()

  it 'login user', (done) ->
    async.series [
      (cb)-> user.create('123', 'local', cb)
      (cb)-> user.login('123', 'local', cb)
    ], (err, result)->
      (!!err).should.not.be.ok
      (!!result[0]).should.be.ok
      (!!result[1]).should.be.ok
      done()
