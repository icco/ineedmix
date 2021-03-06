#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'

# https://github.com/dinkypumpkin/get_iplayer
IPLAYER_DIR = File.expand_path("~/.get_iplayer")
IPLAYER_CACHE = "#{IPLAYER_DIR}/radio.cache"
IPLAYER_HISTORY = "#{IPLAYER_DIR}/download_history"

FileUtils.mkdir_p(IPLAYER_DIR)
FileUtils.touch(File.expand_path(IPLAYER_HISTORY))

options = {
  :action => nil,
  :directory => "/tmp/",
  :shows => ["Pete Tong", "Annie Mac", "BBC Radio 1's Essential Mix", "Residency"],
  :iplayer => "~/Projects/get_iplayer/get_iplayer",
}

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on("-a", "--action [ACTION]", [:refresh, :download], "Select action to perform: refresh or download.") do |t|
    options[:action] = t
  end

  opts.on("-d", "--directory [DOWNLOAD_PATH]", "Directory to Download to.") do |d|
    options[:directory] = d
  end

  opts.on("-i", "--get_iplayer [bin_path]", "get_iplayer binary location.") do |d|
    options[:iplayer] = d
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
    @get_iplayer = options[:iplayer]

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
    Kernel.system "#{@get_iplayer} --refresh --type=radio"
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
            puts "Downloading: #{parts[3]} - #{parts[2]} - #{parts[10]}"
            cmd = "#{@get_iplayer} --modes=best --aactomp3 --type=radio --pid #{parts[3]} --output #{@directory}"
            puts cmd
            Kernel.system cmd
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
