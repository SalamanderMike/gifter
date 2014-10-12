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
      @chooseEvent=false#Hide/Show Event Edit Choice
      @eventHeadding=false#Hide/Show Event Title in Navbar
      @createEvent=false#Hide/Show Create New Event page
      @user = {}      # Account Info
      @eventTitle = ""# Event Title
      @myEvents = []  # Event Panels
      @myProfile = {} # Interest Panels/Tags
      @myMatch = []   # [event_id, profile_id] 2D Array
      @adminsEvents=[]# Events you are leading
      @matchProfile={}# Giftee's Profile
      @matchInterests=[]#Giftee's interests
      @matchName = "" # Giftee's Name
      @notReady = true# Indicates there is no match for this event
      @participants = []

      @hidden = false

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
          ["Services",@myProfile.services,"services","Barnes & Noble Membership..."],
          ["Book Genre",@myProfile.bookGenre,"bookGenre","Barnes & Noble Membership..."],
          ["Music Genre",@myProfile.musicGenre,"musicGenre","Barnes & Noble Membership..."],
          ["Clothing",@myProfile.clothes,"clothes","Barnes & Noble Membership..."],
          ["Animals",@myProfile.animal,"animal","Barnes & Noble Membership..."],
          ["Color",@myProfile.color,"color","Barnes & Noble Membership..."],
          ["Metal",@myProfile.metal,"metal","Barnes & Noble Membership..."],
          ["Element",@myProfile.element,"element","Barnes & Noble Membership..."],
          ["Art",@myProfile.art,"art","Barnes & Noble Membership..."],
          ["Hobbies",@myProfile.hobbies,"hobbies","Barnes & Noble Membership..."]
        ]

    .error ()=>
      location.path("/login")

  getTags: =>
    @Profile.get (data)=>
      @myProfile = data
      @interests = [
          ["Cuisine",@myProfile.cuisine,"cuisine","Ice Cream... Mexican..."],
          ["Stores",@myProfile.shops,"shops","J.C. Penny... Hot Topic..."],
          ["Services",@myProfile.services,"services","Barnes & Noble Membership..."],
          ["Book Genre",@myProfile.bookGenre,"bookGenre","Barnes & Noble Membership..."],
          ["Music Genre",@myProfile.musicGenre,"musicGenre","Barnes & Noble Membership..."],
          ["Clothing",@myProfile.clothes,"clothes","Barnes & Noble Membership..."],
          ["Animals",@myProfile.animal,"animal","Barnes & Noble Membership..."],
          ["Color",@myProfile.color,"color","Barnes & Noble Membership..."],
          ["Metal",@myProfile.metal,"metal","Barnes & Noble Membership..."],
          ["Element",@myProfile.element,"element","Barnes & Noble Membership..."],
          ["Art",@myProfile.art,"art","Barnes & Noble Membership..."],
          ["Hobbies",@myProfile.hobbies,"hobbies","Barnes & Noble Membership..."]
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
              ["Services",data.services,"services"],
              ["Book Genre",data.bookGenre,"bookGenre"],
              ["Music Genre",data.musicGenre,"musicGenre"],
              ["Clothing",data.clothes,"clothes"]
            ]
            MatchName = @resource("/users/:id.json", {id:data.user_id})
            MatchName.get (data)=> # Grab Giftee's Name
              @matchName = "#{data.firstname} #{data.lastname}"
            EventTitle = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
            EventTitle.get (title)=> # Grab Event Title
              @eventTitle = title.eventName
        else
          alert "Sorry, your match isn't ready for this Event.\nTry again later!"

  findAdminsEvents: =>
    AdminsEvents = @resource("/index_admin_events.json", {}, {'query': {method: 'GET', isArray: true}})
    AdminsEvents.query (data)=>
      if data[0]
        if data.length > 1
          @chooseEventToEdit(data)
        else
          @adminPage(data[0])
      else
        alert "You aren't leading any events, yet.\nTry creating one, then invite people to join!"

  participantsInEvent: (eventID)=>
    console.log "LIST OF PARTICIPANTS..."
    UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
    UsersInEvents.query (data)=>
      @participants = data
      console.log data

# SPA PAGES **************************
  chooseEventToEdit: (events)=>
    @home = false
    @giftee = false
    @admin = false
    @chooseEvent = true
    @adminsEvents = events

  homePage: =>
    @home = true
    @giftee = false
    @admin = false

  gifteePage: =>
    @home = false
    @giftee = true
    @admin = false
    @eventHeadding = true

  adminPage: (event)=>
    console.log "EVENT SETTINGS..."
    @home = false
    @giftee = false
    @admin = true
    @chooseEvent = false
    @eventHeadding = true
    @eventTitle = event.eventName
    console.log event
    @participantsInEvent(event.id)

  EventCreatePage: =>
    console.log "CREATE EVENT PAGE..."
    @eventHeadding = ""
    @home = false
    @giftee = false
    @admin = false
    @chooseEvent = false
    @eventHeadding = true
    @createEvent = true

  createNewEvent: (data)=>
    console.log "CREATE THIS EVENT..."
    console.log data


# END OF LINE **************************
  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])
