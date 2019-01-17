require 'net/http'
require 'uri'
require 'json'


TOKEN_LINE_IN_FILE = 1
PROGRAM_FOLDER_PATH = Dir.pwd
# puts (Dir.entries(PROGRAM_FOLDER_PATH))

ACC_FILE = "AccountPreferences.txt"
TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp
$EMAIL = ""

rdyToExit = false
menuIsShown = false

DEBUG_SERVER_LIST = ""

$SERVER_NAMES_ARRAY = Array.new()
$SERVER_CTID_ARRAY = Array.new()





def clearScreen
  system "clear" or system "cls"
  puts  

  puts '---VscaleServerManager v1'
end


def printAccInfo
    puts ('AppFolder: ' + PROGRAM_FOLDER_PATH)
    puts ('Token: ' + TOKEN)
    puts ('E-mail: ' + $EMAIL)
end


def getInfo
    clearScreen()
    getAccInfo()
    printAccInfo()
    puts
end


def findAccInfo(str)

  if str.index("email")!=nil then
    i = str.index("email") + "email".length + 3

    while str[i]!='"' do
      $EMAIL+=str[i]
      i+=1
    end

  end

end



def getAccInfo
    uri = URI.parse("https://api.vscale.io/v1/account")
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
      findAccInfo(response.body)
    when 400..499
      puts 'ERROR: Can\'t access account'
    when 500..599
      puts 'ERROR: Vsacle Server is not available'
    else
      puts 'ERROR: Unknown Error'
    end


end


def getServerList(str)
  puts str
  puts

  $SERVER_NAMES_ARRAY.clear()
  $SERVER_CTID_ARRAY.clear()
  $SERVER_AMOUNT_CACHED = 0

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


#############MAIN

getInfo()

while rdyToExit==false do

  if menuIsShown==false then
    puts ("---Menu:\n1-Add Servers \n2-Remove Servers \n3-Sync Servers \n4-Server list\n0-Exit")
    puts
    menuIsShown = true
  end
  print (">")
  # key = gets()

  case gets().chomp()
  when '0'
    rdyToExit=true
  when '1'
    puts ("Not available")
  when '2'
    clearScreen()
    printAccInfo()
    menuIsShown = false
    puts

    serverRemovalMenu()

    clearScreen()
    printAccInfo()
    puts
  when '3'
    clearScreen()
    printAccInfo()
    menuIsShown = false

    puts ("\n>Syncing servers")
    syncServers()

    
    puts
    # puts (">Press [Enter] to continue")
    # gets
  when '4'
    clearScreen()
    printAccInfo()
    menuIsShown = false
    puts

    puts ("---Server list:")
    for i in 0...$SERVER_CTID_ARRAY.length() do
      puts ($SERVER_NAMES_ARRAY[i]+" "+$SERVER_CTID_ARRAY[i])
    end

    puts
  else
    puts 'ERROR: Invalid Input'
  end
end


