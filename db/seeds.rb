# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


clark = User.create({firstname: "Clark", lastname: "Kent", email: "superman@dailyplanet.com", password: "1234", zip: 11238, purchase: "", personality: ""})
lois = User.create({firstname: "Lois", lastname: "Lane", email: "lois@dailyplanet.com", password: "1234", zip: 11371, purchase: "", personality: ""})
jimmy = User.create({firstname: "Jimmy", lastname: "Olsen", email: "jimmy@dailyplanet.com", password: "1234", zip: 11432, purchase: "", personality: ""})
perry = User.create({firstname: "Perry", lastname: "White", email: "perry@dailyplanet.com", password: "1234", zip: 11422, purchase: "", personality: ""})
lana = User.create({firstname: "Lana", lastname: "Lang", email: "lana@smallville.com", password: "1234", zip: 67068, purchase: "", personality: ""})
lex = User.create({firstname: "Lex", lastname: "Luthor", email: "lex@metropolis.com", password: "1234", zip: 11230, purchase: "", personality: ""})

han = User.create({firstname: "Han", lastname: "Solo", email: "han@tatooine.com", password: "1234", zip: 85282, purchase: "", personality: ""})
chew = User.create({firstname: "Chewbaca", lastname: "Solo", email: "chewie@tatooine.com", password: "1234", zip: 85282, purchase: "", personality: ""})
ben = User.create({firstname: "Ben", lastname: "Kenobi", email: "ben@tatooine.com", password: "1234", zip: 85255, purchase: "", personality: ""})
luke = User.create({firstname: "Luke", lastname: "Skywalker", email: "luke@tatooine.com", password: "1234", zip: 85024, purchase: "", personality: ""})
leia = User.create({firstname: "Leia", lastname: "Organa", email: "leia@alderaan.com", password: "1234", zip: 85282, purchase: "", personality: ""})
darth = User.create({firstname: "Darth", lastname: "Vader", email: "darth@deathstar.com", password: "1234", zip: 60606, purchase: "", personality: ""})

dailyplanet = Event.create ({eventName: "Daily Planet Gift Exchange", password: "1234", admin_id: 4, participants: "", spendingLimit: 25, match: "{'1':'2','2':'3','3':'4','4':'5','5':'6','6':'1'}"})
starwars = Event.create ({eventName: "Death Star X-mas Party", password: "1234", admin_id: 12, participants: "", spendingLimit: 50, match: "{'7':'8','8':'9','9':'10','10':'11','11':'12','12':'7'}"})


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





