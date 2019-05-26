Company.create!(name: 'Mulder Software')

User.create!(company: Company.find_by(name: 'Mulder Software'), first_name: 'Ryan', last_name: 'Mulder', username: 'admin', password: 'password', company_admin: true, app_admin: true )

1000.times do |n|
  name  = Faker::Company.unique.name
  Company.create!(name:  name)
end
