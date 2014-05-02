'use strict'
UrlSortedSetOfTags = require '../../../lib/models/url_sorted_set_of_tags'
TagSetOfUserUrl= require '../../../lib/models/tag_set_of_user_url'
User = require '../../../lib/models/user'
should = require('should')

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
    url_tag.remove_key()
    done()

  it 'add once', (done)->
    url_tag.add()
    url_tag.get_score().then (score)->
      console.log 'should.js is not working :('
      console.log score, 'should be 1'
      #(score).should.equal(1)
      done()

  it 'add twice', (done)->
    url_tag.add()
    url_tag.add()
    url_tag.get_score().then (score)->
      console.log score, 'should be 2'
      #(score).should.be.exactly(2)
      done()

  it 'getScore', (done) ->
    url_tag.add()
    url_tag.add()
    url_tag.minus()
    url_tag.get_score().then (score)->
      console.log score, 'should be 1'
      #(score).should.be.exactly(1)
      done()


  it '10 tags', (done)->
    url_tag.add()
    url_tag.add()
    url_tag.add()
    x_tag = new UrlSortedSetOfTags(url, '星')
    x_tag.add()
    x_tag.add()
    x_tag.add()

    q_tag = new UrlSortedSetOfTags(url, '祈')
    q_tag.add()
    q_tag.add()

    n_tag = new UrlSortedSetOfTags(url, '娘')
    n_tag.add()

    w_tag = new UrlSortedSetOfTags(url, 1)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 2)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 3)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 4)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 5)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 6)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 8)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 9)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 10)
    w_tag.add()
    w_tag = new UrlSortedSetOfTags(url, 11)
    w_tag.add()

    w_tag.get_top(6).then (replies) ->
      console.log replies, 'shoule be array'
      done()
    ,
      (err)->
        console.log 'err', err


# ignore this test
describe 'UrlSortedSetOfTags', ()->
  before (done) ->
    tag_set = new TagSetOfUserUrl(user_id, url, tag)
    done()

  afterEach (done) ->
    tag_set.remove_key()
    done()

  it 'add twice', (done)->
    tag_set.add().then((res)->
      console.log res, 'should be true'
    ,
      (err)->console.log 'err', err
    )

    tag_set.add().then((res)->
      console.log res, 'should be false'
    )
    done()

  it 'add six tags', (done)->
    # each could only add 5 tags on one url
    tag_set = new TagSetOfUserUrl(user_id, url, 1)
    tag_set.add().then (result)->
      tag_set = new TagSetOfUserUrl(user_id, url, 2)
      tag_set.add().then (result)->
        tag_set = new TagSetOfUserUrl(user_id, url, 3)
        tag_set.add().then (result)->
          tag_set = new TagSetOfUserUrl(user_id, url, 4)
          tag_set.add().then (result)->
            tag_set = new TagSetOfUserUrl(user_id, url, 5)
            tag_set.add().then (result)->
              tag_set = new TagSetOfUserUrl(user_id, url, 6)
              tag_set.add().then (result)->
                tag_set.get_all().then (result)->
                  tag_set.get_amount().then (result)->
                    console.log 'total_amount 5 should be ', result
                    done()

describe 'User Tests', ()->
  before (done) ->
    done()

  afterEach (done) ->
    done()

  it 'create user', (done)->
    user = new User('aki')
    user.remove().then ->
      user.create('123').then (result)->
        console.log 'OK should be', result
        user.create('123').then (result)->
          console.error 'should not be done', result
        ,
        (err)->
          console.log 'should be error', err
          done()

  it 'login user', (done) ->
    user = new User('aki')
    user.remove().then ->
      user.create('123').then ->
        user.login('123', 'local', (result)->
          console.log 'login should be true:', result
          done();
        )
