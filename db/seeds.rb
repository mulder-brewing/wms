Company.create!(name: 'Mulder WMS Admin')
User.create!(company: Company.find_by(name: 'Mulder WMS Admin'), first_name: 'Ryan', last_name: 'Mulder', username: 'admin', password: 'Password1$', company_admin: true, app_admin: true, current_user: "seed" )

# load environment specific seeds
load(Rails.root.join( 'db', 'seeds', "#{Rails.env.downcase}.rb"))
