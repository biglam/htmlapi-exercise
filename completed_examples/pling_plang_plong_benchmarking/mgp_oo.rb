class PlingPlangPlong
  # does exactly the same as the imperative method, but also merges the 'caching' approach to memoize on a class level

  @@memo = {}

  class << self
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

    def calc(value)
      @@memo[value] || (@@memo[value] = pling_plang_or_plong(value))
    end

  end
end


def mgp_oo
  (1..105).map do |i|
    PlingPlangPlong.calc(i)
  end
end

