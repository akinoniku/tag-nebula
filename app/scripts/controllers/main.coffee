'use strict'

angular.module('tagNebulaApp')
  .controller 'MainCtrl', ($scope, $rootScope, user, PublicTags, UserTags, apiRoot) ->

    if chrome.tabs?
      chrome.tabs.query({'active': true, 'windowId': chrome.windows.WINDOW_ID_CURRENT},
        (tabs)->
          $scope.current =
            new_tag: ''
            url: _.first(tabs).url
            title: _.first(tabs).title
            public_tags: []
            user_tags: []
      )
    else
      $scope.current =
        new_tag: ''
        url: 'http://xingqiniang.comxingqiniang.comxingqiniang.comxingqiniang.comxingqiniang.comxingqiniang.com'
        title: '星祈娘星祈娘星祈娘星祈娘星祈娘星祈娘星祈娘'
        public_tags: []
        user_tags: []

    $scope.apiRoot = apiRoot
    $scope.templates =
      alert: "#{apiRoot}/partials/alert"
      navbar: "#{apiRoot}/partials/navbar"

    $scope.urls_of_tag_set =
      public: {}
      my: {}

    $scope.titles_of_urls = {}

    # Events
    $scope.$on 'user.login', ->
      $scope.update_tags()

    $scope.$on 'tags.updated', ->
      $scope.update_tags()

    $scope.$on 'currentUser.done', ->
      $scope.update_tags()

    # Public function
    $scope.get_top_tags_by_url = ->
      PublicTags.get_top_tags_by_url $scope.current.url, (err, result)->
        $scope.current.public_tags = result

    $scope.display_top_urls_of_tag = (kind, tag)->
      if $scope.urls_of_tag_set[kind][tag]?
        $scope.urls_of_tag_set =
          public: {}
          my: {}
      else
        PublicTags.get_top_urls_of_tag tag, (err, new_urls)->
          $scope.urls_of_tag_set =
            public: {}
            my: {}
          $scope.urls_of_tag_set[kind][tag] = new_urls
          PublicTags.get_titles_of_urls(_.keys(new_urls), (err, url_title_obj)->
            if !err
              _.each url_title_obj, (title, url) ->
                $scope.titles_of_urls[url] = title
          )

    $scope.update_tags = ->
      if $scope.current.url
        PublicTags.get_top_tags_by_url $scope.current.url, (err, result)->
          $scope.current.public_tags = result

        UserTags.get_user_tags_of_url $scope.current.url, (err, result)->
          $scope.current.user_tags = result

    # Need login
    $scope.remove_tag = (tag)->
      UserTags.remove_tag $scope.current.url, tag, (err, result)->
        $rootScope.$broadcast('tags.updated')

    $scope.add_tag = ->
      UserTags.add_tag $scope.current.url, $scope.current.new_tag, $scope.current.title, (err, result)->
        $rootScope.$broadcast('tags.updated')
