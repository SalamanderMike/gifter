GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @modal, @location, @Suggestions) ->
    console.log "HELLO! I'm the Gifter Controller!"
    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
      @sessionID = user.id
      @user = {}
      @myProfile = {}
      @myMatch = [] # [eventID, profileID]
      @remove = false
      @interests = ["Cuisine","Stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art",]

      @User = @resource("/user_records.json", {}, {'query': {method: 'GET', isArray: false}})
      @Event = @resource("/event_records.json", {}, {'query': {method: 'GET', isArray: true}})
      @Profile = @resource("/profile_records.json", {}, {'query': {method: 'GET', isArray: true}})
      @UsersEvent = @resource("/user_to_events_records.json", {}, {'query': {method: 'GET', isArray: true}})


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




  thisMatchProfile: (matchID)-> # matchID = myMatch[event,matchID]
    for i of @profiles
      @matchProfile = @profiles[i] if @profiles[i].user_id == matchID


  getTags: ->



  addTag: (tag)->





  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"



  removeTag: (tag)=>
    # @http.delete("/books/#{this.book.id}.json").success (data) ->
    # $scope.books.splice($scope.books.indexOf(book),1)
    @remove = true
    console.log "REMOVED!"


GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])

