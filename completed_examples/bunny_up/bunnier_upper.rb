students = %w(Iwona Craig GraemeK Kathryn Kieran Peter Ere Chae Zsolt Simon Syed Neil GraemeS Keith Nevin)

students = students.shuffle

puts `clear`
puts "*** Bunny Up! ***"
print "How big do you want the groups to be? "

group_size = gets.to_i
number_of_groups = students.size / group_size

groups = number_of_groups.times.map { [] }

puts `clear`

(0...(number_of_groups * group_size)).each do |index|
  groups[index % number_of_groups] << students.pop
end

if students.any?
  puts "There are #{students.size} students left over after the groups of #{group_size} have been created."
  puts "Do you want them (s)pread out, or create a (n)ew group for them?"
  if gets.chomp.downcase == 's'
    students.each_with_index do |student, index|
      groups[index % number_of_groups] << student
    end
  else
    groups << students
  end
end

groups.each_with_index do |group, index|
  puts "Group #{index + 1}: #{group.join(', ')}"
end

puts
