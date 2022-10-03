# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


10.times do
    host = User.create!(
      email: Faker::Internet.email,
      password: Faker::Internet.password
    )
  
    10.times do
      listing = Listing.create(
        host: host,
        title: Faker::Lorem.words.join(" "),
        about: Faker::Lorem.paragraphs.join("\n"),
        max_guests: (1...15).to_a.sample,
        address_line1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        country: 'US',
        status: [:draft, :published].sample,
      )
    end
  end