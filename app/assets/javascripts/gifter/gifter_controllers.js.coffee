GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate", "ui.bootstrap"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @location, @timeout, @modal, @Suggestions)->
    # console.log "HELLO! I'm the Gifter Controller!"
    # if !@rootScope.sessionID
    #   console.log "SESSION DOESN'T EXIST"
    @http.get("/authorized.json")
    .success (user)=>
      @sessionID = user.id
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
      User.get (session)=> #find current user data
        @user = session

      # FACTORY - SETUP EVENTS & MATCHES
      # Find all user's events by event ID through linker table
      UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (data)=>
        link = data.slice(-data.length)
        # Grab Events by their discovered IDs, push them into an array [@myEvents]
        #   and log all the matches [@myMatch]
        for eventLink of link # eventLink = Event.id
          do (eventLink)=>
            # console.log eventLink
            if data[eventLink].event_id
              usersArray = []
              do (usersArray)=>
                # Get total number of participants signed up for this Event
                UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:data[eventLink].event_id}, {'query': {method: 'GET', isArray: true}})
                UsersInEvents.query (users)=>
                  @totalParticipants = users.length
                  usersArray = users.slice(-users.length) #slice off promises

                  # Find matches in Event
                  Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:data[eventLink].event_id}, {update: {method: 'PUT'}})
                  Event.get (thisEvent)=>
                    do (thisEvent)=>
                      # MATCHING ALGORITHM
                      currentIndex = usersArray.length - 1
                      lastUser = currentIndex
                      if !thisEvent.match and users.length > 2
                        if usersArray.length == thisEvent.participants
                          console.log "MATCH EVENT:", thisEvent.id
                          # Randomize usersArray
                          do (usersArray)=>
                            while currentIndex != 0
                              do (currentIndex)=>
                                # Pick random index...
                                randomIndex = Math.floor(Math.random() * currentIndex)
                                # Hold & Swap...
                                temporaryValue = usersArray[currentIndex]
                                usersArray[currentIndex] = usersArray[randomIndex]
                                usersArray[randomIndex] = temporaryValue
                              currentIndex -= 1
                            matchArray = [usersArray[0].user_id, usersArray[lastUser].user_id]
                            currentIndex = lastUser
                            # SAVE MATCHES TO DATABASE
                            while currentIndex != 0
                              do (currentIndex)=>
                                matchArray.push(usersArray[currentIndex].user_id, usersArray[currentIndex - 1].user_id)
                              currentIndex -= 1
                            thisEvent.match = matchArray
                            thisEvent.$update()
                            console.log matchArray

                    # Display to screen - timeout ensures this happens last
                    @timeout(()=>
                      pair = eventLink
                      @myEvents.push(thisEvent)
                      # Keep track of Matches
                      if thisEvent.match #check against NULL
                        userID = thisEvent.match.length - 2
                        # Push into 2D array
                        while userID > -1
                          do (userID)=>
                            if +thisEvent.match[userID] == @sessionID
                              @myMatch.push(+thisEvent.match[userID + 1], thisEvent.id)
                          userID = userID - 2
                      # Or if Event has no match yet...
                      else
                        @myMatch.push(false, thisEvent.id)
                      @home = true# Show Home page after calculation is done
                    , 50)



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
    @matchProfile = []
    if @myMatch
      index = @myMatch.length - 2
      while index > -1
        if @myMatch[index + 1] == eventID
          if @myMatch[index] != false
            @gifteePage()
            MatchProfile = @resource("users/:user_id/profile.json", {user_id:@myMatch[index]})
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
        index = index - 2

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
    # console.log "LIST OF PARTICIPANTS..."
      # With a little forced synchonicity to keep list orderly
    @participants = []
    participantNum = 0
    i = 0
    UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
    UsersInEvents.query (data)=>
      @participantNum = data.length
      participantNum = data.length
      while i < data.length
        do (i)=>
          User = @resource("/users/:id.json", {id:data[i].user_id})
          User.get (user)=>
            name = "#{user.firstname} #{user.lastname}"
            @participants[i] = []
            @participants[i].push(user.id, name)
        i += 1


      @timeout(()=>
        Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
        Event.get (thisEvent)=> # Grab Event Title & Spending Limit
          @participating = thisEvent.participants
          @eventLimit = thisEvent.spendingLimit
          unsignedParticipants = @participating - participantNum
          if unsignedParticipants > 0
            while i < @participating
              do (i)=>
                @participants[i] = []
                @participants[i].push(false, ". . .")
              i += 1
      , 150)

# FIX THIS ***********************
  removeParticipant: (userID, eventID)=>
    # confirm "Are you sure you wish to remove this person from the Event?"
    console.log eventID
    console.log userID
    @participants.splice(userID, 1)
    @participantNum--
    @participating--
    # UserInEvent = @resource("/users/:user_id/users_events/:id.json", {user_id:userID, id:eventID})
    # UserInEvent.get (participant)=>
    #   participant.$destroy()

  increaseParticipants: (eventID)=>
    index = @participants.length
    @participants[index] = []
    @participants[index].push(false, ". . .")
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (thisEvent)=>
      thisEvent.participants += 1
      @participating = thisEvent.participants
      thisEvent.$update()

  decreaseParticipants: (eventID)=>
    if @participants.length > @participantNum
      @participants.splice(-1, 1)
      Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
      Event.get (thisEvent)=>
        thisEvent.participants -= 1
        @participating = thisEvent.participants
        thisEvent.$update()
    else
      alert "Use the delete buttons next to the name you want to REMOVE from the Event"

  increaseLimit: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (thisEvent)=>
      thisEvent.spendingLimit += 1
      @eventLimit = thisEvent.spendingLimit
      thisEvent.$update()

  decreaseLimit: (eventID)=>
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
    Event.get (thisEvent)=>
      thisEvent.spendingLimit -= 1
      @eventLimit = thisEvent.spendingLimit
      thisEvent.$update()




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

# END OF LINE **************************
  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$location", "$timeout", "$modal", "Suggestions", GifterCtrl])
