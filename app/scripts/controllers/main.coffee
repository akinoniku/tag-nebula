'use strict'

angular.module('tagNebulaApp')
  .controller 'MainCtrl', ($scope, $rootScope, user, PublicTags, UserTags) ->
    $scope.current =
      new_tag: '1231'
      url: '123'
      title: 'te_title'
      public_tags: []
      user_tags: []

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
