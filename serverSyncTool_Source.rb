


def getServers(account)
  body = requestServers(account.getToken)
  jsn = JSON.parse(body)
  i = 0
  jsn.each do |sv|
    account.addServer(sv['name'],sv['ctid'].to_s)
    i = i + 1
  end
  return i
end


def syncServers(accounts)
  i = 0
  accounts.each do |account|
    if account.getCount != -1 then
      account.clearServers
      i = i + getServers(account)
    end
  end

  return i
end




# Server Sync
def requestServers(token)

      uri = URI.parse('https://api.vscale.io/v1/scalets')
      request = Net::HTTP::Get.new(uri)
      request['X-Token'] = token
      req_options = {
        use_ssl: uri.scheme == "https",
      }


      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end


      case response.code.to_i
      when 200..299
        return (response.body)
      when 400..499
        s = '{"info": {"email": "'
        s = s + ERROR_MSG_1
        s = s + '"}}'
        return s
      when 500..599
        s = '{"info": {"email": "'
        s = s + ERROR_MSG_2
        s = s + '"}}'
        return s
      else
        s = '{"info": {"email": "'
        s = s + ERROR_MSG_3
        s = s + '"}}'
        return s
      end
end