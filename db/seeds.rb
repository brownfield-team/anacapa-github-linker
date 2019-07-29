# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'securerandom'

case Rails.env
when "development"
  # Can be used to test pagination
  # users = [
  #   [ "Fake  1 User", "fakeuser01" ],
  #   [ "Fake  2 User", "fakeuser02" ],
  #   [ "Fake  3 User", "fakeuser03" ],
  #   [ "Fake  4 User", "fakeuser04" ],
  #   [ "Fake  5 User", "fakeuser05" ],
  #   [ "Fake  6 User", "fakeuser06" ],
  #   [ "Fake  7 User", "fakeuser07" ],
  #   [ "Fake  8 User", "fakeuser08" ],
  #   [ "Fake  9 User", "fakeuser09" ],
  #   [ "Fake 10 User", "fakeuser10" ]
  # ]
  users.each do |name, username|
    User.create!( name: name, username: username, email: "#{username}@example.org", password: SecureRandom.alphanumeric )
  end
when "production"

when "test"

end
