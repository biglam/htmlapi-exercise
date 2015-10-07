require 'date'

def menu
  # Clear the screen, and present the user with a menu
  puts `clear`
  puts "*** Calc-U-L8R ***"
  puts "Please choose whether to keep it simple, or push the boundaries"
  print "(b)asic, (a)dvanced, a(g)e, (s)leeps to Christmas, (m)easurement conversion, (v)olume or (q)uit: "
  get_string
end


def basic_calc
  # ask the user which operation they want to perform
  puts `clear`
  puts "Good choice - which simple operation do you want to perform?"
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
  puts `clear`
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


def age_calc
  puts `clear`
  puts "Enter birth date in the following format - 'YYYY-MM-DD':"
  dob = get_date
  today = Date.today

  puts case
  when dob > today
    "That date is in the future, so not much use for calculating age from..."
  else
    age = today.year - dob.year - ((today.month > dob.month || (today.month == dob.month && today.day >= dob.day)) ? 0 : 1)

    case age
    when 0
      "Not even one-year-old yet"
    when 1..99
      "If that was your birthday, you would be #{age} year#{'s' if age > 1} old now."
    else
      "If that was your birthday, you would be #{age} years old now. And looking pretty good on it!"
    end
  end
end


def sleeps_calc
  puts `clear`
  today = Date.today

  # Uncomment for testing purposes to get a fake 'today'
  # today = (Date.new(today.year, 1, 1).. Date.new(today.year, 12, 31)).to_a.sample

  christmas = Date.new(today.year, 12, 25)
  sleeps = (christmas - today).to_i

  puts case sleeps.to_i
  when 0
    "OMG! Check your stockings! Santa's been!!"
  when 1..10
    "Only #{sleeps} sleep#{'s' unless sleeps == 1} to go. It's getting close!"
  when 11..24
    "The advent calendar is getting a workout with only #{sleeps} sleeps to go."
  when 25..54
    "#{sleeps} sleeps until Christmas. Better get the cards for Australian friends written."
  when 55..100
    "#{sleeps} sleeps. Check back soon."
  when 101..250
    "You're too keen. I feel almost mean telling you there's #{sleeps} sleeps still left."
  when 251..366
    "It's hardly even Easter! There still #{sleeps} sleeps until Christmas."
  else
    "Oh noes! You missed it! Gotta wait until next year now :-("
  end
end


def measurement_calc
  puts `clear`
  puts "Oooo! Getting complicated! Which conversion do you want to do?"
  puts "(m)iles to kilometers, (f)eet to meters, (i)nches to centimeters, or"
  print "(k)ilometers to miles, m(e)ters to feet, (c)entimeters to inches: "
  conversion = get_string

  print "What number to convert: "
  a = get_float

  result = a * case conversion
  when 'm'
    1.6093
  when 'f'
    0.3048
  when 'i'
    2.54
  when 'k'
    0.6214
  when 'e'
    3.2808
  when 'c'
    0.3937
  end

  puts "That's #{result} in new money."
end


def volume_calc
  puts `clear`
  puts "Really? Just let me get my slide-rule... okay, what shape do you have?"
  print "(c)ube, (s)phere: "

  shape = get_string

  case shape
  when 'c'
    print "What's the length of its sides? "
    number = get_float
    result = number ** 3
  when 's'
    print "What's its radius? "
    number = get_float
    result = (4.0 / 3.0) * Math::PI * (number ** 3)
  end

  puts "Okay, Archimedes, that's #{result}."
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


def get_date
  Date.parse(gets.chomp)
end


# run the app...

response = menu

until response == 'q'
  case response
  when 'b'
    basic_calc
  when 'a'
    advanced_calc
  when 'g'
    age_calc
  when 's'
    sleeps_calc
  when 'm'
    measurement_calc
  when 'v'
    volume_calc
  end

  pause

  response = menu
end


