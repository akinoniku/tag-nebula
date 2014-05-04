'use strict'

angular.module('tagNebulaApp')
  .controller 'NavbarCtrl', ($scope, $location, user) ->
    user.current_user(-> $scope.is_logined = user.is_logged_in() )

    $scope.login_or_username = ->
      if $scope.is_logined then $scope.currentUser else 'Login / Reg'

    $scope.login_form =
      is_shown: false
      login_or_reg: 'login'
      show_form: -> @is_shown = !$scope.is_logined
      hide_form: -> @is_shown = false
      toggle_form: -> @is_shown = if $scope.is_logined then false else!@is_shown
      switch_login_and_reg: -> @login_or_reg = if @login_or_reg is 'login' then 'reg' else 'login'
      get_is_shown: -> @is_shown
      get_is_login: -> @login_or_reg is 'login'

    $scope.err = []

    $scope.login = (user_id, password)->
      $scope.err = []
      user.login user_id, password, (err, result) ->
        $scope.is_logined = user.is_logged_in()
        if err
          console.log err
          $scope.err.push err
        else
          $scope.login_form.hide_form()

    $scope.logout = ->
      user.logout ->
        $scope.is_logined = user.is_logged_in()

    $scope.create_user = (user_id, password)->
      $scope.err = []
      user.create_user user_id, password, (err, result)->
        $scope.is_logined = user.is_logged_in()
        if err
          $scope.err.push err
        else
          $scope.login_form.hide_form()

    $scope.menu = [
      title: 'Home'
      link: '/'
    ]
    
    $scope.isActive = (route) ->
      route is $location.path()