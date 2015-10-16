@mgp_pling = []
(1..105).each do |i|
  @mgp_pling[i] = pling_plang_or_plong(i)
end

def mgp_super_fast
  (1..105).map do |i|
    @mgp_pling[i]
  end
end
