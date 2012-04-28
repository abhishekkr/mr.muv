# All HTTP Calls finally handled in here

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
