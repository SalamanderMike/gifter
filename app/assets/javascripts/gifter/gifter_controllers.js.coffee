GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @location, @timeout, @modal, @Suggestions)->
    # console.log "HELLO! I'm the Gifter Controller!"
    # if !@rootScope.sessionID
    #   console.log "SESSION DOESN'T EXIST"
    console.log "CONSTRUCTOR"
    @http.get("/authorized.json")
    .success (user)=>
      @rootScope.sessionID = user.id
      @sessionID = user.id
      # console.log "USER ID:#{@sessionID}"
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
      @interests = [] # Interests Data
      @myMatch = []   # [event_id, profile_id] 2D Array
      @adminsEvents=[]# Events you are leading
      @matchProfile={}# Giftee's Profile
      @matchInterests=[]#Giftee's interests
      @matchName = "" # Giftee's Name
      @notReady = true# Indicates there is no match for this event
      @participants = []
      @participating = 0# Reflects num in Events.participants
      @participantNum = 0
      @regexNum = /^[0-9]+$/ # ERROR: returning undefined

      @demoLimits = if @sessionID == 4 then true else false

      @toggleDropdown = false



      # SET RESOURCE PATHS
      User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      User.get (data)=> #find current user data
        @user = data
        console.log "USERS"

      # Find all user's events by event ID through linker table
      UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (data)=>
        console.log data.length
        index = 0
        pair = 0
        # Grab Events by their discovered IDs, push them into an array [@myEvents]
        # and log all the matches [@myMatch]

        for link of data
          do (link)=>
            if data[link].event_id
              eventID = data[link].event_id
              # Get total number of participants for each Event
              UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
              UsersInEvents.query (data)=>
                @totalParticipants = data.length
                console.log "1) #{@totalParticipants} people signed up for event: #{eventID}"
              Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
              Event.get (event)=>
                @myEvents.push(event)
                console.log "2) #{event.participants} people should be in Event: #{eventID}"#***** MATCH ALGORITHM
                # if event.participants == @totalParticipants#***** MATCH ALGORITHM
                  # console.log "#{event.eventName} has full participation!"#***** MATCH ALGORITHM
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
      @Profile.get (profile)=> #find user's profile
        # INITIALIZE PROFILE WITH SUGGESTED DATA
        if @sessionID == 4 || !profile.cuisine
          profile.cuisine = ["Gewurztraminer", "Shortbread", "Gourmet Cheddar"]
          profile.shops = ["iTunes", "Best Buy", "Bed Bath & Beyond"]
          profile.services = ["Spotify", "Pandora", "Dropbox"]
          profile.bookGenre = ["Sci-fi", "Isaac Asimov", "Pride and Prejudice"]
          profile.musicGenre = ["Indie", "Mozart", "The Supremes"]
          profile.clothes = ["Shirt", "Red Holiday Sweater", "Scarf"]
          profile.animal = ["Grey Wolf", "Kittens", "Girraffe"]
          profile.color = ["blue"]
          profile.metal = ["silver", "gold"]
          profile.element = ["Wood", "Stone", "Glass"]
          profile.art = ["Imports", "Photography", "Figurines"]
          profile.hobbies = ["Reading", "Cooking", "Movies"]
          profile.$update()

        # Interests [Title,DB Column,DB Catagory,Placeholders]
        @interests = [
          ["Cuisine",profile.cuisine,"cuisine","Dark Chocolate Ice Cream..."],
          ["Stores",profile.shops,"shops","J.C. Penny... Hot Topic..."],
          ["Services",profile.services,"services","Barnes & Noble Membership..."],
          ["Book Genre, Title, or Author",profile.bookGenre,"bookGenre","J.K. Rowling... Audiobook..."],
          ["Music Genre, Artist, or Album",profile.musicGenre,"musicGenre","Green Day... Holiday..."],
          ["Clothing",profile.clothes,"clothes","Socks... Tie... Slippers"],
          ["Animals",profile.animal,"animal","Blue Jay... Polar Bear..."],
          ["Color",profile.color,"color","Green... Silver..."],
          ["Metal",profile.metal,"metal","Puter... Titanium..."],
          ["Element",profile.element,"element","Tourmaline... Crystal..."],
          ["Art",profile.art,"art","Carving... Ceramic..."],
          ["Hobbies",profile.hobbies,"hobbies","Sports... Drawing..."]
        ]
        @home = true# Show Home page after calculation is done

    .error ()=>
      location.path("/login")


#FUNCTIONS
  getTags: =>
    @Profile.get (profile)=>
      @interests = [
        ["Cuisine",profile.cuisine,"cuisine","Ice Cream... Mexican..."],
        ["Stores",profile.shops,"shops","J.C. Penny... Hot Topic..."],
        ["Services",profile.services,"services","Barnes & Noble Membership..."],
        ["Book Genre",profile.bookGenre,"bookGenre","Biography... Audiobook..."],
        ["Music Genre",profile.musicGenre,"musicGenre","Metal... Holiday..."],
        ["Clothing",profile.clothes,"clothes","Socks... Sweater..."],
        ["Animals",profile.animal,"animal","Bird... Bear..."],
        ["Color",profile.color,"color","Green... Silver..."],
        ["Metal",profile.metal,"metal","Puter... Titanium..."],
        ["Element",profile.element,"element","Tourmaline... Crystal..."],
        ["Art",profile.art,"art","Carving... Ceramic..."],
        ["Hobbies",profile.hobbies,"hobbies","Sports... Rock Climbing..."]
      ]

  addTag: (newTag, catagory, catIndex)=>
    @interests[catIndex][1].push(newTag)
    @Profile.get (profile)=>
      profile[catagory].push(newTag)
      profile.$update()
      @getTags()


  removeTag: (tag, catagory, catIndex)=>
    @interests[catIndex][1].splice(tag, 1)
    @Profile.get (profile)=>
      profile[catagory].splice(tag, 1)
      profile.$update()

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
              Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
              Event.get (event)=> # Grab Event Title & Spending Limit
                @eventTitle = event.eventName
                @eventLimit = event.spendingLimit
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

  listSpaces: (eventID, participantNum)=>
    # console.log "LIST OF EMPTY SPACES..."
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
    Event.get (thisEvent)=> # Grab Event Title & Spending Limit
      @participating = thisEvent.participants
      @eventLimit = thisEvent.spendingLimit
      unsignedParticipants = @participating - participantNum
      if unsignedParticipants > 0
        i = 0
        while i < unsignedParticipants
          @participants.push(". . .")
          i++

  listPeople: (data)=>
    i = 0
    while i < data.length

      User = @resource("/users/:id.json", {id:data[i].user_id})
      User.get (user)=>
        name = "#{user.firstname} #{user.lastname}"
        @participants.push(name)

      do (i)->
        console.log "test", i

      ++i

  participantsInEvent: (eventID)=>
    # console.log "LIST OF PARTICIPANTS..."
    @participants = []
    UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
    UsersInEvents.query (data)=>
      #Add a little forced synchonicity to keep list orderly
      @timeout(()=>
        @listPeople(data)
      , 0)

      @timeout(()=>
        @listSpaces(eventID, data.length)
      , 300)


  removeParticipant: (userID)=>#Implement soon
    # confirm "Are you sure you wish to remove this person from the group?"
    @participants.splice(userID, 1)
    @participantNum--
    # @participants.$update()

  increaseParticipants: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (event)=>
      event.participants += 1
      @participating = event.participants
      event.$update()
      @participantsInEvent(eventID)


  decreaseParticipants: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (event)=>
      event.participants -= 1
      @participating = event.participants
      event.$update()
      @participantsInEvent(eventID)


  increaseLimit: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (event)=>
      event.spendingLimit += 1
      @eventLimit = event.spendingLimit
      event.$update()



  decreaseLimit: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (event)=>
      event.spendingLimit -= 1
      @eventLimit = event.spendingLimit
      event.$update()




# SPA PAGES **************************
  homePage: =>
    #Hidden
    @giftee = false
    @admin = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    @newEventShow = false
    @eventHeadding = false
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
    @eventID = event.id
    @participantsInEvent(event.id)

  chooseEventToEdit: (events)=>
    #Hidden
    @home = false
    @giftee = false
    @admin = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    @newEventShow = false
    @eventHeadding = false
    #Visible
    @chooseEvent = true
    @participants = []
    @adminsEvents = []
    @adminsEvents = events

  joinEventPage: =>
    #Hidden
    @home = false
    @giftee = false
    @admin = false
    @chooseEvent = false
    @createEvent = false
    @toggleDropdown = false
    @newEventShow = false
    @eventHeadding = false
    #Visible
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
    @eventHeadding = false
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
          eventNameExists = true
          if @scope.join.password == event.password
            thisEvent = event
            Event = @resource("/users/:user_id/users_events/:id.json", {user_id:@sessionID, id:event.id}, {update: {method: 'PUT'}})
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
      @scope.join.eventName = ""
      @scope.join.password = ""
      if !eventNameExists
        alert "We're sorry, but we can't find an Event with that name.\nTry again?"
        @scope.join = ""
        return

  createNewEvent: =>
    ok = confirm "Please make sure you write down this Event name and Password and share it with all participants\nEvent: #{@scope.newEvent.eventName}\nPassword: #{@scope.newEvent.password}"
    if ok == false
      return
    @newEventShow = false
    Event = @resource("/users/:user_id/events.json", {user_id:@sessionID})
    @scope.newEvent.admin_id = @sessionID
    @scope.newEvent.spendingLimit = parseInt(@scope.newEvent.spendingLimit)
    @scope.newEvent.participants = parseInt(@scope.newEvent.participants)
    Event.save(@scope.newEvent)
    @myEvents.push(@scope.newEvent)
    pair = @myMatch.length
    @myMatch[pair] = []
    @myMatch[pair].push(event.id, false)
    @scope.newEvent = {}
    @homePage()


  # SHUFFLE equation: *******************************************************
  # but use User.where() instead to limit to groups
  # User.all.map(&:id).shuffle.zip(User.all.map(&:id).shuffle)

# END OF LINE **************************
  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$location", "$timeout", "$modal", "Suggestions", GifterCtrl])
