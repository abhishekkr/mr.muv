# all imdb bases belong here

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
