# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

puts 'Database cleaning...'

User.destroy_all
Category.destroy_all
Booking.destroy_all
Review.destroy_all
Event.destroy_all
puts 'Booking, Event, Category, Review & User destroyed...sic...'
puts 'Loading please wait...'

20.times do
  User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6),
    nickname: Faker::Name.name,
    first_name: Faker::Name.first_name,
    description: Faker::Book.title
  )
end
puts 'Users created'

7.times do
  Category.create!(
    name: Faker::Name.initials
  )
end
puts 'Categories created'

10.times do
  event_loop = Event.create!(
    title: Faker::Movie.title,
    description: Faker::Book.title,
    start_hours: Faker::Time.forward(days: 5, period: :morning, format: :long),
    end_hours: Faker::Time.forward(days: 5, period: :evening, format: :long),
    address: Faker::Address.city,
    slot_number: rand(2..8),
    online: Faker::Boolean.boolean(true_ratio: 0.3),
    user: User.all.sample
  )
  rand(1..3).times do
    Booking.create!(
      event: event_loop,
      status: "pending",
      user: User.all.sample
    )
  end

  rand(1..5).times do
    Review.create!(
      event: event_loop,
      rating: rand(0..5),
      comment: Faker::Book.title,
      user: User.all.sample
    )
  end
end
puts 'Events created'
