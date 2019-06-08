1000.times do |n|
  name  = Faker::Company.unique.name
  Company.create!(name:  name)
end
