require 'pry-byebug'
require 'benchmark'

require_relative 'mgp'
require_relative 'mgp_fast'
require_relative 'mgp_oo'
require_relative 'mgp_prototypes'


@cache = ""

def instructors
  if @cache.empty?
    array = []
    (1..105).each do |number|
      string = ""
      string += "Pling" if number % 3 == 0
      string += "Plang" if number % 5 == 0
      string += "Plong" if number % 7 == 0
      string = number if string.empty?
      array.push(string)
    end
    @cache = array.join(',')
  end

  @cache
end



def chae
  def ppp(n)
    answer = ''

    if n % 3 == 0
      answer << 'Pling'
    end

    if n % 5 == 0
      answer << 'Plang'
    end

    if n % 7 == 0
      answer << 'Plong'
    end

    if answer == ''
      answer = n.to_s
    end

    answer
  end

  (1..104).each { |n|  ppp(n) << ', ' }
  ppp(105)
end



def craig
  require 'prime'
  (1..105).each do |num|
    pn = num.prime_division

    str = ""
    if pn.flatten.include? 3
      str += "Pling"
    end
    if pn.flatten.include? 5
      str += "Plang"
    end
    if pn.flatten.include? 7
      str += "Plong"
    end
    if str.length == 0
      str = num
    end
    str
  end
end



def kieran
  def divisible_by(prime,i)
    (i/prime.to_f).to_i == i/prime.to_f
  end

  1.upto(105) do |i|
    three = divisible_by(3, i)
    five = divisible_by(5,i)
    seven = divisible_by(7,i)
    unless three || five || seven
     i
   else
     "#{'pling' if three}#{'plang' if five}#{'plong' if seven}, "
   end
 end

end

# instructors
# exit



Benchmark.bmbm do |b|

  b.report("MGP's code") do
    10000.times do
      do_the_pling_plang
    end
  end

  b.report("Kieran's code") do
    10000.times do
      kieran
    end
  end

  b.report("Craig's code") do
    10000.times do
      craig
    end
  end

  b.report("Chae's code") do
    10000.times do
      chae
    end
  end

  b.report("Instructors' code") do
    10000.times do
      instructors
    end
  end

  b.report("MGP's cacheing") do
    10000.times do
      mgp_super_fast
    end
  end

  b.report("Object Orientation") do
    10000.times do
      mgp_oo
    end
  end

  [1,2,3].each do |v|
    b.report("MGP's prototypes: v#{v}") do
      10000.times do
        (1..105).map { |value| send("ppp_v#{v}",value) }.join(', ')
      end
    end
  end

end





