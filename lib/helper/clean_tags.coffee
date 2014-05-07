"use strict"
class CleanTags
  constructor: (@tags) ->
  clean: ->
    @split_tags()
  split_tags: ->
    "#{@tags}".split(/[,， ]+/)[0..4]

module.exports = CleanTags