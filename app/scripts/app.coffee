'use strict'

angular.module('tagNebulaApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ngTouch',
]).config ($routeProvider, $locationProvider, $provide, $sceDelegateProvider) ->
  apiRoot = $("#linkApiRoot").attr("href")
  $provide.value "apiRoot", apiRoot

  $sceDelegateProvider.resourceUrlWhitelist(['http*://local.mono.mn:9000/**', 'self']);

  $routeProvider
    .when '/',
      templateUrl: "#{apiRoot}/partials/main"
      controller: 'MainCtrl'


    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode true
