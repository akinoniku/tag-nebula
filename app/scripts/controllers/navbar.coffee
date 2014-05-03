'use strict'

angular.module('tagNebulaApp')
  .controller 'NavbarCtrl', ($scope, $location, user) ->
    console.log user
    user.current_user(-> $scope.isLogin = user.is_logged_in() )

    $scope.hide_or_display =
      show_login: false
      show_reg: false
      switch_login: -> @show_login = !@show_login
      switch_reg: -> @show_reg = !@show_reg

    $scope.err = []

    $scope.login = (user_id, password)->
      $scope.err = []
      console.log user_id, password
      user.login user_id, password, (err, result) ->
        $scope.err.push err if err
        $scope.hide_or_display.show_login = false
        $scope.isLogin = user.is_logged_in()

    $scope.logout = ->
      user.logout ->
        $scope.isLogin = user.is_logged_in()

    $scope.create_user = (user_id, password)->
      $scope.err = []
      user.create_user user_id, password, (err, result)->
        $scope.err.push err if err
        $scope.hide_or_display.show_reg = false
        $scope.isLogin = user.is_logged_in()

    $scope.menu = [
      title: 'Home'
      link: '/'
    ]
    
    $scope.isActive = (route) ->
      route is $location.path()