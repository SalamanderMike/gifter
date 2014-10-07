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
      # @updateUser = @resource("/users/:id.json", {id:"@sessionID"}, {update: {method: 'PUT'}})
      @Event = @resource("/event_records.json", {}, {'query': {method: 'GET', isArray: true}})

      @UsersEvent = @resource("/user_to_events_records.json", {}, {'query': {method: 'GET', isArray: true}})

      # id: look up from ???
      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})


      # test = @Event.query({id:1}, =>
      #   console.log test.eventName
      #   test.eventName = "Mike's Event"
      #   console.log test.eventName)


      # GET DATA
      @User.get (data)=> #find current user data
        @user = data

        # UPDATE PATTERN
        # @user.firstname = "Darth"
        # @user.$update()


      @Event.query (data)=> #find user's events and Match for each event
        @events = data[0]
        if @events.match
          for i of @events.match
            if +@events.match[i][0] == @sessionID
              @myMatch.push(@events.id, +@events.match[i][1])

      @Profile.get (data)=> #find user's profile
        @myProfile = data

        #UPDATE PATTERN
        # @myProfile.services.push("Love")
        # @myProfile.$update()

        # @allTags = [@myProfile.cuisine, @myProfile.shops, @myProfile.services,@myProfile.bookGenre, @myProfile.musicGenre, @myProfile.clothes, @myProfile.color,@myProfile.animal,@myProfile.metal,@myProfile.element,@myProfile.art]

    .error ()=>
      location.path("/login")




  thisMatchProfile: (matchID)=> # matchID = myMatch[event,matchID]
    for i of @profiles
      @matchProfile = @profiles[i] if @profiles[i].user_id == matchID


  getTags: =>



  addTag: =>
    # @myProfile.services.push(@scope.newTag) #make catagory mutable******
    # @myProfile.$update()


    console.log @scope.newTag
    console.log @sessionID
    # console.log @myMatch[1]
    console.log @profiles

    # @Profile.save (@scope.newTag)=>
    #   console.log "SAVED!"
    # @http.post("/profile_records.json", @scope.newTag).success (data) -> # Create route
    # console.log data
    #   @myProfile.push(data)
    # @newTag = {}


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

