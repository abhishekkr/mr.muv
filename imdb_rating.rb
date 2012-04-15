#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "xml-motor"

module WebHandler
  def self.http_requester(url)
    begin
      uri = URI.parse(url)
      http = Net::HTTP.new uri.host, uri.port
      request = Net::HTTP::Get.new uri.request_uri
      response = http.request(request).body
    rescue
      response = nil
    end
    return response
  end
end

module IMDB
  def self.search(tokens)
    base_url = 'http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q='
    url = "#{base_url}#{tokens.split.join('+')}"
    response = WebHandler.http_requester url
    XMLMotor.get_node_from_content response, 'ImdbEntity', nil, true
  end

  def self.entity_to_arr(imdb_entity)
    splitnodes = XMLMotor.splitter imdb_entity
    name = splitnodes[1][1]
    id = splitnodes[1][0][1]['id'].split(/['|"]/)[1]
    link = "http://www.imdb.com/title/#{id}/"
    [name, link]
  end

  def self.rating(movie_link)
    response = WebHandler.http_requester movie_link
=begin
    tag = 'div'
    attrib = 'class="star-box-giga-star"'
    rated = XMLMotor.get_node_from_content response, tag, attrib
=end
    regexp = '<div class="star-box-giga-star">\s*([0-9]\.[0-9])\s*<\/div>'
    rated = response.scan(/#{regexp}/) unless response.nil?
    [rated].flatten.join.strip
  end
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
