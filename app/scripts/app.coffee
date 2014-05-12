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

  $sceDelegateProvider.resourceUrlWhitelist(['http*://tag.mono.mn/**', 'self']);

  $routeProvider
    .when '/',
      templateUrl: "#{apiRoot}/partials/main"
      controller: 'MainCtrl'


    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode true
