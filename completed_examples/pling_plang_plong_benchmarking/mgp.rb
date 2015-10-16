def pling_plang_or_plong(value)
  plingplangplong = {
    3 => 'Pling', 
    5 => 'Plang',
    7 => 'Plong',
    }.map do |factor, noise|
      noise if value % factor == 0
    end
  plingplangplong.any? ? plingplangplong.join : value.to_s
end

def do_the_pling_plang
  (1..105).map do |value|
    pling_plang_or_plong(value)
  end
end
