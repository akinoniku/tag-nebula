'use strict'

angular.module('tagNebulaApp')
  .controller 'MainCtrl', ($scope, $rootScope, user, PublicTags, UserTags) ->
    $scope.current =
      new_tag: '1231'
      url: '123'
      public_tags: []
      user_tags: []

    $scope.urls_of_tag_set = {}

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

    $scope.get_top_urls_of_tag = (tag)->
      PublicTags.get_top_urls_of_tag tag, (err, result)->
       $scope.urls_of_tag_set[tag] = result

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
      UserTags.add_tag $scope.current.url, $scope.current.new_tag, (err, result)->
        $rootScope.$broadcast('tags.updated')
