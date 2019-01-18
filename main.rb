require 'net/http'
require 'uri'
require 'json'
load 'accInfoIO_Source.rb'
load 'createServerTool_Source.rb'
load 'removalTool_Source.rb'
load 'serverSyncTool_Source.rb'

ACC_FILE = "AccountPreferences.txt"
TOKEN_LINE_IN_FILE = 1
TOKEN = IO.readlines(ACC_FILE)[TOKEN_LINE_IN_FILE].chomp

PROGRAM_FOLDER_PATH = Dir.pwd
# puts (Dir.entries(PROGRAM_FOLDER_PATH))

$EMAIL = ""

$SERVER_NAMES_ARRAY = Array.new()
$SERVER_CTID_ARRAY = Array.new()


rdyToExit = false
menuIsShown = false






#############MAIN

getInfo()


# Main Menu
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
    clearScreen()
    printAccInfo()
    menuIsShown = false
    puts

    serverRemovalMenu()

    clearScreen()
    printAccInfo()
    puts
  when '3'
    clearScreen()
    printAccInfo()
    menuIsShown = false

    puts ("\n>Syncing servers")
    syncServers()


    clearScreen()
    printAccInfo()
    menuIsShown = false

    puts ("\n>Syncing servers")

    puts
    puts ("Found " + $SERVER_CTID_ARRAY.length().to_s() + " servers")
    puts
    puts
    # puts (">Press [Enter] to continue")
    # gets
  when '4'
    clearScreen()
    printAccInfo()
    menuIsShown = false
    puts

    puts ("---Server list:")
    for i in 0...$SERVER_CTID_ARRAY.length() do
      puts ($SERVER_NAMES_ARRAY[i]+" (ctid: "+$SERVER_CTID_ARRAY[i] + ")")
    end

    puts
    puts ("Server amount: " + $SERVER_CTID_ARRAY.length().to_s())
    puts
    puts
  else
    puts 'ERROR: Invalid Input'
  end
end


