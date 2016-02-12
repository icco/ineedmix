#! /bin/bash

RUBY=~/.rvm/environments/ruby-2.3.0

if [[ ! -f $RUBY ]] ; then
  echo "File $RUBY is not there, aborting."
  exit
fi

source $RUBY

git pull
bundle update
git ci Gemfile* -m 'bundle update'
git push

./ineedmix.rb -i /usr/local/bin/get_iplayer -a refresh
./ineedmix.rb -i /usr/local/bin/get_iplayer -d /Volumes/Data/Clouds/Dropbox/Music/Mixes/Unsorted -a download
