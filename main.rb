require 'net/http'
require 'uri'

system "clear" or system "cls"
puts

TOKEN_LINE_IN_FILE = 1
PROGRAM_FOLDER_PATH = Dir.pwd
# puts (Dir.entries(PROGRAM_FOLDER_PATH))

ACC_FILE = "AccountPreferences.txt"
TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp
$EMAIL = ""

rdyToExit = false

def printAccInfo
    puts ('AppFolder: ' + PROGRAM_FOLDER_PATH)
    puts ('Token: ' + TOKEN)
    puts ('E-mail: ' + $EMAIL)
end


def launchInfo
    puts '---VscaleServerManager v1'
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
      puts 'Vsacle Server is not available'
    else
      puts 'Unknown ERROR'
    end


end


######

launchInfo()

while rdyToExit==false do
  puts ("0-Exit")
  # key = gets()

  case gets.to_i()
  when 0
    rdyToExit=true
  else
    puts
    puts 'ERROR: Invalid Input'
  end
end


