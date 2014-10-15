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
      @home = false   # Hide/Show Home page
      @giftee = false # Hide/Show Match Profile page
      @admin = false  # Hide/Show Admin Settings
      @chooseEvent=false#Hide/Show Event Edit Choice
      @eventHeadding=false#Hide/Show Event Title in Navbar
      @joinEventVisible=false#
      @createEvent=false#Hide/Show Create New Event page
      @newEventShow=false
      @user = {}      # Account Info
      @eventTitle = ""# Event Title
      @eventLimit = 0
      @myEvents = []  # Event Panels
      @myProfile = {} # Interest Panels/Tags
      @interests = [] # Interests Data
      @myMatch = []   # [event_id, profile_id] 2D Array
      @adminsEvents=[]# Events you are leading
      @matchProfile={}# Giftee's Profile
      @matchInterests=[]#Giftee's interests
      @matchName = "" # Giftee's Name
      @notReady = true# Indicates there is no match for this event
      @participants = []
      @participantNum = 0

      @toggleDropdown = false

      # SET RESOURCE PATHS
      User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      User.get (data)=> #find current user data
        @user = data

      # Find all user's events by event ID through linker table
      @UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      @UserEvents.query (data)=>
        index = 0
        pair = 0
        # Grab Events by their discovered IDs, push them into an array [@myEvents]
        # and log all the matches [@myMatch]
        for link of data
          if data[link].event_id
            eventID = data[link].event_id
            # Get total number of participants for each Event
            @UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
            @UsersInEvents.query (data)=>
              @totalParticipants = data.length
              console.log "#{@totalParticipants} people in this User's Event"
            Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
            Event.get (event)=>
              @myEvents.push(event)
              console.log "#{event.participants} in Event"#***** MATCH ALGORITHM
              if event.participants == @totalParticipants#***** MATCH ALGORITHM
                console.log "#{event.eventName} has full participation!"#***** MATCH ALGORITHM
              # Keep track of Matches
              matches = @myEvents[index].match
              ++index
              if matches #check against NULL
                for i of matches
                  if +matches[i][0] == @sessionID
                    @myMatch[pair] = []
                    @myMatch[pair].push(event.id, +matches[i][1])
                    ++pair
              else #Event has no match yet
                @myMatch[pair] = []
                @myMatch[pair].push(event.id, false)
                ++pair
            @home = true# Show Home page after calculation is done

# NEXT STEP #1 MATCH ALGORITHM *********************

# Move @participants logic into here so that match logic can make matches*************************
# Grab all User's Events -UsersEvents
# data[i].length for each event_id -UsersEvents
# Grab Event with event_id -Events
# Compare data[i].length with Event.participants
# If they're equal, then run Match Algorithm



      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})
      @Profile.get (data)=> #find user's profile
        @myProfile = data
        # INITIALIZE PROFILE WITH SUGGESTED DATA
        if !data.cuisine
          @myProfile.cuisine = ["Wine", "Cookies", "Cheese"]
          @myProfile.shops = ["iTunes", "Best Buy", "Bed Bath & Beyond"]
          @myProfile.services = ["Spotify", "Pandora", "Dropbox"]
          @myProfile.bookGenre = ["Sci-fi", "Romance", "Mystery"]
          @myProfile.musicGenre = ["Indie", "Classical", "Pop"]
          @myProfile.clothes = ["Shirt", "Tie", "Scarf"]
          @myProfile.animal = ["Wolf", "Cat", "Girraffe"]
          @myProfile.color = ["blue"]
          @myProfile.metal = ["silver", "gold"]
          @myProfile.element = ["Wood", "Stone", "Glass"]
          @myProfile.art = ["Imports", "Photography", "Figurines"]
          @myProfile.hobbies = ["Reading", "Cooking", "Movies"]
          @myProfile.$update()
          @myProfile = data
          console.log @myProfile
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
          @home = true# Show Home page after calculation is done

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
        @home = true# Show Home page after calculation is done

    .error ()=>
      location.path("/login")

#FUNCTIONS
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
    console.log "thisMatchProfile()"
    @matchProfile = {}
    if @myMatch
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
              EventTitle.get (title)=> # Grab Event Title & Spending Limit
                @eventTitle = title.eventName
                @eventLimit = title.spendingLimit
          else
            alert "Sorry, your match isn't ready for this Event.\nTry again later!"

  thisEventColor: (match)=>
    if match
      return "-webkit-linear-gradient(-45deg, rgba(189,239,227,1) 0%,rgba(241,241,241,1) 48%,rgba(225,225,225,1) 65%,rgba(169,232,172,1) 100%)"
    return "-webkit-linear-gradient(-45deg, rgba(252,203,201,1) 0%,rgba(241,241,241,1) 48%,rgba(225,225,225,1) 65%,rgba(249,206,255,1) 100%)"

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
        @toggleDropdown = false

  participantsInEvent: (eventID)=>
    console.log "LIST OF PARTICIPANTS..."
    @UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
    @UsersInEvents.query (data)=>
      @participantNum = data.length
      for identity in data
        User = @resource("/users/:id.json", {id:identity.user_id})
        User.get (data)=>
          name = "#{data.firstname} #{data.lastname}"
          @participants.push(name)

  removeParticipant: (userID)=>#Implement soon
    # confirm "Are you sure you wish to remove this person from the group?"
    @participants.splice(userID, 1)
    @participantNum--
    # @participants.$update()





# SPA PAGES **************************
  homePage: =>
    #Hidden
    @giftee = false
    @admin = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    #Visible
    @home = true

  gifteePage: =>
    #Hidden
    @home = false
    @admin = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    #Visible
    @giftee = true
    @eventHeadding = true

  adminPage: (event)=>
    #Hidden
    @home = false
    @giftee = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    #Visible
    @admin = true
    @eventHeadding = true
    @eventTitle = event.eventName
    @participantsInEvent(event.id)

  chooseEventToEdit: (events)=>
    #Hidden
    @home = false
    @giftee = false
    @admin = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    #Visible
    @chooseEvent = true
    @adminsEvents = events

  joinEventPage: =>
    #Hidden
    @home = false
    @giftee = false
    @admin = false
    @chooseEvent = false
    @createEvent = false
    @toggleDropdown = false
    #Visible
    @eventHeadding = true
    @joinEventVisible = true

  EventCreatePage: =>
    #Hidden
    @home = false
    @giftee = false
    @admin = false
    @chooseEvent = false
    @eventHeadding = false
    @joinEventVisible = false
    @toggleDropdown = false
    #Visible
    @newEventShow = true
    @createEvent = true

# EVENT JOIN/CREATE **************************
  joinEvent: =>
    console.log "JOIN EVENT..."
    #find all Events
    Event = @resource("/users/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
    Event.query (data)=>
      for event in data
        if @scope.join.eventName == event.eventName#Find event by eventName to grab its :id
          if @scope.join.password == event.password
            thisEvent = event
            Event = @resource("/users/:user_id/events/:id", {user_id:@sessionID,id:event.id}, {update: {method: 'PUT'}})
            Event.update (data)=>
              @myEvents.push(thisEvent)
              pair = @myMatch.length
              @myMatch[pair] = []
              @myMatch[pair].push(thisEvent.id, false)
              @homePage()
          else
            alert "Password is incorrect for this Event"
            @scope.join.password = ""
            return
      alert "We're sorry, but we can't find an Event with that name.\nTry again?"
      @scope.join = ""



  createNewEvent: =>
    @newEventShow = false
    Event = @resource("/users/:user_id/events.json", {user_id:@sessionID})
    @scope.newEvent.admin_id = @sessionID
    Event.save(@scope.newEvent)
    @myEvents.push(@scope.newEvent)
    pair = @myMatch.length
    @myMatch[pair] = []
    @myMatch[pair].push(event.id, false)
    @homePage()

# END OF LINE **************************
  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$modal", "$location", "Suggestions", GifterCtrl])
