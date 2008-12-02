require 'lib/fuzzy_file_finder'
def test(name, q1, q2)
  f = FuzzyFileFinder.new
  s1 = f.score_for_name_and_query(name, q1)
  s2 = f.score_for_name_and_query(name, q2)
  if s1 > s2
    $score += 1
  else
    $failures += 1
    puts %Q!For name #{name} expected "#{q1}" with score #{s1.to_s[0,5]} to be higher than "#{q2}" with score #{s2.to_s[0,5]}!
  end
end

$score = $failures = 0

test *%w(public_controller pr ur) # start of word counts double
test *%w(public_controller pco uco) # start of word counts double
test *%w(public_controller puco pucn) # minimize # runs
test *%w(publique_controller pc po) # match after word break counts more
test *%w(public_controller pc po) # match after word break counts more

puts "#{$score + $failures} tests, #{$failures} failures."