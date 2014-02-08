#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'

# https://github.com/dinkypumpkin/get_iplayer
GET_IPLAYER = "~/Projects/get_iplayer/get_iplayer"
IPLAYER_CACHE = "~/.get_iplayer/radio.cache"
IPLAYER_HISTORY = "~/.get_iplayer/download_history"

FileUtils.mkdir_p(File.dirname(File.expand_path(IPLAYER_CACHE)))
FileUtils.mkdir_p(File.dirname(File.expand_path(IPLAYER_HISTORY)))
FileUtils.touch(File.expand_path(IPLAYER_HISTORY))

options = {
  :action => nil,
  :directory => "~/Projects/snowball/public/misc/",
  :shows => ["Pete Tong", "Annie Mac", "BBC Radio 1's Essential Mix"],
}

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-a", "--action [ACTION]", [:refresh, :download], "Select action to perform: refresh or download.") do |t|
     options[:action] = t
  end

  opts.on("-d", "--directory [DOWNLOAD_PATH]", "Directory to Download to.") do |d|
    options[:directory] = d
  end

  opts.on("-s", "--shows x,y,z", Array, "List of shows to try and download.") do |list|
    options[:shows] = list
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

raise OptionParser::MissingArgument if options[:action].nil?

class INeedMix
  def initialize options
    @shows = options[:shows]
    @directory = options[:directory]
    @action = options[:action]

    FileUtils.mkdir_p(File.dirname(File.expand_path(@directory)))
  end

  def do_work
    if @action == :refresh
      self.refresh
    elsif @action == :download
      self.download
    else
      puts "I have not idea what \"#{@action}\" is."
      exit
    end
  end

  def refresh
    puts "*********** REFRESHING (can take some time)"
    Kernel.system "#{GET_IPLAYER} --refresh --type=radio"
  end

  def download
    puts "*********** DOWNLOADING"

    @shows.each do |name|
      shows = `cat #{IPLAYER_CACHE} | grep -i "#{name}"`
      unless shows.empty?
        shows.split("\n").each do |show|
          puts "#{'*'*80}"

          parts = show.split('|')
          downloaded = `cat #{IPLAYER_HISTORY} | grep "#{parts[3]}"`
          if downloaded.empty?
            puts "Download   #{parts[3]} - #{parts[2]} - #{parts[10]}"
            cmd = "#{GET_IPLAYER} --modes=best --aactomp3 --type=radio --pid #{parts[3]} --output #{@directory}"
            puts cmd
            p Kernel.system cmd
          else
            puts "Downloaded #{parts[3]} - #{parts[2]} - #{parts[10]}"
          end
        end
      end
    end
  end
end

worker = INeedMix.new options
worker.do_work
exit
