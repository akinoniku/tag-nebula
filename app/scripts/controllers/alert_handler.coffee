'use strict'

angular.module('tagNebulaApp')
.service('AlertService', ($rootScope, $http) ->
  @notifications = []

  @push = (notification_string)->
    @notifications.push notification_string unless notification_string in @notifications

  @pop = ->
    @notifications.pop()

  @
).controller('AlertCtrl', ($scope, AlertService, $timeout ) ->
  $scope.notifications = AlertService.notifications
  $scope.$watchCollection 'notifications', (newValue, oldValue)->
    if newValue.length > oldValue.length
      $timeout(->
        AlertService.pop()
      , 3000
      , false
      )
).filter('AlertFilter', ->
  (input, language='cn') ->
    alerts =
      cn:
        Unauthorized: '邮箱/密码错误吧'
        "\"captcha answer wrong\"": '验证码输错了'
        "\"User exists\"": '这个邮箱已经被注册了'
    if alerts[language]?[input]? then alerts[language]?[input] else input
)
