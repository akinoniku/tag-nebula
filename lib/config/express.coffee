"use strict"
express = require("express")
favicon = require("static-favicon")
morgan = require("morgan")
compression = require("compression")
bodyParser = require("body-parser")
methodOverride = require("method-override")
cookieParser = require("cookie-parser")
raw_redis = require("redis")
redis = require('redis');
redis_db = redis.createClient()
session = require('express-session')
RedisStore = require('connect-redis')(session)
errorHandler = require("errorhandler")
path = require("path")
passport = require("passport")
config = require("./config")

### Express configuration ###
module.exports = (app) ->
  env = app.get("env")
  secret = app.get('secret')
  if "development" is env
    app.use require("connect-livereload")()
    
    # Disable caching of scripts for easier testing
    app.use noCache = (req, res, next) ->
      if req.url.indexOf("/scripts/") is 0
        res.header "Cache-Control", "no-cache, no-store, must-revalidate"
        res.header "Pragma", "no-cache"
        res.header "Expires", 0
      next()

    app.use express.static(path.join(config.root, ".tmp"))
    app.use express.static(path.join(config.root, "app"))
    app.set "views", config.root + "/app/views"

  if "production" is env
    app.use compression()
    app.use favicon(path.join(config.root, "public", "favicon.ico"))
    app.use express.static(path.join(config.root, "public"))
    app.set "views", config.root + "/views"

  app.set "view engine", "jade"
  app.use morgan("dev")
  app.use bodyParser()
  app.use methodOverride()
  app.use cookieParser()
  app.use session({secret: secret , cookie: { maxAge: 60000000 }})
  #app.use session({store: new RedisStore({client: redis_db}), secret: 'keyboard cat', cookie: { maxAge: 60000 }})

  # Use passport session
  app.use passport.initialize()
  app.use passport.session()

  # Error handler - has to be last
  app.use errorHandler()  if "development" is app.get("env")
