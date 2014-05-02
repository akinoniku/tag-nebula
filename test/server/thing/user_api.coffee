"use strict"
should = require("should")
app = require("../../../server")
request = require("supertest")
User = require '../../../lib/models/user'

describe "GET /api/awesomeThings", ->
  it "should respond with JSON array", (done) ->
    request(app).get("/api/awesomeThings").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof(Array);
      done()

user_aki = null
user_aki_remove_promise = null
cookie = null
describe "POST /api/users", ->
  beforeEach (done) ->
    user_aki = new User('aki')
    user_aki_remove_promise = user_aki.remove()
    done()

  afterEach (done) ->
    user_aki.remove()
    cookie = null
    done()

  it "create new user", (done) ->
    user_aki_remove_promise.then ->
      request(app).post("/api/users").send({user_id: 'aki', password: '123'})
      .expect(200)
      .expect("Content-Type", /json/)
      .end (err, res) ->
        return done(err) if err
        res.body.should.eql 'aki'
        done()

  it "create new dup user", (done) ->
    user_aki_remove_promise.then ->
      user_aki.create().then ->
        # an other new user
        request(app).post("/api/users").send({user_id: 'aki', password: '123'})
        .expect(400)
        .expect("Content-Type", /json/)
        .end (err, res) ->
          res.body.should.eql 'User exists'
          done()

  it 'get user status with out login', (done)->
    user_aki_remove_promise.then ->
      user_aki.create().then ->
        request(app)
        .get('/api/me')
        .set('cookie', cookie)
        .expect(400)
        .expect("Content-Type", /json/)
        .end (err, res)->
          res.status.should.eql(400)
          done()

  it "login user", (done) ->
    user_aki_remove_promise.then ->
      user_aki.create().then ->
        request(app).post("/login").send({user_id: 'aki', password: '123'})
        .expect(200)
        .expect("Content-Type", /json/)
        .end((err, res) ->
          res.body.should.eql {}
          cookie = res.headers['set-cookie'];

          request(app).get('/api/me')
          .set('cookie', cookie)
          .expect(200)
          .expect("Content-Type", /json/)
          .end (err, res)->
            res.status.should.eql 200
            done()
        )

  it "login failed", (done) ->
    user_aki_remove_promise.then ->
      user_aki.create().then ->
        request(app).post("/login").send({user_id: 'aki', password: 'wrong'})
        .expect(404)
        .end (err, res) ->
          res.status.should.eql 404
          done()

  it "logout user", (done) ->
    user_aki_remove_promise.then ->
      user_aki.create().then ->
        request(app).get("/logout")
        .expect(200)
        .expect("Content-Type", /json/)
        .end (err, res) ->
          done()
