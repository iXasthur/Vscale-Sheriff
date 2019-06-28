require 'net/http'
require 'uri'
require 'json'
require 'certified'
load 'accInfoIO.rb'
load 'removalTool_Source.rb'
load 'serverSyncTool_Source.rb'

ACC_FILE = 'Tokens.txt'.freeze
PROGRAM_FOLDER_PATH = Dir.pwd

ERROR_MSG_1 = "Can't access account"
ERROR_MSG_2 = "Vsacle Server is not available"
ERROR_MSG_3 = "Unknown Error"

CLS_MSG_1 = '-> VscaleSheriff PRO v2.13  (c) Mikhail Kavaleuski'
CLS_MSG_2 = '-> ETH: 0x212Eb1FaEaaFd7ea1a14668573C9C044a34a2bf0'

# Clears Terminal
def clearScreen
  system 'clear' or system 'cls'
  puts

  puts CLS_MSG_1
  puts CLS_MSG_2
  puts
  puts('App Folder: ' + PROGRAM_FOLDER_PATH)
  puts
end

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

  def removeFirst
    @servers.shift
    @count = @count - 1
  end

  def clearServers
    @servers = []
    @count = 0
  end
end



rdy_to_exit = false
menu_is_show = false

accounts = Array[]

# -----MAIN-----

clearScreen

if File.exists?(ACC_FILE)

  puts '>Connecting to the server'
  puts

  getInfo(accounts)
  printAccounts(accounts)

  # Main Menu
  while rdy_to_exit == false

    if menu_is_show == false
      puts("---Menu:\n1-Add Servers \n2-Remove ALL Servers \n3-Sync Servers \n4-Server list\n0-Exit")
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
      clearScreen

      puts('>Removing all servers')
      puts
      puts ('>Successfully removed ' + serverRemoveAll(accounts).to_s + ' servers')
      puts

      printAccounts(accounts)
    when '3'
      menu_is_show = false
      clearScreen

      puts('>Clearing existing servers')
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

else
  puts('>Unable to find file ' + ACC_FILE)
  File.new(ACC_FILE,"w")
  puts('>File ' + ACC_FILE + ' has been created in application directory')
  puts('>Please input tokens here(each token from a new line)')
  puts
  puts('Press <Enter> to exit')
  gets
end


