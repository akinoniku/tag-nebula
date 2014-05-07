'use strict'

angular.module('tagNebulaApp')
.factory 'user', ($rootScope, $http, $cookieStore) ->
  new class user
    # Get currentUser from cookie
    $rootScope.currentUser = $cookieStore.get('user') or null
    $cookieStore.remove 'user'

    login: (user_id, password, cb) ->
      cb = cb or angular.noop
      $http.post('/login',
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
      $http.get('logout')
      .success(
        (data)->
          $rootScope.currentUser = null
          $rootScope.$broadcast 'user.logout'
          cb null, data
      ).error cb

    create_user: (user_id, password, cb)->
      cb = cb or angular.noop
      $http.post('/api/users',
        user_id: user_id
        password: password
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

    current_user: (cb)->
      cb = cb or angular.noop
      $http.get('/api/me')
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
