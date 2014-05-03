"use strict"
class CleanUrl
  constructor: (@url) ->

  clean: ->
    @shorten_url()
    @clean_it() unless @is_web_app()
    #@encode_url()
    return @url

  shorten_url: ->
    @url = @url.substr 0, 2000

  is_web_app: ->
    /^(http[^#]+)\/#\/[^#]+$/.test @url

  clean_it: ->
    @url = @url.match(/^([^#]+)/)[0]

  encode_url: ->
    @url = encodeURIComponent @url


module.exports = CleanUrl
