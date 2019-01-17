

# Remover By CTID
def deleteServerByCTID(ctid)
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
  
    #####ADD ERROR HANDLER
end
  

# Removal Tool Menu
def serverRemovalMenu
    rdyToExit_RTool = false
    menuIsShown_RTool = false
  
  
    while rdyToExit_RTool==false do
  
      if menuIsShown_RTool==false then
        puts ("---Removal Tool:\n1-By ctid + show list\n2-By range + show list\n3-All \n0-Back")
        puts
        menuIsShown_RTool = true
      end
      print (">")
      # key = gets()
    
      case gets().chomp()
      when '0'
        rdyToExit_RTool=true
      when '1'
        print("ctid: ")
        deleteServerByCTID(gets().chomp())
        clearScreen()
        printAccInfo()
        menuIsShown_RTool=false
        puts
      when '2'
        puts ("Not available")
      when '3'
        puts("Deleting " + $SERVER_CTID_ARRAY.length().to_s() + " servers")
        if $SERVER_CTID_ARRAY.length()>0 then
          for i in 0...$SERVER_CTID_ARRAY.length() do
            deleteServerByCTID($SERVER_CTID_ARRAY[i])
          end
        end
        syncServers()
        clearScreen()
        printAccInfo()
        menuIsShown_RTool=false
        puts
      else
        puts 'ERROR: Invalid Input'
      end
      
    end
  
end