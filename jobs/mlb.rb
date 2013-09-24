require 'rubygems'
require 'nokogiri'
require 'open-uri'


SCHEDULER.every '5m', :first_in => 0 do
  doc = Nokogiri::HTML(open('http://www.baseball-reference.com'))

  al_standings = []

  al = doc.css('#div_AL_standings').text
  nl = doc.css('#div_NL_standings').text

  by_division = al.split("SRS")
  by_division << nl.split("SRS")

  # Uncomment the division you want to see.
  # At this time you can only view 1 division at a time.

# # AL EAST  
#   al_east = by_division[1].split(" ").each_slice(6).to_a
#   al_east.each { |r| r.pop }
#   al_east.pop
#   div_strings = al_east.each { |t| t.to_s }
# # AL CENTRAL
#   al_cent = by_division[2].split(" ").each_slice(6).to_a
#   al_cent.each { |r| r.pop }
#   al_cent.pop
#   div_strings = al_cent.each { |t| t.to_s }
# AL WEST
  al_west = by_division[3].split(" ").each_slice(6).to_a
  al_west.each { |r| r.pop }
  # west does not need an extra pop...
  div_strings = al_west.each { |t| t.to_s }

# # NL EAST
#   nl_east = by_division[4].split(" ").each_slice(6).to_a
#   nl_east.each { |r| r.pop }
#   nl_east.pop
#   div_strings = nl_east.each { |t| t.to_s }
# # NL CENTRAL
#   nl_cent = by_division[5].split(" ").each_slice(6).to_a
#   nl_cent.each { |r| r.pop }
#   nl_cent.pop
#   div_strings = nl_cent.each { |t| t.to_s }
# # NL WEST
#   nl_west = by_division[6].split(" ").each_slice(6).to_a
#   nl_west.each { |r| r.pop }
#   div_strings = nl_west.each { |t| t.to_s }

  divisions = []
  divisions = div_strings.each { |f| f.delete(f[1]) }
  team = divisions.transpose

  standings = { 
    :teams => team[0],
    :wins => team[1],
    :losses => team[2],
    :gb => team[3]
  }

  send_event('mlb', standings)
end