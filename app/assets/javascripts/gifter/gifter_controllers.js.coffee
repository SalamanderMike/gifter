GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @Suggestions) ->
    # console.log "HELLO! I'm the Gifter Controller!"
    # if !@rootScope.sessionID
    #   console.log "SESSION DOESN'T EXIST"

    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
      @sessionID = user.id
      console.log "USER ID:#{@sessionID}"
      @user = {}
      @myEvents = []
      @myProfileID = ""
      @myProfile = {}
      @myMatch = [] # [eventID, profileID]
      @interests = ["Cuisine","Stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art",]

      # SET RESOURCE PATHS
      User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      User.get (data)=> #find current user data
        @user = data

      # Find all user's events by event ID through linker table
      UserEvents = @resource("/users/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (data)=>
        index = 0
        pair = 0
        # Grab Events by their discovered IDs, push them into an array [myEvents]
        for link of data
          if data[link].event_id
            eventID = data[link].event_id
            Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
            Event.get (event)=>
              @myEvents.push(event)
              matches = @myEvents[index].match
              ++index
              for i of matches
                if +matches[i][0] == @sessionID
                  @myMatch[pair] = []
                  @myMatch[pair].push(event.id, +matches[i][1])
                  ++pair

      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})
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
    # console.log @myMatch












  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

