require 'net/http'
require 'uri'

puts


TOKEN_LINE_IN_FILE = 1
PROGRAM_FOLDER_PATH = Dir.pwd

ACC_FILE = "AccountPreferences.txt"

TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp


def launchInfo
    puts '---VscaleServerManager v1'
    puts ('AppFolder: ' + PROGRAM_FOLDER_PATH)
    # puts (Dir.entries(PROGRAM_FOLDER_PATH))
    puts ('Token: ' + TOKEN)
    puts
end


def showAccInfo(str)
  # puts str

  puts str.index("email")

  if str.index("email")!=nil then
    puts '1'
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
      showAccInfo(response.body)
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
getAccInfo()
