def menu
  # Clear the screen, and present the user with a menu
  puts `clear`
  puts "*** Calc-U-L8R ***"
  puts "Please choose whether to keep it simple, or push the boundaries"
  print "(b)asic, (a)dvanced, or (q)uit: "
  get_string
end


def basic_calc
  # ask the user which operation they want to perform
  puts "Good choice - which simple operation do you want to perform"
  print "(a)dd, (s)ubtract, (m)ultiply, (d)ivide: "
  operation = get_string

  print "first number: "
  a = get_float

  print "second number: "
  b = get_float

  case operation
  when 'a'
    puts a + b
  when 's'
    puts a - b
  when 'm'
    puts a * b
  when 'd'
    puts a / b
  end
end


def advanced_calc
  puts "Going advanced? Which head-scratcher do you want to perform"
  print "(p)ower, (s)qrt: "
  operation = get_string

  print "first number: "
  a = get_float

  if operation == 's'
    puts Math.sqrt(a)
  else
    print "second number: "
    b = get_float
    puts a ** b
  end
end


def pause
  puts "press enter to continue"
  gets
end


def get_string
  gets.chomp.downcase
end


def get_float
  gets.to_f
end


# run the app...

response = menu

until response == 'q'
  case response
  when 'b'
    basic_calc
  when 'a'
    advanced_calc
  end

  pause

  response = menu
end
