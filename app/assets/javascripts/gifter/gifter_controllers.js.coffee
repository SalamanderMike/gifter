GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    @rootScope.sessionID = gon.global.sessionID
    console.log gon.global.sessionID




















  logout: ->
    @rootScope.sessionID = null
    gon.global.sessionID = {} # HOW SEND BACK TO RAILS???
    console.log gon.global.sessionID



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "Suggestions", GifterCtrl])

