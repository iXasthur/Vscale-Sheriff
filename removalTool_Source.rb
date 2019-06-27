
# Remover By CTID
def deleteServerByCTID(token,ctid)
    uri = URI.parse('https://api.vscale.io/v1/scalets/' + ctid)
    request = Net::HTTP::Delete.new(uri)
    request.content_type = 'application/json;charset=UTF-8'
    request['X-Token'] = token
    
    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    case response.code.to_i
    when 200..299
      return '1'
    when 400..499
      return 'ERROR: Can\'t access account/invalid ctid'
    when 500..599
      return 'ERROR: Vsacle Server is not available'
    else
      return 'ERROR: Unknown Error'
    end
    
end
  

# Removal Tool Menu
def serverRemoveAll(accounts)
  v = 0
  p = false
  accounts.each do |account|
    if account.getCount != -1 then
      for i in 0..(account.getCount - 1)
        p = true
        s = account.readServer(0)
        puts '>Deleting server (Email: ' + account.getEmail + ', ctid: ' + s[1] + ')'
        resp = deleteServerByCTID(account.getToken,s[1])

        if resp=='1'
          puts '>Successful!'
          v = v + 1
        else
          puts resp
        end
        puts
        account.removeFirst
      end
    end
  end

  if p then
    puts
  end
  return v
end