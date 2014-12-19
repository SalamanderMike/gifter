GifterControllers = angular.module("GifterControllers", ["ngResource", "ngAnimate"])

class GifterCtrl
  constructor: (@scope, @http, @resource, @rootScope, @location, @timeout, @Suggestions)->
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
      @diagnosticButton = false

      @toggleDropdown = false
      @matchNow = false
      @matched = false





      # SET RESOURCE PATHS
      User = @resource("/users/:id.json", {id:@sessionID}, {update: {method: 'PUT'}})
      User.get (session)=> #find current user data
        @user = session

      # FACTORY - SETUP EVENTS & MATCHES
      # Find all user's events by event ID through linker table
      UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (links)=>
        # Grab Events by their discovered IDs, push them into an array [@myEvents]
        #   and log all the matches [@myMatch]
        for eventLink of links # eventLink = Event.id
          do (eventLink)=>
            # console.log eventLink
            if links[eventLink].event_id
              do ()=>
                # Get total number of participants signed up for this Event
                UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:links[eventLink].event_id}, {'query': {method: 'GET', isArray: true}})
                UsersInEvents.query (users)=>
                  @totalParticipants = users.length

                  # for i of users
                  #   console.log users[i].user_id

                  # Find matches in Event
                  Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:links[eventLink].event_id}, {update: {method: 'PUT'}})
                  Event.get (thisEvent)=>
                    do (thisEvent)=>
                    # Display to screen - timeout ensures this happens last
                    @timeout(()=>
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
                      # @home = true# Show Home page after calculation is done
                    , 50)
        @timeout(()=>
          @home = true# Show Home page after calculation is done
        , 300)



      @Profile = @resource("users/:user_id/profile/:id.json", {user_id:@sessionID, id:@sessionID}, {update: {method: 'PUT'}})
      @Profile.get (profile)=> #find user's profile
        # INITIALIZE PROFILE WITH SUGGESTED DATA
        if @sessionID == 4 || !profile.cuisine
          profile.cuisine = ["Gewurztraminer", "Shortbread", "Gourmet Cheddar"]
          profile.shops = ["iTunes", "Best Buy", "Starbucks"]
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


  #Simple Test Function
  test: =>
    console.log "TEST"


#FUNCTIONS
  matchEveryoneNow: (eventID)=>
    usersArray = []
    if @matched == true
      confirm "WARNING: Rematching participants may lead to people having to return gifts. Are you sure?"
    do (usersArray)=>
      # Get total number of participants signed up for this Event
      UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
      UsersInEvents.query (usersArray)=>
        if usersArray.length > 2
          Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
          Event.get (thisEvent)=>
            do (thisEvent)=>
              # MATCHING ALGORITHM
              currentIndex = usersArray.length - 1
              lastUser = currentIndex
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
                thisEvent.participants = usersArray.length
                thisEvent.$update()
        else
          alert "You need a minimum of THREE participants to Match"
    @timeout(()=>
      @matched = false
      @matchNow = false
      @updateProfilePage()
      @participantsInEvent(eventID)
    , 200)


  updateProfilePage: =>
    # Find all user's events by event ID through linker table
    @myMatch = []
    @myEvents = []
    UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
    UserEvents.query (links)=>
      # Grab Events by their discovered IDs, push them into an array [@myEvents]
      #   and log all the matches [@myMatch]
      for eventLink of links # eventLink = Event.id
        do (eventLink)=>
          # console.log eventLink
          if links[eventLink].event_id
            do ()=>
              # Get total number of participants signed up for this Event
              UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:links[eventLink].event_id}, {'query': {method: 'GET', isArray: true}})
              UsersInEvents.query (users)=>
                @totalParticipants = users.length

                # Find matches in Event
                Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:links[eventLink].event_id}, {update: {method: 'PUT'}})
                Event.get (thisEvent)=>
                  do (thisEvent)=>
                  # Display to screen - timeout ensures this happens last
                  @timeout(()=>
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
                  , 50)

  getTags: =>
    @Profile.get (profile)=>
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

  thisMatchProfile: (eventID)=> # matchID = myMatch[matchID,eventID]
    console.log "thisMatchProfile()"
    @matchProfile = []
    console.log @myMatch
    if @myMatch
      index = @myMatch.length - 2
      while index > -1
        if @myMatch[index + 1] == eventID
          if @myMatch[index] != false
            @gifteePage()
            MatchProfile = @resource("users/:user_id/profile.json", {user_id:@myMatch[index]})
            MatchProfile.get (profile)=> #Find Giftee's Profile
              @matchProfile = profile
              @matchInterests = [
                ["Cuisine",profile.cuisine,"cuisine"],
                ["Stores",profile.shops,"shops"],
                ["Services",profile.services,"services"],
                ["Book Genre, Title, or Author",profile.bookGenre,"bookGenre"],
                ["Music Genre, Artist, or Album",profile.musicGenre,"musicGenre"],
                ["Clothing",profile.clothes,"clothes"],
                ["Animals",profile.animal,"animal"],
                ["Color",profile.color,"color"],
                ["Metal",profile.metal,"metal"],
                ["Element",profile.element,"element"],
                ["Art",profile.art,"art"],
                ["Hobbies",profile.hobbies,"hobbies"]
              ]
              MatchName = @resource("/users/:id.json", {id:profile.user_id})
              MatchName.get (profile)=> # Grab Giftee's Name
                @matchName = "#{profile.firstname} #{profile.lastname}"
              Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
              Event.get (thisEvent)=> # Grab Event Title & Spending Limit
                @eventTitle = thisEvent.eventName
                @eventLimit = thisEvent.spendingLimit
          else
            alert "Sorry, your match isn't ready for this Event.\nTry again later!"
        index -= 2

  thisEventColor: (match)=>
    if match
      return "background: -webkit-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* Chrome10+,Safari5.1+ */
              background: -moz-linear-gradient(-45deg, #bef0aa 0%, #f0f0f0 48%, #ffffff 65%, #bdf0e1 100%); /* FF3.6+ */
              background: -ms-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* IE10+ */
              background: -o-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* Opera 11.10+ */
              background: linear-gradient(135deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* W3C */"
    return "background: -moz-linear-gradient(-45deg, #ffc8c8 0%, #f0f0f0 48%, #ffffff 65%, #ffcdff 100%); /* FF3.6+ */
            background: -webkit-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* IE10+ */
            background: linear-gradient(135deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* W3C */"

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
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
    Event.get (thisEvent)=> # Grab Event Title & Spending Limit
      @participating = thisEvent.participants
      @eventLimit = thisEvent.spendingLimit
      matches = thisEvent.match
      @participants = []
      participant = []
      i = 0
      # Get all users in event by id
      UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
      UsersInEvents.query (participants)=>
        @participantNum = participants.length
        unsignedParticipants = @participating - participants.length

        # Find each user's id & name
        while i < participants.length
          do (i)=>
            User = @resource("/users/:id.json", {id:participants[i].user_id})
            User.get (user)=>
              name = "#{user.firstname} #{user.lastname}"
              if matches
                @matched = true
                index = matches.length - 2
                while index > -1
                  do (index)=>
                    if +matches[index] == user.id
                      # Push to 2D array
                      User = @resource("/users/:id.json", {id: +matches[index + 1]})
                      User.get (match)=>
                        matchName = "#{match.firstname} #{match.lastname}"
                        @participants[i] = []
                        @participants[i].push(user.id, name, matchName)
                  index -= 2
              else
                @matchNow = true
                @participants[i] = []
                @participants[i].push(user.id, name, "")
          i += 1

        # Blank slots for participants not yet signed up
        @timeout(()=>
            if unsignedParticipants > 0
              while i < @participating
                do (i)=>
                  # Push to 2D array
                  @participants[i] = []
                  @participants[i].push(false, ". . .")
                i += 1
        , 0)

  diagnosticParticipantList: (eventID)=>
    console.log "DIAGNOSTICS..."
    @matched = false
    @matchNow = false
    console.log eventID
    # With a little forced synchonicity to keep list orderly
    Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID})
    Event.get (thisEvent)=> # Grab Event Title & Spending Limit
      @participating = thisEvent.participants
      @eventLimit = thisEvent.spendingLimit
      matches = thisEvent.match
      @participants = []
      participant = []
      i = 0

      # Get all users in event by id
      UsersInEvents = @resource("/index_participants/:event_id.json", {event_id:eventID}, {'query': {method: 'GET', isArray: true}})
      UsersInEvents.query (participants)=>
        @participantNum = participants.length
        unsignedParticipants = @participating - participants.length

        # Find each user's id & name
        while i < participants.length
          do (i)=>
            User = @resource("/users/:id.json", {id:participants[i].user_id})
            User.get (user)=>
              name = "#{user.firstname} #{user.lastname}"
              @participants[i] = []
              @participants[i].push(user.id, name)
          i += 1



  diagnosticRemove: (user, userID, thisEvent)=>
    # Removes a participant. If matched, finds replacement
    console.log thisEvent.match
    if thisEvent.match
      result = confirm "Everyone in this Event has been MATCHED. By deleting this participant, are you prepared with a REPLACEMENT for their match?"
    if result
      replacement = prompt "Please enter the ID number of the extra participant who will replace the one you are deleting"

      do (thisEvent)=>
        for i of thisEvent.match
          if +thisEvent.match[i] == userID
            thisEvent.match.splice(i, 1, replacement)

      Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:thisEvent.id}, {update: {method: 'PUT'}})
      Event.get (dbEvent)=>
        dbEvent.match = thisEvent.match
        dbEvent.$update()
        console.log dbEvent.match

        @participants.splice(user, 1)
        @participantNum--
        @participating--





  removeParticipant: (user, userID, eventID)=>
    result = confirm "Are you sure you wish to remove this person from the Event?"
    if result
      @participants.splice(user, 1)
      @participantNum--
      @participating--
      if @sessionID != 4
        UserInEvent = @resource("/users/:user_id/users_events/:id.json", {user_id:userID, id:eventID}, {'delete': {method: 'DELETE'}})
        UserInEvent.delete()
        Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
        Event.get (thisEvent)=>
          thisEvent.participants -= 1
          thisEvent.$update()

  increaseParticipants: (eventID)=>
    index = @participants.length
    @participants[index] = []
    @participants[index].push(false, ". . .")
    @participating++
    if @sessionID != 4 # LIMIT DEMO
      Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
      Event.get (thisEvent)=>
        thisEvent.participants += 1
        thisEvent.$update()

  decreaseParticipants: (eventID)=>
    if @participants.length > @participantNum
      @participants.splice(-1, 1)
      @participating--
      if @sessionID != 4 # LIMIT DEMO
        Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
        Event.get (thisEvent)=>
          thisEvent.participants -= 1
          thisEvent.$update()
    else
      alert "Use the DELETE BUTTONS next to the name of the person you want to REMOVE from the Event"

  increaseLimit: (eventID)=>
    @eventLimit++
    if @sessionID != 4 # LIMIT DEMO
      Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
      Event.get (thisEvent)=>
        thisEvent.spendingLimit += 1
        thisEvent.$update()

  decreaseLimit: (eventID)=>
    @eventLimit--
    if @sessionID != 4 # LIMIT DEMO
      Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:eventID}, {update: {method: 'PUT'}})
      Event.get (thisEvent)=>
        thisEvent.spendingLimit -= 1
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
    @matchNow = false
    @matched = false
    @diagnosticButton = false
    @diagnostics = false
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
    @matchNow = false
    @matched = false
    @diagnosticButton = false
    @diagnostics = false
    #Visible
    @giftee = true
    @eventHeadding = true

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
    @matchNow = false
    @matched = false
    @diagnosticButton = false
    @diagnostics = false
    #Visible
    @chooseEvent = true
    @participants = []
    @adminsEvents = []
    @adminsEvents = events

  adminPage: (thisEvent)=>
    #Hidden
    @home = false
    @giftee = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    @diagnostics = false
    #Visible
    @diagnosticButton = if @sessionID == 4 then true else false
    @admin = true
    @eventHeadding = true
    @eventTitle = thisEvent.eventName
    @eventID = thisEvent.id
    @thisEvent = thisEvent
    @participantsInEvent(thisEvent.id)

  diagnosticsPage: (@thisEvent)=>
    #Hidden
    @admin = false
    @home = false
    @giftee = false
    @chooseEvent = false
    @createEvent = false
    @joinEventVisible = false
    @toggleDropdown = false
    @diagnosticButton = false
    #Visible
    @diagnostics = true
    @eventHeadding = true
    @eventTitle = @thisEvent.eventName
    @eventID = @thisEvent.id
    @diagnosticParticipantList(@thisEvent.id)



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
    @matchNow = false
    @matched = false
    @diagnosticButton = false
    @diagnostics = false
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
    @matchNow = false
    @matched = false
    @diagnosticButton = false
    @diagnostics = false
    #Visible
    @newEventShow = true
    @createEvent = true



# EVENT JOIN/CREATE **************************
  #ADD: Alert if user is already joined to that Event
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
              @myMatch.push(false, thisEvent.id)
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
    result = confirm "Please make sure you write down this Event name and Password and share it with all participants\nEvent: #{@scope.newEvent.eventName}\nPassword: #{@scope.newEvent.password}"
    if result
      @newEventShow = false
      Event = @resource("/users/:user_id/events.json", {user_id:@sessionID})
      @scope.newEvent.admin_id = @sessionID
      @scope.newEvent.spendingLimit = 5
      @scope.newEvent.participants = 10
      Event.save(@scope.newEvent)
      @scope.newEvent = {}
      @myEvents = []
      @myMatch.push(false, true)

      UserEvents = @resource("/index_user_events/:user_id/events.json", {user_id:@sessionID}, {'query': {method: 'GET', isArray: true}})
      UserEvents.query (data)=>
        for link in data
          Event = @resource("/users/:user_id/events/:id.json", {user_id:@sessionID, id:link.event_id})
          Event.get (thisEvent)=>
            @myEvents.push(thisEvent)

      @findAdminsEvents()


# END OF LINE **************************
  logout: ->
    @http.get("/logout.json")
    .success (data)=>
      location.href = "/"
    @rootScope.sessionID = null
    console.log "LOGGED OUT!"
GifterControllers.controller("GifterCtrl", ["$scope","$http", "$resource", "$rootScope", "$location", "$timeout", "Suggestions", GifterCtrl])
