"use strict"
should = require("should")
app = require("../../../server")
request = require("supertest")
User = require '../../../lib/models/user'
UrlSortedSetOfTags = require '../../../lib/models/url_sorted_set_of_tags'

cookie = null
user_aki = null
describe "public api", ->
  beforeEach (done) ->
    user_aki = new User('aki')
    user_aki.remove().then ->
      user_aki.create().then ->
        request(app).post("/login").send({user_id: 'aki', password: '123'})
        .expect(200)
        .end (err, res) ->
          #return done(err) if err
          res.body.should.eql {}
          cookie = res.headers['set-cookie']
          done()

  afterEach (done) ->
    user_aki.remove()
    cookie = null
    done()

  it "GET /api/tags_of_url/:url", (done) ->
    request(app).get("/api/tags_of_url/q111")
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      console.log 'array', res.body.length
      done()

  it "POST /api/tags_of_url/:url", (done) ->
    request(app).post("/api/tags_of_url/q111111")
    .send(tags: 'wifjwijf, iaf, 12312')
    .set('cookie', cookie)
    .expect(201)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      done()

  it "no cookie, POST /api/tags_of_url/:url", (done) ->
    request(app).post("/api/tags_of_url/qqqqq")
    .send(tags: '1,2,3')
    .expect(401)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      done()
