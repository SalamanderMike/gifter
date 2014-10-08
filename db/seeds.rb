# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: "Chicago" }, { name: "Copenhagen" }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# USERS
clark = User.create({firstname: "Clark", lastname: "Kent", email: "superman@dailyplanet.com", password: "1234"})
lois = User.create({firstname: "Lois", lastname: "Lane", email: "lois@dailyplanet.com", password: "1234"})
jimmy = User.create({firstname: "Jimmy", lastname: "Olsen", email: "jimmy@dailyplanet.com", password: "1234"})
perry = User.create({firstname: "Perry", lastname: "White", email: "perry@dailyplanet.com", password: "1234"})
lana = User.create({firstname: "Lana", lastname: "Lang", email: "lana@smallville.com", password: "1234"})
lex = User.create({firstname: "Lex", lastname: "Luthor", email: "lex@metropolis.com", password: "1234"})

han = User.create({firstname: "Han", lastname: "Solo", email: "han@tatooine.com", password: "1234"})
chew = User.create({firstname: "Chewbaca", lastname: "Solo", email: "chewie@tatooine.com", password: "1234"})
ben = User.create({firstname: "Ben", lastname: "Kenobi", email: "ben@tatooine.com", password: "1234"})
luke = User.create({firstname: "Luke", lastname: "Skywalker", email: "luke@tatooine.com", password: "1234"})
leia = User.create({firstname: "Leia", lastname: "Organa", email: "leia@alderaan.com", password: "1234"})
darth = User.create({firstname: "Darth", lastname: "Vader", email: "darth@deathstar.com", password: "1234"})

# PROFILES
clarkProfile = Profile.create({zip: 11238, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
loisProfile = Profile.create({zip: 11371, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
jimmyProfile = Profile.create({zip: 11432, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
perryProfile = Profile.create({zip: 11422, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
lanaProfile = Profile.create({zip: 67068, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
lexProfile = Profile.create({zip: 11230, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})

hanProfile = Profile.create({zip: 85282, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
chewProfile = Profile.create({zip: 85282, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
benProfile = Profile.create({zip: 85255, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
lukeProfile = Profile.create({zip: 85024, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
leiaProfile = Profile.create({zip: 85282, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})
darthProfile = Profile.create({zip: 60606, cuisine: ["Wine", "Cookies", "Cheese"], shops: ["iTunes", "Best Buy", "Bed Bath & Beyond"], services: ["Spotify", "Pandora", "Dropbox"], bookGenre: ["Sci-fi", "Romance", "Mystery"], musicGenre: ["Indie", "Classical", "Pop"], clothes: ["Shirt", "Tie", "Scarf"], color: ["blue"], animal: ["Wolf", "Cat", "Girraffe"], metal: ["silver", "gold"], element: ["Wood", "Stone", "Glass"], art: ["Imports", "Photography", "Figurines"], hobbies: ["Reading", "Cooking", "Movies"]})

# ATTACH PROFILES TO USERS
clark.profile = clarkProfile
lois.profile = loisProfile
jimmy.profile = jimmyProfile
perry.profile = perryProfile
lana.profile = lanaProfile
lex.profile = lexProfile

han.profile = hanProfile
chew.profile = chewProfile
ben.profile = benProfile
luke.profile = lukeProfile
leia.profile = leiaProfile
darth.profile = darthProfile

# EVENTS
dailyplanet = Event.create ({eventName: "Daily Planet Gift Exchange", password: "1234", admin_id: 4, participants: [], spendingLimit: 25, match: [[1,2],[2,3],[3,4],[4,5],[5,6],[6,12],[12,1]]})
starwars = Event.create ({eventName: "Death Star X-mas Party", password: "1234", admin_id: 12, participants: [], spendingLimit: 50, match: [[7,8],[8,9],[9,10],[10,11],[11,12], [12,7]]})


# ATTACH USERS AND EVENTS TOGETHER
clark.events << dailyplanet
lois.events << dailyplanet
jimmy.events << dailyplanet
perry.events << dailyplanet
lana.events << dailyplanet
lex.events << dailyplanet

han.events << starwars
chew.events << starwars
ben.events << starwars
luke.events << starwars
leia.events << starwars
darth.events << starwars
darth.events << dailyplanet





