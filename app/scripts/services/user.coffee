'use strict'

angular.module('tagNebulaApp')
.factory 'user', ($rootScope, $http, $cookieStore, apiRoot) ->
  new class user
    # Get currentUser from cookie
    $rootScope.currentUser = $cookieStore.get('user') or null
    $cookieStore.remove 'user'

    login: (user_id, password, cb) ->
      cb = cb or angular.noop
      $http.post("#{apiRoot}/login",
        user_id: user_id
        password: password
      ).success(
        (user)->
          user = angular.element.parseJSON user
          $rootScope.currentUser = user
          $rootScope.$broadcast 'user.login'
          cb null, user
      ).error(
        (err) ->
          $rootScope.currentUser = null
          cb err
      )

    logout: (cb)->
      cb = cb or angular.noop
      return false unless $rootScope.currentUser?
      $http.get("#{apiRoot}/logout")
      .success(
        (data)->
          $rootScope.currentUser = null
          $rootScope.$broadcast 'user.logout'
          cb null, data
      ).error cb

    create_user: (user_id, password,  captcha_key, captcha_answer, cb)->
      cb = cb or angular.noop
      $http.post("#{apiRoot}/api/users",
        user_id: user_id
        password: password
        captcha_key: captcha_key
        captcha_answer: captcha_answer
      ).success(
        (user)->
          user = angular.element.parseJSON user
          $rootScope.currentUser = user
          $rootScope.$broadcast 'user.login'
          cb null, user
      ).error(
        (err)->
          $rootScope.currentUser = null
          cb err
      )

    get_captcha: (cb)->
      cb = cb or angular.noop
      $http.get("#{apiRoot}/captcha_image")
      .success(cb)
      .error(cb)


    current_user: (cb)->
      cb = cb or angular.noop
      $http.get("#{apiRoot}/api/me")
      .success(
        (user)->
          $rootScope.currentUser = user.user_id
          $rootScope.$broadcast('currentUser.done')
          cb null, user
      ).error(->
        $rootScope.currentUser = null
        $rootScope.$broadcast('currentUser.done')
        cb 'Not logined'
      )

    is_logged_in: ->
      $rootScope.currentUser?
