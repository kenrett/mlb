require 'rubygems'
require 'pry'
require 'nokogiri'
require 'open-uri'


SCHEDULER.every '5m', :first_in => 0 do
  doc = Nokogiri::HTML(open('http://www.baseball-reference.com'))

  al_standings = []

  s = doc.css('#div_AL_standings').text

  by_division = s.split("SRS")

  al_east = by_division[1].split(" ").each_slice(6).to_a
  # al_cent = by_division[2].split(" ").each_slice(6).to_a
  # al_west = by_division[3].split(" ").each_slice(6).to_a

  al_east.each { |r| r.pop }
  # al_cent.each { |r| r.pop }
  # al_west.each { |r| r.pop }

  al_east.pop
  # al_cent.pop

  al_east_strings = al_east.each { |t| t.to_s }

  # p al_east_strings

  al_divisions = []

  al_divisions = al_east_strings.each { |f| f.delete(f[1]) }
  # al_divisions << al_cent.each { |f| f.delete(f[1]) }
  # al_divisions << al_west.each { |f| f.delete(f[1]) }
  
  al = al_divisions.transpose

  standings = { 
    :teams => al[0],
    :wins => al[1],
    :losses => al[2],
    :gb => al[3]
  }


  # p standings[:teams][0]
  # p standings[:gb][3]

  send_event('mlb', standings)

end