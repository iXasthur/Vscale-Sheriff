require 'net/http'
require 'uri'
require 'json'
require 'certified'
load 'accInfoIO.rb'
# load 'removalTool_Source.rb'
load 'serverSyncTool_Source.rb'

ACC_FILE = 'AccountPreferences.txt'.freeze
PROGRAM_FOLDER_PATH = Dir.pwd

ERROR_MSG_1 = "Can't access account"
ERROR_MSG_2 = "Vsacle Server is not available"
ERROR_MSG_3 = "Unknown Error"


# Accounts
class Account
  def initialize(token, email, count, arr)
    @token = token
    @email = email
    @count = count
    @servers = arr
  end

  def getToken
    return @token
  end

  def getEmail
    return @email
  end

  def getCount
    return @count
  end

  def invalidate
    @count = -1
  end

  def addServer(name,ctid)
    @servers << [name,ctid]
    @count = @count + 1
  end

  def readServer(i)
    return @servers[i]
  end
end



rdy_to_exit = false
menu_is_show = false

accounts = Array[]

# -----MAIN-----

getInfo(accounts)
printHead(accounts)

# Main Menu
while rdy_to_exit == false

  if menu_is_show == false
    puts("---Menu:\n1-Add Servers \n2-Remove Servers \n3-Sync Servers \n4-Server list\n0-Exit")
    puts
    menu_is_show = true
  end
  print('>')

  case gets.chomp
  when '0'
    rdy_to_exit = true
  when '1'
    puts('Not available')
  when '2'
    menu_is_show = false
  when '3'
    menu_is_show = false
    clearScreen

    puts('>Syncing servers')
    puts('>Added ' + syncServers(accounts).to_s + ' servers')
    puts

    printAccounts(accounts)
  when '4'
    menu_is_show = false
    clearScreen

    printAccountList(accounts)

    puts
  else
    puts 'ERROR: Invalid Input'
  end

end


