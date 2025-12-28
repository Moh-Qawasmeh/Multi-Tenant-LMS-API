
# Clear existing data
puts "Cleaning up database..."
Enrollment.unscoped.destroy_all
Course.unscoped.destroy_all
User.unscoped.destroy_all
School.unscoped.destroy_all

schools_data = [
  { name: 'School One', subdomain: 'school1' },
  { name: 'School Two', subdomain: 'school2' }
]

schools_data.each do |school_attrs|
  Current.school = nil
  puts "Creating #{school_attrs[:name]}..."
  school = School.create!(school_attrs.merge(active: true))
  
  # Set context for scoping
  Current.school = school

  roles = %w[admin instructor user]
  
  roles.each do |role|
    3.times do |i|
      email = "#{role}#{i+1}@#{school.subdomain}.com"
      puts "  Creating #{role}: #{email}"
      school.users.create!(
        email: email,
        password: 'password123',
        name: "#{school.name} #{role.capitalize} #{i+1}",
        role: role,
        active: true
      )
    end
  end

  # Create Courses
  3.times do |i|
    title = "#{school.name} Course #{i+1}"
    puts "  Creating Course: #{title}"
    course = school.courses.create!(
      title: title,
      description: "This is a description for #{title}"
    )
    
    # Enroll some users
    # Enroll the 3 basic users into this course
    users = school.users.where(role: :user)
    users.each do |user|
      puts "    Enrolling #{user.name} in #{title}"
      Enrollment.create!(
        user: user,
        course: course,
        school: school
      )
    end
  end
end

puts "Done!"
puts "Created #{School.count} Schools"
puts "Created #{User.count} Users"
puts "Created #{Course.count} Courses"
puts "Created #{Enrollment.count} Enrollments"
