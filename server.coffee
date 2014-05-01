"use strict"
express = require("express")

###
Main application file
###

# Set default node environment to development
process.env.NODE_ENV = process.env.NODE_ENV or "development"
config = require("./lib/config/config")

# Passport Configuration
passport = require("./lib/config/passport")

# Setup Express
app = express()
require("./lib/config/express") app
require("./lib/routes") app

# Start server
app.listen config.port, config.ip, ->
  console.log "Express server listening on %s:%d, in %s mode", config.ip, config.port, app.get("env")

# Expose app
exports = module.exports = app
