"use strict"
module.exports =
  env: "production"
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or "0.0.0.0"
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080
