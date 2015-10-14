# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(name:  "Example",
             surname: "User",
             email: "example@railstutorial.org",
             phone: "+48665273066",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Non",
             surname: "Admin",
             email: "nonadmin@railstutorial.org",
             phone: "+48666656565",
             password:              "foobar",
             password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  full_name_array = Faker::Name.name.split(" ")
  name = full_name_array[0]
  surname = full_name_array[1]
  phone = "#{rand(100000000..999999999)}"
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!( name: name,
                surname: surname,
                email: email, 
                phone: phone,
                password:              password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

# Fake few reservations (not ovaerlaping yet - feature not implemented)
Reservation.create!(name: "Michael",
                    surname: "Example",
                    email: "michael@example.com",
                    phone: "+48665273066",
                    room: '1',
                    confirmation: false,
                    checkin: Time.zone.now.midday.advance(months: 6),
                    checkout: Time.zone.now.midday.advance(months: 6, days: 10))

Reservation.create(name: "Michael",
                    surname: "Example",
                    email: "michael_3@example.com",
                    phone: "+48665273066",
                    room: '1',
                    confirmation: false,
                    checkin: Time.zone.now.midday.advance(months: 5, days: 1),
                    checkout: Time.zone.now.midday.advance(months: 6, days: 8)).valid?
=begin
Reservation.new(name: 'Michael',
                surname: 'Example',
                email: 'michael_1@example.com',
                phone: '+48665273066',
                room: '1',
                confirmation: false,
                 checkin: Time.zone.now.midday.advance(months: 6, days: 11),
                 checkout: Time.zone.now.midday.advance(months: 6, days: 14))
=end        