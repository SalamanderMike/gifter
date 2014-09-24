GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @window, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    @rootScope.sessionID = gon.global.sessionID if typeof gon != "undefined"
    @http.get("/login_check.json")
    .success (user)=>
      @rootScope.sessionID = user.id
    .error ()=>
      location.path("/login")





















  logout: ->
    console.log "LOGOUT!"
    @http.get("/stupid.json")
    .success (data)=>
      location.href = "/"
      console.log data
    .error (data)->
      console.log data
    @rootScope.sessionID = null



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "$window", "Suggestions", GifterCtrl])

