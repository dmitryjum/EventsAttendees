# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
event1 = Event.new(name: "Rock Band festival", start_time: Time.zone.now + 3.days, end_time: Time.zone.now + 10.days,
                   description: "Just some randome rock band playing", event_type: "in_person")
event1.save!
event2 = Event.new(name: "Conference", start_time: Time.zone.now + 3.days, end_time: Time.zone.now + 10.days,
                   description: "conversations and relaxations", event_type: "virtual")
event2.save!
event1.attendees.create(name: "Vincent Descols", email: "vince@testmail.com", rsvp_status: "yes")
event2.attendees.create(name: "Lance Wright", email: "vince@testmail.com")
