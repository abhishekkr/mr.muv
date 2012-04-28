#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "xml-motor"

Dir.glob(File.join File.dirname(__FILE__), 'lib', '*.rb').each do |librb|
  require librb
end

module IMDBRating
  def self.movie(movie_name, out=true)
    entries = IMDB.search movie_name.split(/[\[|\(]/)[0]
    return [movie_name, "No Results Found."] if entries.nil? or entries.empty?
    nl = IMDB.entity_to_arr(entries.first)
    nl_name = nl.first
    nl_link = nl.last
    rating = IMDB.rating nl_link
    rating = rating.empty? ? 'Error' : "#{rating}/10"
    return [nl, rating].flatten unless out
    puts nl_name, "#{rating}", "#{nl_link}"
  end

  def self.movie_dir(dir_name)
    movies = Dir.glob(File.join dir_name, '*')
    movies.each do |movie_name|
      record = movie File.basename(movie_name), false
      puts "Looking for: #{File.basename movie_name}"
      puts "Found: #{record.first}"
      puts "#{record.last}", "#{record[1]}", "_"*10
    end
  end
end
