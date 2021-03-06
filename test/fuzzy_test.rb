require 'lib/fuzzy_file_finder'
def ntest(name1, name2, q)
  f = FuzzyFileFinder.new
  s1 = f.score_for_name_and_query(name1, q)
  s2 = f.score_for_name_and_query(name2, q)
  if s1 > s2
    $score += 1
  else
    $failures += 1
    puts %Q!For #{q} expected "#{name1}" with score #{s1.to_s[0,5]} to score higher than "#{name2}" with score #{s2.to_s[0,5]}!
  end
end

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
ntest *%w(public_controller production puco) # less runs in *much* better
ntest *%w(star.clj star.png st) # penalty for binaries
ntest *%w(boot.rb box.png bo) # penalty for binaries

puts "#{$score + $failures} tests, #{$failures} failures."
