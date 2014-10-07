GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    # if !@rootScope.sessionID
    #   console.log "SESSION DOESN'T EXIST"

    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
      @sessionID = user.id
      console.log @sessionID
      @user = {}
      @myProfile = {}
      @myMatch = [] # [eventID, profileID]
      @remove = false
      @interests = ["Cuisine","Stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art",]

      # SET RESOURCE PATHS
      @User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      @Event = @resource("/event_records.json", {}, {'query': {method: 'GET', isArray: true}})
      @UsersEvent = @resource("/user_to_events_records.json", {}, {'query': {method: 'GET', isArray: true}})

      # id: look up from ???
      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})


      # GET DATA
      @User.get (data)=> #find current user data
        @user = data


      @Event.query (data)=> #find user's events and Match for each event
        @events = data[0]
        if @events.match
          for i of @events.match
            if +@events.match[i][0] == @sessionID
              @myMatch.push(@events.id, +@events.match[i][1])

      @Profile.get (data)=> #find user's profile
        @myProfile = data

        # @allTags = [@myProfile.cuisine, @myProfile.shops, @myProfile.services,@myProfile.bookGenre, @myProfile.musicGenre, @myProfile.clothes, @myProfile.color,@myProfile.animal,@myProfile.metal,@myProfile.element,@myProfile.art]

    .error ()=>
      location.path("/login")




  thisMatchProfile: (matchID)=> # matchID = myMatch[event,matchID]
    for i of @profiles
      @matchProfile = @profiles[i] if @profiles[i].user_id == matchID


  getTags: =>
    @Profile.get (data)=>
      @myProfile = data


  addTag: (catagory)=>
    @myProfile[catagory].push(@scope.newTag)
    @myProfile.$update()
    @scope.newTag = ""

    #getTags()???
    @Profile.get (data)=>
      @myProfile = data


  removeTag: (tag, catagory)=>
    @myProfile[catagory].splice(tag, 1)
    @myProfile.$update()
    #getTags()???
    @Profile.get (data)=>
      @myProfile = data













  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

