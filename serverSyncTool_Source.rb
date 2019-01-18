

# Creates Array Of Available Servers
def getServerList(str)
    # puts str
    # puts
  
    $SERVER_NAMES_ARRAY.clear()
    $SERVER_CTID_ARRAY.clear()
  
    # puts str.index("\"name\"")
    buffName = ""
    buffCTID = ""
  
  
    while str.index("\"name\"")!=nil do
      i = str.index("\"name\"") + "\"name\"".length + 3
  
      while str[i]!='"' do
        buffName << str[i]
        i+=1
      end
      str[str.index("\"name\"")+1] = ""
  
      if str.index("\"ctid\"")!=nil then
        i = str.index("\"ctid\"") + "\"ctid\"".length + 2
    
        while str[i]!='}' do
          buffCTID << str[i]
          i+=1
        end
        str[str.index("\"ctid\"")+1] = ""
  
        $SERVER_NAMES_ARRAY << buffName
        $SERVER_CTID_ARRAY << buffCTID
  
        buffName = ""
        buffCTID = ""
      end
  
  
      # puts buffName
      # puts buffCTID
  
    end
  
    
end
  
  
# Server Sync Begin
def syncServers
      uri = URI.parse("https://api.vscale.io/v1/scalets")
      request = Net::HTTP::Get.new(uri)
      request["X-Token"] = TOKEN
      
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
    
  
      case response.code.to_i()
      when 200..299
        getServerList(response.body)
        puts (">Sync has been completed")
      when 400..499
        puts 'ERROR: Can\'t access account'
      when 500..599
        puts 'ERROR: Vsacle Server is not available'
      else
        puts 'ERROR: Unknown Error'
      end
end