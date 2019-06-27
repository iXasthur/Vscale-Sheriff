

# Clear Terminal
def clearScreen
  system 'clear' or system 'cls'
  puts
  puts '---VscaleServerManager v2'
end


# Output Main Info
def printAccInfo
  puts('AppFolder: ' + PROGRAM_FOLDER_PATH)
  puts('Token: ' + TOKEN)
  puts('E-mail: ' + $email)
  puts('Cached servers: ' + $SERVER_CTID_ARRAY.length().to_s())
end

def printAccInfo_ZeroCached
  puts('AppFolder: ' + PROGRAM_FOLDER_PATH)
  puts('Token: ' + TOKEN)
  puts('E-mail: ' + $email)
  puts('Cached servers: ' + $SERVER_CTID_ARRAY.length.to_s + '->0')
end


# Loads Acc Info From Server +
def getInfo
    clearScreen()
    getAccInfo()
    printAccInfo()
    puts
end


# Reads Info From Response
def findAccInfo(str)

  if str.index("\"email\"")!=nil then
    i = str.index("\"email\"") + "\"email\"".length + 2

    while str[i]!='"' do
      $email+=str[i]
      i+=1
    end

  end

end


def getAccInfo(token)
  uri = URI.parse("https://api.vscale.io/v1/account")
  request = Net::HTTP::Get.new(uri)
  request['X-Token'] = token

  req_options = {
    use_ssl: uri.scheme == 'https',
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end



  case response.code.to_i
  when 200..299
    findAccInfo(response.body)
  when 400..499
    puts 'ERROR: Can\'t access account'
  when 500..599
    puts 'ERROR: Vsacle Server is not available'
  else
    puts 'ERROR: Unknown Error'
  end


end