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
      @myProfile = {}
      @myMatch = [] # [eventID, profileID]
      @matchProfile = {}

      # @interests = ["Cuisine","Stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art",]

      # SET RESOURCE PATHS
      User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      User.get (data)=> #find current user data
        @user = data

      # Find all user's events by event ID through linker table
      UserEvents = @resource("/users/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (data)=>
        index = 0
        pair = 0
        # Grab Events by their discovered IDs, push them into an array [@myEvents]
        # and log all the matches [@myMatch]
        for link of data
          if data[link].event_id
            eventID = data[link].event_id
            Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
            Event.get (event)=>
              @myEvents.push(event)
              matches = @myEvents[index].match
              ++index
              if matches.length != 0 #Event has a match
                for i of matches
                  if +matches[i][0] == @sessionID
                    @myMatch[pair] = []
                    @myMatch[pair].push(event.id, +matches[i][1])
                    ++pair
              else #Event has no match yet
                @myMatch[pair] = []
                @myMatch[pair].push(event.id, false)
                ++pair

      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})
      @Profile.get (data)=> #find user's profile
        @myProfile = data

      # @allTags = [@myProfile.cuisine, @myProfile.shops, @myProfile.services,@myProfile.bookGenre, @myProfile.musicGenre, @myProfile.clothes, @myProfile.color,@myProfile.animal,@myProfile.metal,@myProfile.element,@myProfile.art]
    .error ()=>
      location.path("/login")

  getTags: =>
    @Profile.get (data)=>
      @myProfile = data

  addTag: (catagory)=>
    @myProfile[catagory].push(@scope.newTag)
    @myProfile.$update()
    @scope.newTag = ""
    @getTags()

  removeTag: (tag, catagory)=>
    # @myProfile[catagory].splice(tag, 1)
    # @myProfile.$update()
    # @getTags()

    @thisMatchProfile(2)
    # console.log @myMatch # TEST DATA


  thisMatchProfile: (matchID)=> # matchID = myMatch[event,matchID]
    @MatchProfile = @resource("users/:user_id/profile.json", {user_id:matchID})
    @MatchProfile.get (data)=> #find Giftee's profile
      @matchProfile = data
      console.log data









  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

