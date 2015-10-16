#### alternative methods that I've experimented with - maybe faster; but are they clearer? idiomatic? understandable? manageable? etc?

def ppp_v1(value)
  output = ""
  output << 'Pling' if value % 3 == 0
  output << 'Plang' if value % 5 == 0
  output << 'Plong' if value % 7 == 0
  output.empty? ? value : output
end

def ppp_v2(value)
  case
  when value % 3 == 0 && value % 5 == 0 && value % 7 == 0
    'PlingPlangPlong'
  when value % 3 == 0 && value % 5 == 0
    'PlingPlang'
  when value % 3 == 0 && value % 7 == 0
    'PlingPlong'
  when value % 5 == 0 && value % 7 == 0
    'PlangPlong'
  when value % 3 == 0
    'Pling'
  when value % 5 == 0
    'Plang'
  when value % 7 == 0
    'Plong'
  else
    value
  end
end

def ppp_v3(value)
  case
  when plingy?(value) && plangy?(value) && plongy?(value)
    'PlingPlangPlong'
  when plingy?(value) && plangy?(value)
    'PlingPlang'
  when plingy?(value) && plongy?(value)
    'PlingPlong'
  when plangy?(value) && plongy?(value)
    'PlangPlong'
  when plingy?(value)
    'Pling'
  when plangy?(value)
    'Plang'
  when plongy?(value)
    'Plong'
  else
    value
  end
end
def plingy?(value)
  value % 3 == 0
end
def plangy?(value)
  value % 5 == 0
end
def plongy?(value)
  value % 7 == 0
end

## run them all
# [1,2,3].each do |v|
#   puts "\nrunning ppp_v#{v}:"
#   puts (1..105).map { |value| send("ppp_v#{v}",value) }.join(', ')
# end
