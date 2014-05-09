'use strict'

angular.module('tagNebulaApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngTouch',
  'vcRecaptcha'
]).config ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'MainCtrl'

    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode true
