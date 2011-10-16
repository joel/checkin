def token(range=(1..8))
  chars = ["a".."z","0".."9"].collect { |r| Array(r) }.join
  range.collect { chars[rand(chars.size)] }.join
end

def token_num(range=(1..8))
  chars = ["0".."9"].collect { |r| Array(r) }.join
  range.collect { chars[rand(chars.size)] }.join
end

def token_alpha(range=(1..8))
  chars = ["a".."z"].collect { |r| Array(r) }.join
  range.collect { chars[rand(chars.size)] }.join
end

def random(range)
  range.to_a[rand(range.to_a.length)]
end

Factory.sequence(:provider) { |n| token(1..3) }  
Factory.sequence(:uid) { |n| token(1..3) }  
