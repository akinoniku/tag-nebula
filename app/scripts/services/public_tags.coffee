'use strict'

angular.module('tagNebulaApp')
.factory 'PublicTags', ($rootScope, $http) ->
  new class PublicTags
    get_top_tags_by_url: (url, cb)->
      cb = cb or angular.noop
      $http.get("/api/tags_of_url/#{url}")
      .success((tags)->
        cb(null, tags)
      ).error cb

    get_top_urls_of_tag: (tag, cb)->
      cb = cb or angular.noop
      $http.get("/api/urls_of_tag/#{tag}")
      .success((urls)->
        cb(null, urls)
      ).error cb

    get_titles_of_urls: (urls, cb)->
      cb = cb or angular.noop
      $http.post("/api/titles_of_urls", {urls: urls})
      .success((titles)->
        url_title_obj = {}
        _.each(urls, (url, key) ->
          url_title_obj[url] = titles[key]
        )
        cb(null, url_title_obj)
      ).error cb


