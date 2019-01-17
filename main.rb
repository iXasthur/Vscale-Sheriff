require 'net/http'
require 'uri'


TOKEN_LINE_IN_FILE = 1
PROGRAM_FOLDER_PATH = Dir.pwd
# puts (Dir.entries(PROGRAM_FOLDER_PATH))

ACC_FILE = "AccountPreferences.txt"
TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp
$EMAIL = ""

rdyToExit = false
menuIsShown = false

DEBUG_SERVER_LIST = ""


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
  puts DEBUG_SERVER_LIST


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




######

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
    puts ("Not available")
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
    puts ("Not available")
  else
    puts 'ERROR: Invalid Input'
  end
end


