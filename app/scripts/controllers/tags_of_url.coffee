'use strict'

angular.module('tagNebulaApp')
.controller 'TagsOfUrlCtrl', ($scope, $http, user, PublicTags, UserTags) ->
  $scope.user = user
  $scope.public_tags = PublicTags
  $scope.user_tags = UserTags
