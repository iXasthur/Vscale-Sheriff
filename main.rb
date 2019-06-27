require 'net/http'
require 'uri'
require 'json'
require 'certified'
load 'accInfoIO_Source.rb'
load 'createServerTool_Source.rb'
# load 'removalTool_Source.rb'
# load 'serverSyncTool_Source.rb'

ACC_FILE = 'AccountPreferences.txt'.freeze
PROGRAM_FOLDER_PATH = Dir.pwd

# Accounts
class Account
  def initialize(token, arr)
    @token = token
    @servers = arr
  end
end


# TOKEN_LINE_IN_FILE = 0
# TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp


rdy_to_exit = false
menu_is_show = false


# -----MAIN-----

getInfo


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
  when '4'
    menu_is_show = false
  else
    puts 'ERROR: Invalid Input'
  end

end


