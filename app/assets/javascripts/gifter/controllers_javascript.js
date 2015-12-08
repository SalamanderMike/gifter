// GifterCtrl = angular.module('Control', ["ngResource", "ngAnimate"]);

// GifterCtrl.controller('TempControl', ['$scope', '$http', '$resource', '$rootScope', '$location', '$timeout', 'Suggestions', function (scope, http, resource, rootScope, location1, timeout, Suggestions) {
//     this.scope = scope;
//     this.http = http;
//     this.resource = resource;
//     this.rootScope = rootScope;
//     this.location = location1;
//     this.timeout = timeout;
//     this.Suggestions = Suggestions;
//     this.createNewEvent = bind(this.createNewEvent, this);
//     this.joinEvent = bind(this.joinEvent, this);
//     this.EventCreatePage = bind(this.EventCreatePage, this);
//     this.joinEventPage = bind(this.joinEventPage, this);
//     this.diagnosticsPage = bind(this.diagnosticsPage, this);
//     this.adminPage = bind(this.adminPage, this);
//     this.chooseEventToEdit = bind(this.chooseEventToEdit, this);
//     this.gifteePage = bind(this.gifteePage, this);
//     this.homePage = bind(this.homePage, this);
//     this.decreaseLimit = bind(this.decreaseLimit, this);
//     this.increaseLimit = bind(this.increaseLimit, this);
//     this.decreaseParticipants = bind(this.decreaseParticipants, this);
//     this.increaseParticipants = bind(this.increaseParticipants, this);
//     this.removeParticipant = bind(this.removeParticipant, this);
//     this.diagnosticsNameChange = bind(this.diagnosticsNameChange, this);
//     this.diagnosticRemove = bind(this.diagnosticRemove, this);
//     this.diagnosticParticipantList = bind(this.diagnosticParticipantList, this);
//     this.participantsInEvent = bind(this.participantsInEvent, this);
//     this.findAdminsEvents = bind(this.findAdminsEvents, this);
//     this.thisEventColor = bind(this.thisEventColor, this);
//     this.thisMatchProfile = bind(this.thisMatchProfile, this);
//     this.removeTag = bind(this.removeTag, this);
//     this.addTag = bind(this.addTag, this);
//     this.getTags = bind(this.getTags, this);
//     this.updateProfilePage = bind(this.updateProfilePage, this);
//     this.matchEveryoneNow = bind(this.matchEveryoneNow, this);
//     this.test = bind(this.test, this);
//     this.http.get("/authorized.json").success((function(_this) {
//       return function(user) {
//         var User, UserEvents;
//         _this.sessionID = user.id;
//         _this.home = false;
//         _this.giftee = false;
//         _this.admin = false;
//         _this.chooseEvent = false;
//         _this.eventHeadding = false;
//         _this.joinEventVisible = false;
//         _this.createEvent = false;
//         _this.newEventShow = false;
//         _this.user = {};
//         _this.eventTitle = "";
//         _this.eventLimit = 0;
//         _this.myEvents = [];
//         _this.interests = [];
//         _this.myMatch = [];
//         _this.adminsEvents = [];
//         _this.matchProfile = {};
//         _this.matchInterests = [];
//         _this.matchName = "";
//         _this.notReady = true;
//         _this.participants = [];
//         _this.participating = 0;
//         _this.participantNum = 0;
//         _this.regexNum = /^[0-9]+$/;
//         _this.demoLimits = _this.sessionID === 4 ? true : false;
//         _this.diagnosticButton = false;
//         _this.toggleDropdown = false;
//         _this.matchNow = false;
//         _this.matched = false;
//         User = _this.resource("/users/:id.json", {
//           id: _this.sessionID
//         }, {
//           update: {
//             method: 'PUT'
//           }
//         });
//         User.get(function(session) {
//           return _this.user = session;
//         });
//         UserEvents = _this.resource("/index_user_events/:user_id/events.json", {
//           user_id: _this.sessionID
//         }, {
//           'query': {
//             method: 'GET',
//             isArray: true
//           }
//         });
//         UserEvents.query(function(links) {
//           var eventLink, fn;
//           fn = function(eventLink) {
//             if (links[eventLink].event_id) {
//               return (function() {
//                 var UsersInEvents;
//                 UsersInEvents = _this.resource("/index_participants/:event_id.json", {
//                   event_id: links[eventLink].event_id
//                 }, {
//                   'query': {
//                     method: 'GET',
//                     isArray: true
//                   }
//                 });
//                 return UsersInEvents.query(function(users) {
//                   var Event;
//                   _this.totalParticipants = users.length;
//                   Event = _this.resource("/users/:user_id/events/:id.json", {
//                     user_id: _this.sessionID,
//                     id: links[eventLink].event_id
//                   }, {
//                     update: {
//                       method: 'PUT'
//                     }
//                   });
//                   return Event.get(function(thisEvent) {
//                     (function(thisEvent) {})(thisEvent);
//                     return _this.timeout(function() {
//                       var results, userID;
//                       _this.myEvents.push(thisEvent);
//                       if (thisEvent.match) {
//                         userID = thisEvent.match.length - 2;
//                         results = [];
//                         while (userID > -1) {
//                           (function(userID) {
//                             if (+thisEvent.match[userID] === _this.sessionID) {
//                               return _this.myMatch.push(+thisEvent.match[userID + 1], thisEvent.id);
//                             }
//                           })(userID);
//                           results.push(userID = userID - 2);
//                         }
//                         return results;
//                       } else {
//                         return _this.myMatch.push(false, thisEvent.id);
//                       }
//                     }, 50);
//                   });
//                 });
//               })();
//             }
//           };
//           for (eventLink in links) {
//             fn(eventLink);
//           }
//           return _this.timeout(function() {
//             return _this.home = true;
//           }, 300);
//         });
//         _this.Profile = _this.resource("users/:user_id/profile/:id.json", {
//           user_id: _this.sessionID,
//           id: _this.sessionID
//         }, {
//           update: {
//             method: 'PUT'
//           }
//         });
//         return _this.Profile.get(function(profile) {
//           if (_this.sessionID === 4 || !profile.cuisine) {
//             profile.cuisine = ["Gewurztraminer", "Shortbread", "Gourmet Cheddar"];
//             profile.shops = ["iTunes", "Best Buy", "Starbucks"];
//             profile.services = ["Spotify", "Pandora", "Dropbox"];
//             profile.bookGenre = ["Sci-fi", "Isaac Asimov", "Pride and Prejudice"];
//             profile.musicGenre = ["Indie", "Mozart", "The Supremes"];
//             profile.clothes = ["Shirt", "Red Holiday Sweater", "Scarf"];
//             profile.animal = ["Grey Wolf", "Kittens", "Girraffe"];
//             profile.color = ["blue"];
//             profile.metal = ["silver", "gold"];
//             profile.element = ["Wood", "Stone", "Glass"];
//             profile.art = ["Imports", "Photography", "Figurines"];
//             profile.hobbies = ["Reading", "Cooking", "Movies"];
//             profile.$update();
//           }
//           return _this.interests = [["Cuisine", profile.cuisine, "cuisine", "Dark Chocolate Ice Cream..."], ["Stores", profile.shops, "shops", "J.C. Penny... Hot Topic..."], ["Services", profile.services, "services", "Barnes & Noble Membership..."], ["Book Genre, Title, or Author", profile.bookGenre, "bookGenre", "J.K. Rowling... Audiobook..."], ["Music Genre, Artist, or Album", profile.musicGenre, "musicGenre", "Green Day... Holiday..."], ["Clothing", profile.clothes, "clothes", "Socks... Tie... Slippers"], ["Animals", profile.animal, "animal", "Blue Jay... Polar Bear..."], ["Color", profile.color, "color", "Green... Silver..."], ["Metal", profile.metal, "metal", "Puter... Titanium..."], ["Element", profile.element, "element", "Tourmaline... Crystal..."], ["Art", profile.art, "art", "Carving... Ceramic..."], ["Hobbies", profile.hobbies, "hobbies", "Sports... Drawing..."]];
//         });
//       };
//     })(this)).error((function(_this) {
//       return function() {
//         return location.path("/login");
//       };
//     })(this));
//   }

//   GifterCtrl.prototype.test = function() {
//     return console.log("TEST");
//   };

//   GifterCtrl.prototype.matchEveryoneNow = function(eventID) {
//     var usersArray;
//     usersArray = [];
//     if (this.matched === true) {
//       confirm("WARNING: Rematching participants may lead to people having to return gifts. Are you sure?");
//     }
//     (function(_this) {
//       return (function(usersArray) {
//         var UsersInEvents;
//         UsersInEvents = _this.resource("/index_participants/:event_id.json", {
//           event_id: eventID
//         }, {
//           'query': {
//             method: 'GET',
//             isArray: true
//           }
//         });
//         return UsersInEvents.query(function(usersArray) {
//           var Event;
//           if (usersArray.length > 2) {
//             Event = _this.resource("/users/:user_id/events/:id.json", {
//               user_id: _this.sessionID,
//               id: eventID
//             }, {
//               update: {
//                 method: 'PUT'
//               }
//             });
//             return Event.get(function(thisEvent) {
//               return (function(thisEvent) {
//                 var currentIndex, lastUser;
//                 currentIndex = usersArray.length - 1;
//                 lastUser = currentIndex;
//                 return (function(usersArray) {
//                   var matchArray;
//                   while (currentIndex !== 0) {
//                     (function(currentIndex) {
//                       var randomIndex, temporaryValue;
//                       randomIndex = Math.floor(Math.random() * currentIndex);
//                       temporaryValue = usersArray[currentIndex];
//                       usersArray[currentIndex] = usersArray[randomIndex];
//                       return usersArray[randomIndex] = temporaryValue;
//                     })(currentIndex);
//                     currentIndex -= 1;
//                   }
//                   matchArray = [usersArray[0].user_id, usersArray[lastUser].user_id];
//                   currentIndex = lastUser;
//                   while (currentIndex !== 0) {
//                     (function(currentIndex) {
//                       return matchArray.push(usersArray[currentIndex].user_id, usersArray[currentIndex - 1].user_id);
//                     })(currentIndex);
//                     currentIndex -= 1;
//                   }
//                   thisEvent.match = matchArray;
//                   thisEvent.participants = usersArray.length;
//                   return thisEvent.$update();
//                 })(usersArray);
//               })(thisEvent);
//             });
//           } else {
//             return alert("You need a minimum of THREE participants to Match");
//           }
//         });
//       });
//     })(this)(usersArray);
//     return this.timeout((function(_this) {
//       return function() {
//         _this.matched = false;
//         _this.matchNow = false;
//         _this.updateProfilePage();
//         return _this.participantsInEvent(eventID);
//       };
//     })(this), 200);
//   };

//   GifterCtrl.prototype.updateProfilePage = function() {
//     var UserEvents;
//     this.myMatch = [];
//     this.myEvents = [];
//     UserEvents = this.resource("/index_user_events/:user_id/events.json", {
//       user_id: this.sessionID
//     }, {
//       'query': {
//         method: 'GET',
//         isArray: true
//       }
//     });
//     return UserEvents.query((function(_this) {
//       return function(links) {
//         var eventLink, results;
//         results = [];
//         for (eventLink in links) {
//           results.push((function(eventLink) {
//             if (links[eventLink].event_id) {
//               return (function() {
//                 var UsersInEvents;
//                 UsersInEvents = _this.resource("/index_participants/:event_id.json", {
//                   event_id: links[eventLink].event_id
//                 }, {
//                   'query': {
//                     method: 'GET',
//                     isArray: true
//                   }
//                 });
//                 return UsersInEvents.query(function(users) {
//                   var Event;
//                   _this.totalParticipants = users.length;
//                   Event = _this.resource("/users/:user_id/events/:id.json", {
//                     user_id: _this.sessionID,
//                     id: links[eventLink].event_id
//                   }, {
//                     update: {
//                       method: 'PUT'
//                     }
//                   });
//                   return Event.get(function(thisEvent) {
//                     (function(thisEvent) {})(thisEvent);
//                     return _this.timeout(function() {
//                       var results1, userID;
//                       _this.myEvents.push(thisEvent);
//                       if (thisEvent.match) {
//                         userID = thisEvent.match.length - 2;
//                         results1 = [];
//                         while (userID > -1) {
//                           (function(userID) {
//                             if (+thisEvent.match[userID] === _this.sessionID) {
//                               return _this.myMatch.push(+thisEvent.match[userID + 1], thisEvent.id);
//                             }
//                           })(userID);
//                           results1.push(userID = userID - 2);
//                         }
//                         return results1;
//                       } else {
//                         return _this.myMatch.push(false, thisEvent.id);
//                       }
//                     }, 50);
//                   });
//                 });
//               })();
//             }
//           })(eventLink));
//         }
//         return results;
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.getTags = function() {
//     return this.Profile.get((function(_this) {
//       return function(profile) {
//         return _this.interests = [["Cuisine", profile.cuisine, "cuisine", "Dark Chocolate Ice Cream..."], ["Stores", profile.shops, "shops", "J.C. Penny... Hot Topic..."], ["Services", profile.services, "services", "Barnes & Noble Membership..."], ["Book Genre, Title, or Author", profile.bookGenre, "bookGenre", "J.K. Rowling... Audiobook..."], ["Music Genre, Artist, or Album", profile.musicGenre, "musicGenre", "Green Day... Holiday..."], ["Clothing", profile.clothes, "clothes", "Socks... Tie... Slippers"], ["Animals", profile.animal, "animal", "Blue Jay... Polar Bear..."], ["Color", profile.color, "color", "Green... Silver..."], ["Metal", profile.metal, "metal", "Puter... Titanium..."], ["Element", profile.element, "element", "Tourmaline... Crystal..."], ["Art", profile.art, "art", "Carving... Ceramic..."], ["Hobbies", profile.hobbies, "hobbies", "Sports... Drawing..."]];
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.addTag = function(newTag, catagory, catIndex) {
//     this.interests[catIndex][1].push(newTag);
//     return this.Profile.get((function(_this) {
//       return function(profile) {
//         profile[catagory].push(newTag);
//         profile.$update();
//         return _this.getTags();
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.removeTag = function(tag, catagory, catIndex) {
//     this.interests[catIndex][1].splice(tag, 1);
//     return this.Profile.get((function(_this) {
//       return function(profile) {
//         profile[catagory].splice(tag, 1);
//         return profile.$update();
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.thisMatchProfile = function(eventID) {
//     var MatchProfile, index, results;
//     console.log("thisMatchProfile()");
//     this.matchProfile = [];
//     console.log(this.myMatch);
//     if (this.myMatch) {
//       index = this.myMatch.length - 2;
//       results = [];
//       while (index > -1) {
//         if (this.myMatch[index + 1] === eventID) {
//           if (this.myMatch[index] !== false) {
//             this.gifteePage();
//             MatchProfile = this.resource("users/:user_id/profile.json", {
//               user_id: this.myMatch[index]
//             });
//             MatchProfile.get((function(_this) {
//               return function(profile) {
//                 var Event, MatchName;
//                 _this.matchProfile = profile;
//                 _this.matchInterests = [["Cuisine", profile.cuisine, "cuisine"], ["Stores", profile.shops, "shops"], ["Services", profile.services, "services"], ["Book Genre, Title, or Author", profile.bookGenre, "bookGenre"], ["Music Genre, Artist, or Album", profile.musicGenre, "musicGenre"], ["Clothing", profile.clothes, "clothes"], ["Animals", profile.animal, "animal"], ["Color", profile.color, "color"], ["Metal", profile.metal, "metal"], ["Element", profile.element, "element"], ["Art", profile.art, "art"], ["Hobbies", profile.hobbies, "hobbies"]];
//                 MatchName = _this.resource("/users/:id.json", {
//                   id: profile.user_id
//                 });
//                 MatchName.get(function(profile) {
//                   return _this.matchName = profile.firstname + " " + profile.lastname;
//                 });
//                 Event = _this.resource("/users/:user_id/events/:id.json", {
//                   user_id: _this.sessionID,
//                   id: eventID
//                 });
//                 return Event.get(function(thisEvent) {
//                   _this.eventTitle = thisEvent.eventName;
//                   return _this.eventLimit = thisEvent.spendingLimit;
//                 });
//               };
//             })(this));
//           } else {
//             alert("Sorry, your match isn't ready for this Event.\nTry again later!");
//           }
//         }
//         results.push(index -= 2);
//       }
//       return results;
//     }
//   };

//   GifterCtrl.prototype.thisEventColor = function(match) {
//     if (match) {
//       return "background: -webkit-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* Chrome10+,Safari5.1+ */ background: -moz-linear-gradient(-45deg, #bef0aa 0%, #f0f0f0 48%, #ffffff 65%, #bdf0e1 100%); /* FF3.6+ */ background: -ms-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* IE10+ */ background: -o-linear-gradient(-45deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* Opera 11.10+ */ background: linear-gradient(135deg, #bef0aa 0%,#f0f0f0 48%,#ffffff 65%,#bdf0e1 100%); /* W3C */";
//     }
//     return "background: -moz-linear-gradient(-45deg, #ffc8c8 0%, #f0f0f0 48%, #ffffff 65%, #ffcdff 100%); /* FF3.6+ */ background: -webkit-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* Chrome10+,Safari5.1+ */ background: -o-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* Opera 11.10+ */ background: -ms-linear-gradient(-45deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* IE10+ */ background: linear-gradient(135deg, #ffc8c8 0%,#f0f0f0 48%,#ffffff 65%,#ffcdff 100%); /* W3C */";
//   };

//   GifterCtrl.prototype.findAdminsEvents = function() {
//     var AdminsEvents;
//     AdminsEvents = this.resource("/index_admin_events.json", {}, {
//       'query': {
//         method: 'GET',
//         isArray: true
//       }
//     });
//     return AdminsEvents.query((function(_this) {
//       return function(data) {
//         if (data[0]) {
//           if (data.length > 1) {
//             return _this.chooseEventToEdit(data);
//           } else {
//             return _this.adminPage(data[0]);
//           }
//         } else {
//           alert("You aren't leading any events, yet.\nTry creating one, then invite people to join!");
//           return _this.toggleDropdown = false;
//         }
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.participantsInEvent = function(eventID) {
//     var Event;
//     Event = this.resource("/users/:user_id/events/:id.json", {
//       user_id: this.sessionID,
//       id: eventID
//     });
//     return Event.get((function(_this) {
//       return function(thisEvent) {
//         var UsersInEvents, i, matches, participant;
//         _this.participating = thisEvent.participants;
//         _this.eventLimit = thisEvent.spendingLimit;
//         matches = thisEvent.match;
//         _this.participants = [];
//         participant = [];
//         i = 0;
//         UsersInEvents = _this.resource("/index_participants/:event_id.json", {
//           event_id: eventID
//         }, {
//           'query': {
//             method: 'GET',
//             isArray: true
//           }
//         }
//         });
//         return UsersInEvents.query(function(participants) {
//           var unsignedParticipants;
//           _this.participantNum = participants.length;
//           unsignedParticipants = _this.participating - participants.length;
//           while (i < participants.length) {
//             (function(i) {
//               var User;
//               User = _this.resource("/users/:id.json", {
//                 id: participants[i].user_id
//               });
//               return User.get(function(user) {
//                 var index, name, results;
//                 name = user.firstname + " " + user.lastname;
//                 if (matches) {
//                   _this.matched = true;
//                   index = matches.length - 2;
//                   results = [];
//                   while (index > -1) {
//                     (function(index) {
//                       if (+matches[index] === user.id) {
//                         User = _this.resource("/users/:id.json", {
//                           id: +matches[index + 1]
//                         });
//                         return User.get(function(match) {
//                           var matchName;
//                           matchName = match.firstname + " " + match.lastname;
//                           _this.participants[i] = [];
//                           return _this.participants[i].push(user.id, name, matchName);
//                         });
//                       }
//                     })(index);
//                     results.push(index -= 2);
//                   }
//                   return results;
//                 } else {
//                   _this.matchNow = true;
//                   _this.participants[i] = [];
//                   return _this.participants[i].push(user.id, name, "");
//                 }
//               });
//             })(i);
//             i += 1;
//           }
//           return _this.timeout(function() {
//             var results;
//             if (unsignedParticipants > 0) {
//               results = [];
//               while (i < _this.participating) {
//                 (function(i) {
//                   _this.participants[i] = [];
//                   return _this.participants[i].push(false, ". . .");
//                 })(i);
//                 results.push(i += 1);
//               }
//               return results;
//             }
//           }, 0);
//         });
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.diagnosticParticipantList = function(eventID) {
//     var Event;
//     console.log("DIAGNOSTICS...");
//     this.matched = false;
//     this.matchNow = false;
//     console.log(eventID);
//     Event = this.resource("/users/:user_id/events/:id.json", {
//       user_id: this.sessionID,
//       id: eventID
//     });
//     return Event.get((function(_this) {
//       return function(thisEvent) {
//         var UsersInEvents, i, matches, participant;
//         _this.participating = thisEvent.participants;
//         _this.eventLimit = thisEvent.spendingLimit;
//         matches = thisEvent.match;
//         _this.participants = [];
//         participant = [];
//         i = 0;
//         UsersInEvents = _this.resource("/index_participants/:event_id.json", {
//           event_id: eventID
//         }, {
//           'query': {
//             method: 'GET',
//             isArray: true
//           }
//         });
//         return UsersInEvents.query(function(participants) {
//           var results, unsignedParticipants;
//           _this.participantNum = participants.length;
//           unsignedParticipants = _this.participating - participants.length;
//           results = [];
//           while (i < participants.length) {
//             (function(i) {
//               var User;
//               User = _this.resource("/users/:id.json", {
//                 id: participants[i].user_id
//               });
//               return User.get(function(user) {
//                 var name;
//                 name = user.firstname + " " + user.lastname;
//                 _this.participants[i] = [];
//                 return _this.participants[i].push(user.id, name);
//               });
//             })(i);
//             results.push(i += 1);
//           }
//           return results;
//         });
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.diagnosticRemove = function(user, userID, thisEvent) {
//     var Event, replacement, result;
//     console.log(thisEvent.match);
//     if (thisEvent.match) {
//       result = confirm("Everyone in this Event has been MATCHED. By deleting this participant, are you prepared with a REPLACEMENT for their match?");
//     }
//     if (result) {
//       replacement = prompt("Please enter the ID number of the extra participant who will replace the one you are deleting");
//       (function(_this) {
//         return (function(thisEvent) {
//           var i, results;
//           results = [];
//           for (i in thisEvent.match) {
//             if (+thisEvent.match[i] === userID) {
//               results.push(thisEvent.match.splice(i, 1, replacement));
//             } else {
//               results.push(void 0);
//             }
//           }
//           return results;
//         });
//       })(this)(thisEvent);
//       Event = this.resource("/users/:user_id/events/:id.json", {
//         user_id: this.sessionID,
//         id: thisEvent.id
//       }, {
//         update: {
//           method: 'PUT'
//         }
//       });
//       return Event.get((function(_this) {
//         return function(dbEvent) {
//           var UserInEvent;
//           dbEvent.match = thisEvent.match;
//           dbEvent.$update();
//           console.log("MATCH CHANGED TO:");
//           console.log(dbEvent.match);
//           UserInEvent = _this.resource("/users/:user_id/users_events/:id.json", {
//             user_id: userID,
//             id: thisEvent.id
//           }, {
//             'delete': {
//               method: 'DELETE'
//             }
//           });
//           UserInEvent["delete"]();
//           _this.participants.splice(user, 1);
//           _this.participantNum--;
//           return _this.participating--;
//         };
//       })(this));
//     }
//   };

//   GifterCtrl.prototype.diagnosticsNameChange = function(userID) {
//     var User, newFirstName, result;
//     console.log("Chosen User ID:", userID);
//     result = confirm("Would you like to change this user's first name?");
//     if (result) {
//       newFirstName = prompt("What would you like to change this user's First Name to?");
//       User = this.resource("/users/:id.json", {
//         id: userID
//       }, {
//         update: {
//           method: 'PUT'
//         }
//       });
//       return User.get((function(_this) {
//         return function(user) {
//           user.firstname = newFirstName;
//           console.log("First name changed to:", user.firstname);
//           return user.$update();
//         };
//       })(this));
//     }
//   };

//   GifterCtrl.prototype.removeParticipant = function(user, userID, eventID) {
//     var Event, UserInEvent, result;
//     result = confirm("Are you sure you wish to remove this person from the Event?");
//     if (result) {
//       this.participants.splice(user, 1);
//       this.participantNum--;
//       this.participating--;
//       if (this.sessionID !== 4) {
//         UserInEvent = this.resource("/users/:user_id/users_events/:id.json", {
//           user_id: userID,
//           id: eventID
//         }, {
//           'delete': {
//             method: 'DELETE'
//           }
//         });
//         UserInEvent["delete"]();
//         Event = this.resource("/users/:user_id/events/:id.json", {
//           user_id: this.sessionID,
//           id: eventID
//         }, {
//           update: {
//             method: 'PUT'
//           }
//         });
//         return Event.get((function(_this) {
//           return function(thisEvent) {
//             thisEvent.participants -= 1;
//             return thisEvent.$update();
//           };
//         })(this));
//       }
//     }
//   };

//   GifterCtrl.prototype.increaseParticipants = function(eventID) {
//     var Event, index;
//     index = this.participants.length;
//     this.participants[index] = [];
//     this.participants[index].push(false, ". . .");
//     this.participating++;
//     if (this.sessionID !== 4) {
//       Event = this.resource("/users/:user_id/events/:id.json", {
//         user_id: this.sessionID,
//         id: eventID
//       }, {
//         update: {
//           method: 'PUT'
//         }
//       });
//       return Event.get((function(_this) {
//         return function(thisEvent) {
//           thisEvent.participants += 1;
//           return thisEvent.$update();
//         };
//       })(this));
//     }
//   };

//   GifterCtrl.prototype.decreaseParticipants = function(eventID) {
//     var Event;
//     if (this.participants.length > this.participantNum) {
//       this.participants.splice(-1, 1);
//       this.participating--;
//       if (this.sessionID !== 4) {
//         Event = this.resource("/users/:user_id/events/:id.json", {
//           user_id: this.sessionID,
//           id: eventID
//         }, {
//           update: {
//             method: 'PUT'
//           }
//         });
//         return Event.get((function(_this) {
//           return function(thisEvent) {
//             thisEvent.participants -= 1;
//             return thisEvent.$update();
//           };
//         })(this));
//       }
//     } else {
//       return alert("Use the DELETE BUTTONS next to the name of the person you want to REMOVE from the Event");
//     }
//   };

//   GifterCtrl.prototype.increaseLimit = function(eventID) {
//     var Event;
//     this.eventLimit++;
//     if (this.sessionID !== 4) {
//       Event = this.resource("/users/:user_id/events/:id.json", {
//         user_id: this.sessionID,
//         id: eventID
//       }, {
//         update: {
//           method: 'PUT'
//         }
//       });
//       return Event.get((function(_this) {
//         return function(thisEvent) {
//           thisEvent.spendingLimit += 1;
//           return thisEvent.$update();
//         };
//       })(this));
//     }
//   };

//   GifterCtrl.prototype.decreaseLimit = function(eventID) {
//     var Event;
//     this.eventLimit--;
//     if (this.sessionID !== 4) {
//       Event = this.resource("/users/:user_id/events/:id.json", {
//         user_id: this.sessionID,
//         id: eventID
//       }, {
//         update: {
//           method: 'PUT'
//         }
//       });
//       return Event.get((function(_this) {
//         return function(thisEvent) {
//           thisEvent.spendingLimit -= 1;
//           return thisEvent.$update();
//         };
//       })(this));
//     }
//   };

//   GifterCtrl.prototype.homePage = function() {
//     this.giftee = false;
//     this.admin = false;
//     this.chooseEvent = false;
//     this.createEvent = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.newEventShow = false;
//     this.eventHeadding = false;
//     this.matchNow = false;
//     this.matched = false;
//     this.diagnosticButton = false;
//     this.diagnostics = false;
//     return this.home = true;
//   };

//   GifterCtrl.prototype.gifteePage = function() {
//     this.home = false;
//     this.admin = false;
//     this.chooseEvent = false;
//     this.createEvent = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.matchNow = false;
//     this.matched = false;
//     this.diagnosticButton = false;
//     this.diagnostics = false;
//     this.giftee = true;
//     return this.eventHeadding = true;
//   };

//   GifterCtrl.prototype.chooseEventToEdit = function(events) {
//     this.home = false;
//     this.giftee = false;
//     this.admin = false;
//     this.createEvent = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.newEventShow = false;
//     this.eventHeadding = false;
//     this.matchNow = false;
//     this.matched = false;
//     this.diagnosticButton = false;
//     this.diagnostics = false;
//     this.chooseEvent = true;
//     this.participants = [];
//     this.adminsEvents = [];
//     return this.adminsEvents = events;
//   };

//   GifterCtrl.prototype.adminPage = function(thisEvent) {
//     this.home = false;
//     this.giftee = false;
//     this.chooseEvent = false;
//     this.createEvent = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.diagnostics = false;
//     this.diagnosticButton = this.sessionID === 1 ? true : false;
//     this.admin = true;
//     this.eventHeadding = true;
//     this.eventTitle = thisEvent.eventName;
//     this.eventID = thisEvent.id;
//     this.thisEvent = thisEvent;
//     return this.participantsInEvent(thisEvent.id);
//   };

//   GifterCtrl.prototype.diagnosticsPage = function(thisEvent1) {
//     this.thisEvent = thisEvent1;
//     this.admin = false;
//     this.home = false;
//     this.giftee = false;
//     this.chooseEvent = false;
//     this.createEvent = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.diagnosticButton = false;
//     this.diagnostics = true;
//     this.eventHeadding = true;
//     this.eventTitle = this.thisEvent.eventName;
//     this.eventID = this.thisEvent.id;
//     return this.diagnosticParticipantList(this.thisEvent.id);
//   };

//   GifterCtrl.prototype.joinEventPage = function() {
//     this.home = false;
//     this.giftee = false;
//     this.admin = false;
//     this.chooseEvent = false;
//     this.createEvent = false;
//     this.toggleDropdown = false;
//     this.newEventShow = false;
//     this.eventHeadding = false;
//     this.matchNow = false;
//     this.matched = false;
//     this.diagnosticButton = false;
//     this.diagnostics = false;
//     return this.joinEventVisible = true;
//   };

//   GifterCtrl.prototype.EventCreatePage = function() {
//     this.home = false;
//     this.giftee = false;
//     this.admin = false;
//     this.chooseEvent = false;
//     this.eventHeadding = false;
//     this.joinEventVisible = false;
//     this.toggleDropdown = false;
//     this.eventHeadding = false;
//     this.matchNow = false;
//     this.matched = false;
//     this.diagnosticButton = false;
//     this.diagnostics = false;
//     this.newEventShow = true;
//     return this.createEvent = true;
//   };

//   GifterCtrl.prototype.joinEvent = function() {
//     var Event;
//     console.log("JOIN EVENT...");
//     Event = this.resource("/users/:user_id/events.json", {
//       user_id: this.sessionID
//     }, {
//       'query': {
//         method: 'GET',
//         isArray: true
//       }
//     });
//     return Event.query((function(_this) {
//       return function(data) {
//         var event, eventNameExists, j, len, thisEvent;
//         for (j = 0, len = data.length; j < len; j++) {
//           event = data[j];
//           if (_this.scope.join.eventName === event.eventName) {
//             eventNameExists = true;
//             if (_this.scope.join.password === event.password) {
//               thisEvent = event;
//               Event = _this.resource("/users/:user_id/users_events/:id.json", {
//                 user_id: _this.sessionID,
//                 id: event.id
//               }, {
//                 update: {
//                   method: 'PUT'
//                 }
//               });
//               Event.update(function(data) {
//                 _this.myEvents.push(thisEvent);
//                 _this.myMatch.push(false, thisEvent.id);
//                 return _this.homePage();
//               });
//             } else {
//               alert("Password is incorrect for this Event");
//               _this.scope.join.password = "";
//               return;
//             }
//           }
//         }
//         _this.scope.join.eventName = "";
//         _this.scope.join.password = "";
//         if (!eventNameExists) {
//           alert("We're sorry, but we can't find an Event with that name.\nTry again?");
//           _this.scope.join = "";
//         }
//       };
//     })(this));
//   };

//   GifterCtrl.prototype.createNewEvent = function() {
//     var Event, UserEvents, result;
//     result = confirm("Please make sure you write down this Event name and Password and share it with all participants\nEvent: " + this.scope.newEvent.eventName + "\nPassword: " + this.scope.newEvent.password);
//     if (result) {
//       this.newEventShow = false;
//       Event = this.resource("/users/:user_id/events.json", {
//         user_id: this.sessionID
//       });
//       this.scope.newEvent.admin_id = this.sessionID;
//       this.scope.newEvent.spendingLimit = 5;
//       this.scope.newEvent.participants = 10;
//       Event.save(this.scope.newEvent);
//       this.scope.newEvent = {};
//       this.myEvents = [];
//       this.myMatch.push(false, true);
//       UserEvents = this.resource("/index_user_events/:user_id/events.json", {
//         user_id: this.sessionID
//       }, {
//         'query': {
//           method: 'GET',
//           isArray: true
//         }
//       });
//       UserEvents.query((function(_this) {
//         return function(data) {
//           var j, len, link, results;
//           results = [];
//           for (j = 0, len = data.length; j < len; j++) {
//             link = data[j];
//             Event = _this.resource("/users/:user_id/events/:id.json", {
//               user_id: _this.sessionID,
//               id: link.event_id
//             });
//             results.push(Event.get(function(thisEvent) {
//               return _this.myEvents.push(thisEvent);
//             }));
//           }
//           return results;
//         };
//       })(this));
//       return this.findAdminsEvents();
//     }
//   };

//   GifterCtrl.prototype.logout = function() {
//     this.http.get("/logout.json").success((function(_this) {
//       return function(data) {
//         return location.href = "/";
//       };
//     })(this));
//     this.rootScope.sessionID = null;
//     return console.log("LOGGED OUT!");
//   };

// }]);

// Control.controller("GifterCtrl", ["$scope", "$http", "$resource", "$rootScope", "$location", "$timeout", "Suggestions", GifterCtrl]);
