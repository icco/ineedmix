#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'

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



options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("--type [TYPE]", [:text, :binary, :auto],
          "Select transfer type (text, binary, auto)") do |t|
    options.transfer_type = t
          end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
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
          cmd = "#{GET_IPLAYER} --modes=best --aactomp3 --type=radio --pid #{parts[3]} --output #{DOWNLOAD_PATH}"
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
