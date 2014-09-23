GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @Suggestions, @modal) ->
    console.log "HELLO! I'm the Gifter Controller!"

























GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$modal", "Suggestions", GifterCtrl])

