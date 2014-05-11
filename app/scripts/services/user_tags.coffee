'use strict'

angular.module('tagNebulaApp')
.factory 'UserTags', ($rootScope, $http, user, apiRoot) ->
  new class UserTags
    get_user_tags_of_url: (url, cb)->
      cb = cb or angular.noop
      return cb('Need login') unless user.is_logged_in()
      $http.get("#{apiRoot}/api/my/tags_of_url/#{url}")
      .success((tags)->
        cb(null, tags)
      ).error cb

    get_user_urls_of_tag: (tag, cb)->
      cb = cb or angular.noop
      return cb('Need login') unless user.is_logged_in()
      $http.get("#{apiRoot}/api/my/urls_of_tag/#{tag}")
      .success((urls)->
        cb(null, urls)
      ).error cb

    add_tag: (url, tags, title, cb)->
      cb = cb or angular.noop
      return cb('Need login') unless user.is_logged_in()
      $http.post("#{apiRoot}/api/tags_of_url/#{url}", {tags: tags, title: title})
      .success((result)->
        cb(null, result)
      ).error cb

    remove_tag: (url, tags, cb)->
      cb = cb or angular.noop
      return cb('Need login') unless user.is_logged_in()
      $http.post("#{apiRoot}/api/tags_of_url/del/#{url}", tags: tags)
      .success((result)->
        cb(null, result)
      ).error cb