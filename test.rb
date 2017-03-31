string = "[1;31mjava.lang.RuntimeException[m: [3mToo "

puts string
puts string.gsub(/\033\[(([0-9]?)\;?)+m/, '')
# puts string.gsub(/\033.*m/, '')
