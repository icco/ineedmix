#! /usr/bin/env ruby

require 'fileutils'

# https://github.com/dinkypumpkin/get_iplayer
GET_IPLAYER = "~/Projects/get_iplayer/get_iplayer"
IPLAYER_CACHE = "~/.get_iplayer/radio.cache"
IPLAYER_HISTORY = "~/.get_iplayer/download_history"
DOWNLOAD_PATH = "~/Projects/snowball/public/misc/"

FileUtils.mkdir_p(File.dirname(File.expand_path(IPLAYER_CACHE)))
FileUtils.mkdir_p(File.dirname(File.expand_path(IPLAYER_HISTORY)))
FileUtils.touch(File.expand_path(IPLAYER_HISTORY))
FileUtils.mkdir_p(File.dirname(File.expand_path(DOWNLOAD_PATH)))

SHOWS = ["Pete Tong", "Annie Mac", "BBC Radio 1's Essential Mix"]

USAGE = <<END_OF_USAGE
  
  Usage: #{__FILE__} [refresh|download|find|get] (find needs the name) (get needs the PID)"
  
  *********** MANUAL REFRESH
  #{GET_IPLAYER} --refresh --type=radio
  
  *********** MANUAL FIND
  cat ~/.get_iplayer/radio.cache | grep -i '[SHOW NAME]' | awk 'BEGIN {FS=\"|\"}{ print $4, \" \",  $3, \" \", $11 }'
  
  *********** MANUAL GET
  #{GET_IPLAYER} --type=radio --pid [PID] --output #{DOWNLOAD_PATH}
END_OF_USAGE

if ARGV.length == 0
  puts USAGE
  exit
end

if ARGV[0] == "refresh"
  puts "#{'*'*80}"
  puts "*********** REFRESH (can take some time)"
  
  Kernel.system "#{GET_IPLAYER} --refresh --type=radio"
elsif ARGV[0] == "download"
  puts "#{'*'*80}"
  puts "*********** download"
  
  SHOWS.each do |name|
    shows = `cat #{IPLAYER_CACHE} | grep -i "#{name}"`
    unless shows.empty?
      shows.split("\n").each do |show|
        puts "#{'*'*80}"

        parts = show.split('|')
        downloaded = `cat #{IPLAYER_HISTORY} | grep "#{parts[3]}"`  
        if downloaded.empty?
          puts "Download   #{parts[3]} - #{parts[2]} - #{parts[10]}"
          cmd = "#{GET_IPLAYER} --modes=flashaaclow,rtspaaclow,wma --type=radio --pid #{parts[3]} --output #{DOWNLOAD_PATH}"
          puts cmd
          p Kernel.system cmd
        else
          puts "Downloaded #{parts[3]} - #{parts[2]} - #{parts[10]}"
        end  
      end  
    end  
  end  
else
  puts USAGE
end
