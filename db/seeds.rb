# db/seeds.rb
# 1. Clean the database 🗑️
puts "Cleaning database..."

# User
User.destroy_all
User.create!(email: "kaleb@gmail.com", password: "123456")

# Company
Company.destroy_all
Company.create!(name: "Kaleb's Company")

# Role
Role.destroy_all
Role.create!(description: "administrator")
Role.create!(description: "employer")
Role.create!(description: "shatcho")


# Profile
Profile.destroy_all
Profile.create!(name: "Kaleb Fukuda",
    salary: 15000,
    can_drive: true,
    role: Role.first,
    company: Company.first,
    user: User.first)

# Gemba
Gemba.destroy_all
Gemba.create!(name: "La Shuura - Kaleb's Company", code: "LS001", company: Company.first)

# Period
Period.destroy_all
Period.create!(description: "Manhã")
Period.create!(description: "Noite")

Register.destroy_all
Register.create!(date: Date.yesterday,
  extra_hour: 1.5,
  extra_cost: 1500,
  gemba: Gemba.first,
  profile: Profile.first,
  period: Period.first)

    puts "Creating gemba..."

puts "Finished!"
