require 'net/http'


File.open("AccPrefs.txt","r") do |file|

end

TOKEN = ""


def launchInfo
    puts '---VscaleServerManager v1'
    puts ('Token: ' + TOKEN)
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

    puts response.code
    puts response.body



end


######

launchInfo()
getAccInfo()
