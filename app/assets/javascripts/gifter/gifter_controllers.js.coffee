GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    if !@rootScope.sessionID
      console.log "SESSION DOESN'T EXIST"

    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
      console.log @rootScope.sessionID
      @sessionID = user.id
      @user = {}
      @myProfile = {}
      @myMatch = [] # [eventID, profileID]
      @remove = false
      @interests = ["Cuisine","Stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art",]

      # SET RESOURCE PATHS
      @User = @resource("/user_records.json", {}, {'query': {method: 'GET', isArray: false}})
      @Event = @resource("/event_records.json", {}, {'query': {method: 'GET', isArray: true}})
      @Profile = @resource("/profile_records.json", {}, {'query': {method: 'GET', isArray: true}})
      @UsersEvent = @resource("/user_to_events_records.json", {}, {'query': {method: 'GET', isArray: true}})

      # GET DATA
      @User.query (data)=> #find current user data
        @user = data

      @Event.query (data)=> #find user's events and Match for each event
        @events = data[0]
        if @events.match
          for i of @events.match
            if +@events.match[i][0] == @sessionID
              @myMatch.push(@events.id, +@events.match[i][1])

      @Profile.query (data)=> #find user's profile
        @profiles = data
        for i of @profiles
          @myProfile = @profiles[i] if @profiles[i].user_id == @sessionID
        @allTags = [@myProfile.cuisine, @myProfile.shops, @myProfile.services,@myProfile.bookGenre, @myProfile.musicGenre, @myProfile.clothes, @myProfile.color,@myProfile.animal,@myProfile.metal,@myProfile.element,@myProfile.art]

    .error ()=>
      location.path("/login")




  thisMatchProfile: (matchID)=> # matchID = myMatch[event,matchID]
    for i of @profiles
      @matchProfile = @profiles[i] if @profiles[i].user_id == matchID


  getTags: =>



  addTag: (tag)=>
    console.log tag
    console.log @myMatch[1]
    @newTag = {}

    @http.post("/users/#{@sessionID}/profile.json", @newTag).success (data) -> # Create route
      @myProfile.push(data)



  removeTag: (tag)=>
    @http.delete("/users/#{@sessionID}/profile/#{@myMatch[1]}.json").success (data) ->
      @profiles.splice(@profiles.indexOf(tag),1)
      @remove = true
      console.log "REMOVED!"




  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

