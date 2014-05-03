"use strict"
should = require("should")
app = require("../../../server")
request = require("supertest")
User = require '../../../lib/models/user'

user_aki = null
user_aki_remove_promise = null
cookie = null

async = require 'async'

describe "/api/users", ->

  beforeEach (done) ->
    user_aki = new User('aki')
    request(app)
    .post("/api/users")
    .send({user_id: 'aki', password: '123'})
    .expect(200)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.eql 'aki'
      done()

  afterEach (done) ->
    user_aki.remove()
    cookie = null
    done()

  it "create new dup user", (done) ->
    # an other new user
    request(app)
    .post("/api/users")
    .send({user_id: 'aki', password: '123'})
    .expect(400)
    .expect("Content-Type", /json/)
    .end (err, res) ->
      return done(err) if err
      res.body.should.eql 'User exists'
      done()

  it 'get user status with out login', (done)->
    request(app)
    .get('/api/me')
    .set('cookie', cookie)
    .expect(400)
    .expect("Content-Type", /json/)
    .end (err, res)->
      res.status.should.eql(400)
      done()

  it "login user", (done) ->
    async.series [
      (cb)->
        request(app).post("/login").send({user_id: 'aki', password: '123'})
        .expect(200)
        .expect("Content-Type", /json/)
        .end (err, res) ->
          return done(err) if err
          res.body.should.eql {}
          cookie = res.headers['set-cookie'];
          cb err, res
      (cb) ->
        request(app).get('/api/me')
        .set('cookie', cookie)
        .expect(200)
        .expect("Content-Type", /json/)
        .end cb
    ], done

  it "login failed", (done) ->
    request(app).post("/login").send({user_id: 'aki', password: 'wrong'})
    .expect(401)
    .end (err, res) ->
      return done(err) if err
      done()

  it "logout user", (done) ->
    async.series [
      (cb)->
        request(app).get("/logout")
        .expect(200)
        .end cb
      (cb)->
        request(app).get('/api/me')
        .set('cookie', cookie)
        .expect(400)
        .expect("Content-Type", /json/)
        .end cb
    ], done
