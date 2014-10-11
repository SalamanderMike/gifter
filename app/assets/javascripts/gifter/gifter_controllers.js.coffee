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
      @home = true    # Hide/Show Home page
      @giftee = false # Hide/Show Match Profile page
      @admin = false  # Hide/Show Admin Settings
      @user = {}      # Account Info
      @eventTitle = ""# Event Title
      @myEvents = []  # Event Panels
      @myProfile = {} # Interest Panels/Tags
      @myMatch = []   # [event_id, profile_id] 2D Array
      @matchProfile={}# Giftee's Profile
      @matchInterests=[]#Giftee's interests
      @matchName = "" # Giftee's Name
      @toggleDropdown = false

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
        # Interests [Title,DB Column,DB Catagory,Placeholders]
        @interests = [
          ["Cuisine",@myProfile.cuisine,"cuisine","Ice Cream... Mexican..."],
          ["Stores",@myProfile.shops,"shops","J.C. Penny... Hot Topic..."],
          ["Services",@myProfile.services,"services","Barnes & Noble Membership..."]
        ]

      # @allTags = [@myProfile.cuisine, @myProfile.shops, @myProfile.services,@myProfile.bookGenre, @myProfile.musicGenre, @myProfile.clothes, @myProfile.color,@myProfile.animal,@myProfile.metal,@myProfile.element,@myProfile.art]
      # @interests = ["cuisine","stores","services","Book Genre","Music Genre","Clothing","Color","Animals","Metal","Element","Art"]
    .error ()=>
      location.path("/login")

  getTags: =>
    @Profile.get (data)=>
      @myProfile = data
      @interests = [
        ["Cuisine",@myProfile.cuisine,"cuisine","Ice Cream... Mexican..."],
        ["Stores",@myProfile.shops,"shops","J.C. Penny... Hot Topic..."],
        ["Services",@myProfile.services,"services","Barnes & Noble Membership..."]
      ]

  addTag: (newTag, catagory)=>
    @myProfile[catagory].push(newTag)
    @myProfile.$update()
    newTag = null
    @getTags()

  removeTag: (tag, catagory)=>
    @myProfile[catagory].splice(tag, 1)
    @myProfile.$update()
    @getTags()

  thisMatchProfile: (eventID)=> # matchID = myMatch[event,matchID]
    @matchProfile = {}
    for match in @myMatch
      if match[0] == eventID
        if match[1] != false
          @gifteePage()
          MatchProfile = @resource("users/:user_id/profile.json", {user_id:match[1]})
          MatchProfile.get (data)=> #Find Giftee's Profile
            @matchProfile = data
            @matchInterests = [
              ["Cuisine",data.cuisine,"cuisine"],
              ["Stores",data.shops,"shops"],
              ["Services",data.services,"services"]
            ]
            MatchName = @resource("/users/:id.json", {id:data.user_id})
            MatchName.get (data)=> # Grab Giftee's Name
              @matchName = "#{data.firstname} #{data.lastname}"
            EventTitle = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
            EventTitle.get (title)=> # Grab Event Title
              @eventTitle = title.eventName
        else
          alert "Sorry, your match isn't ready for this Event.\nTry again later!"




  homePage: =>
    @home = true
    @giftee = false
    @admin = false
    console.log "HOKUS POKUS!!!"

  gifteePage: =>
    @home = false
    @giftee = true
    @admin = false
    console.log "HOKUS POKUS!!!"

  adminPage: =>
    @home = false
    @giftee = false
    @admin = true
    console.log "HOKUS POKUS!!!"








  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])
