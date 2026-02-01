puts "Seeding demo user"

user = User.find_or_create_by!(email: "test_user@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

puts "Seeding demo user completed"

puts "Seeding demo study logs"

Topic.limit(10).each do |topic|
  log = StudyLog.find_or_initialize_by(user: user, topic: topic)
  log.understanding_level = "not_understood"
  log.study_on = Date.today
  log.save!
end

puts "Seeding demo study logs completed"
