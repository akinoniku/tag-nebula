'use strict'

angular.module('tagNebulaApp')
.factory 'PublicTags', ($rootScope, $http) ->
  new class PublicTags
    get_top_tags_by_url: (url, cb)->
      cb = cb or angular.noop
      $http.get('/api/tags_of_url')
      .success((tags)->
        cb(null, tags)
      ).error cb

    get_top_urls_of_tag: (tag, cb)->
      cb = cb or angular.noop
      $http.get('/api/urls_of_tag')
      .success((urls)->
        cb(null, urls)
      ).error cb
