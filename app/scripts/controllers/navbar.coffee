'use strict'

angular.module('tagNebulaApp')
  .controller 'NavbarCtrl', ($scope, $location, $rootScope, user) ->

    user.current_user(-> $scope.is_logined = user.is_logged_in() )

    $scope.err = []

    $scope.recaptcha_challenge = '6Lfr9PISAAAAANb1r-YMq0qcJod1bAzByrDwBJEN'
    $scope.recaptcha_response = null

    $scope.login_form =
      is_shown: false
      login_or_reg: 'login'
      show_form: -> @is_shown = !$scope.is_logined
      hide_form: -> @is_shown = false
      toggle_form: -> @is_shown = if $scope.is_logined then false else!@is_shown
      toggle_login: -> if @login_or_reg isnt 'login' then @login_or_reg = 'login' else @toggle_form()
      toggle_reg: -> if @login_or_reg isnt 'reg' then @login_or_reg = 'reg' else @toggle_form()
      switch_login_and_reg: -> @login_or_reg = if @login_or_reg is 'login' then 'reg' else 'login'
      get_is_shown: -> @is_shown
      get_is_login: -> @login_or_reg is 'login'

    $scope.login = (user_id, password)->
      $scope.err = []
      user.login user_id, password, (err, result) ->
        $scope.is_logined = user.is_logged_in()
        if err
          $scope.err.push err
        else
          $scope.login_form.hide_form()

    $scope.logout = ->
      user.logout ->
        $scope.is_logined = user.is_logged_in()

    $scope.create_user = (user_id, password,recaptcha_response)->
      console.log 're', recaptcha_response
      $scope.err = []
      user.create_user user_id, password, recaptcha_response, (err, result)->
        $scope.is_logined = user.is_logged_in()
        if err
          $scope.err.push err
        else
          $scope.login_form.hide_form()

    $scope.recaptcha =
      reload: -> Recaptcha.reload()

    $scope.menu = [
      title: 'Home'
      link: '/'
    ]
    
    $scope.isActive = (route) ->
      route is $location.path()