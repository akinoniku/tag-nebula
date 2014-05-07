"use strict"
path = require("path")
rootPath = path.normalize(__dirname + "/../../..")
module.exports =
  root: rootPath
  port: process.env.PORT or 9000
  secret: process.env.TAG_SECRET_KEY or 'random^?key?=cat/a'