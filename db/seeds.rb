Company.create!(name: 'Mulder Software')

User.create!(company: Company.find_by(name: 'Mulder Software'), first_name: 'Ryan', last_name: 'Mulder', username: 'admin', password: 'Password1$', company_admin: true, app_admin: true, current_user: "seed" )

1000.times do |n|
  name  = Faker::Company.unique.name
  Company.create!(name:  name)
end
