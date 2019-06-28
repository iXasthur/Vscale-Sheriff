# Prints account list
def printAccountList(accounts)
  maxl = 0
  accounts.each do |account|
    if account.getCount != -1 then
      for i in 0..(account.getCount - 1)
        s = account.readServer(i)
        if s[0].length > maxl then
          maxl = s[0].length
        end
      end
    end
  end

  accounts.each do |account|
    if account.getCount != -1 then
      puts(account.getToken)
      puts(account.getEmail)

      for i in 0..(account.getCount - 1)
        s = account.readServer(i)
        print s[0].ljust(maxl+5) + ' '
        puts s[1]
      end
      puts
    end
  end

  if accounts.count == 0
    puts('There is no accounts found. Please input tokens in ' + ACC_FILE + ' (each token from a new line)')
    puts
  end
end


# Loads Acc Info From The Server
def getInfo(accounts)
  tokens = IO.readlines(ACC_FILE)

  tokens.each do |token|
    token = token.chomp
    accounts << Account.new(token, getAccEmail(token), 0, [])

    case accounts[accounts.count - 1].getEmail
    when ERROR_MSG_1, ERROR_MSG_2, ERROR_MSG_3
      accounts[accounts.count - 1].invalidate
    end
  end

end

# Prints accounts
def printAccounts(accounts)

  maxl = 0
  accounts.each do |account|
    if account.getEmail.length>maxl then
      maxl = account.getEmail.length
    end
  end

  i = 1
  accounts.each do |account|
    print (i.to_s.rjust(2) + '. ')
    printAccInfo(account,maxl)
    i = i + 1
  end

  if accounts.count == 0
    puts('There is no accounts found. Please input tokens in ' + ACC_FILE + ' (each token from a new line)')
  end
  puts
  puts
end

# Outputs Email + Cached count
def printAccInfo(account,s)
  puts(account.getEmail.rjust(s) + ",  cached:" + account.getCount.to_s.rjust(3))
end



# Reads Email form JSON
def getAccEmail(token)
  body = requestAccInfo(token)
  jsn = JSON.parse(body)
  jsn = jsn['info']
  return jsn['email']
end

# HTTP GET REQUEST
def requestAccInfo(token)
  uri = URI.parse('https://api.vscale.io/v1/account')
  request = Net::HTTP::Get.new(uri)
  request['X-Token'] = token

  req_options = {
    use_ssl: uri.scheme == 'https'
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