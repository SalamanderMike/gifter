GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
    .error ()=>
      location.path("/login")

    @tags = [" Imports ", " Photography ", "Figurines","Indie", "Classical", "Pop"]


    removeTag = ->
      #delete interestTag from DB and display
















  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

