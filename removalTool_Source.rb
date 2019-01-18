# SUNC + DELETE DEF
      #   clearScreen()
      #   printAccInfo()
      #   menuIsShown_RTool = false

      #   puts ("\n>Syncing servers")
      #   syncServers()

      #   puts
      #   puts ("Found " + $SERVER_CTID_ARRAY.length().to_s() + " servers")
      #   puts
      #   puts

      #   puts("Deleting " + $SERVER_CTID_ARRAY.length().to_s() + " servers")
      #   if $SERVER_CTID_ARRAY.length()>0 then
      #     for i in 0...$SERVER_CTID_ARRAY.length() do
      #       deleteServerByCTID($SERVER_CTID_ARRAY[i])
      #     end
      #   end
        
      #   $SERVER_NAMES_ARRAY.clear()
      #   $SERVER_CTID_ARRAY.clear()
      #   puts
      #   puts ("Sync has been reset")
      #   # clearScreen()
      #   # printAccInfo()
      #   menuIsShown_RTool=false
      #   puts



# Remover By CTID
def deleteServerByCTID(ctid)
    puts ("Deleting server (ctid: " + ctid + ")")

    uri = URI.parse("https://api.vscale.io/v1/scalets/" + ctid)
    request = Net::HTTP::Delete.new(uri)
    request.content_type = "application/json;charset=UTF-8"
    request["X-Token"] = TOKEN
    
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    
    case response.code.to_i()
    when 200..299
      puts 'Successful'
    when 400..499
      puts 'ERROR: Can\'t access account/invalid ctid'
    when 500..599
      puts 'ERROR: Vsacle Server is not available'
    else
      puts 'ERROR: Unknown Error'
    end
    
end
  

# Removal Tool Menu
def serverRemovalMenu
    rdyToExit_RTool = false
    menuIsShown_RTool = false
  
  
    while rdyToExit_RTool==false do
  
      if menuIsShown_RTool==false then
        # puts ("---Removal Tool:\n1-By ctid\n2-Sync + Delete All\n3-All \n0-Back")
        puts ("---Removal Tool:\n1-By ctid\n2-All \n0-Back")
        puts
        menuIsShown_RTool = true
      end
      print (">")
      # key = gets()
    
      case gets().chomp()
      when '0'
        rdyToExit_RTool=true
      when '1'
        clearScreen()
        printAccInfo()
        menuIsShown_RTool = false
        puts

        puts("Input server ctid to remove")
        print("ctid: ")
        deleteServerByCTID(gets().chomp())


        puts
        puts
      when '2'
        clearScreen()
        printAccInfo_ZeroCached()
        menuIsShown_RTool = false
        puts
        
        puts("Deleting " + $SERVER_CTID_ARRAY.length().to_s() + " servers")
        puts
        if $SERVER_CTID_ARRAY.length()>0 then
          for i in 0...$SERVER_CTID_ARRAY.length() do
            deleteServerByCTID($SERVER_CTID_ARRAY[i])
          end
        end
        

        $SERVER_NAMES_ARRAY.clear()
        $SERVER_CTID_ARRAY.clear()
        puts
        puts ("Sync has been reset")
        # clearScreen()
        # printAccInfo()
        # menuIsShown_RTool=false
        puts
        puts
      else
        puts 'ERROR: Invalid Input'
      end
      
    end
  
end