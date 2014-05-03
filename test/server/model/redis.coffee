'use strict'
should = require('should')
app = require('../../../server')
request = require('supertest')

redis = require("redis")
redis_db = redis.createClient()

describe 'test redis', ()->
  it 'redis should work', (done)->
    test1_string = 'test1'
    redis_db.set('test', test1_string)
    redis_db.get('test', (err, reply)->
      reply.should.equal(test1_string)
    )
    redis_db.del('test', (err, reply)->
      reply.should.be.ok
    )
    done()
