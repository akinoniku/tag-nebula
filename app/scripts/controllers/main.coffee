'use strict'

angular.module('tagNebulaApp')
  .controller 'MainCtrl', ($scope, user, PublicTags, UserTags) ->
    $scope.current =
      new_tag: '1231'
      url: '123'
      tags: []

    $scope.get_top_tags_by_url = ->
      PublicTags.get_top_tags_by_url($scope.current.url, (err, result)->
        $scope.current.tags = result
      )

    $scope.add_tag = ->
      UserTags.add_tag($scope.current.url, $scope.current.new_tag, (err, result)->
        PublicTags.get_top_tags_by_url($scope.current.url, (err, result)->
          $scope.current.tags = result
        )
      )
    $scope.get_top_tags_by_url() if $scope.current.url
