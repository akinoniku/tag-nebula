"use strict"
should = require("should")
app = require("../../../server")
request = require("supertest")
User = require '../../../lib/models/user'
UrlSortedSetOfTags = require '../../../lib/models/url_sorted_set_of_tags'
async = require('async')

cookie = null
user_aki = null
test_url = 'http://xingqiniang.com'
tag1 = 'test_tag'

describe "public api", ->
  beforeEach (done) ->
    user_aki = new User('aki')
    async.series [
        (cb) -> user_aki.create('123', 'local', cb)
        (cb) ->
          request(app)
          .post("/login")
          .send({user_id: 'aki', password: '123'})
          .expect(200)
          .end (err, res) ->
            return done(err) if err
            res.body.should.eql {}
            cookie = res.headers['set-cookie']
            cb(err, res)
    ], done

  afterEach (done) ->
    cookie = null
    user_aki.remove done

  it "POST /api/tags_of_url/:url", (done) ->
    request(app)
    .post("/api/tags_of_url/#{test_url}")
    .send(tags: tag1)
    .set('cookie', cookie)
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [success: tag1]
      done(err, res)

  it "GET /api/tags_of_url/:url", (done) ->
    request(app)
    .get("/api/tags_of_url/#{test_url}")
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [tag1]
      done(err, res)

  it "GET /api/urls_of_tag/:tags", (done) ->
    request(app)
    .get("/api/urls_of_tag/#{tag1}")
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [test_url]
      done(err, res)

  it "GET /api/my/tags_of_url/:url", (done) ->
    request(app)
    .get("/api/my/tags_of_url/#{test_url}")
    .set('cookie', cookie)
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [tag1]
      done(err, res)

  it "GET /api/my/urls_of_tag/:tag", (done) ->
    request(app)
    .get("/api/my/urls_of_tag/#{tag1}")
    .set('cookie', cookie)
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [test_url]
      done(err, res)

  it "DELETE /api/tags_of_url/:url", (done) ->
    request(app)
    .del("/api/tags_of_url/#{test_url}")
    .send(tags: tag1)
    .set('cookie', cookie)
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      res.body.should.eql [success: tag1]
      done(err, res)

  it "No cookie, POST /api/tags_of_url/:url", (done) ->
    request(app).post("/api/tags_of_url/#{test_url}")
    .send(tags: tag1)
    .set('cookie', null)
    .expect(401)
    .end done
