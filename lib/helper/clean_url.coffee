"use strict"
class CleanUrl
  constructor: (@url) ->

  clean: ->
    @shorten_url()
    @clean_it() unless @is_web_app()
    return @url

  shorten_url: ->
    @url = @url.substr 0, 2000

  is_web_app: ->
    /^(http[^#]+)\/#\/[^#]+$/.test @url

  clean_it: ->
    @url = @url.match(/^(http[^#]+)/)[0]

module.exports = CleanUrl
