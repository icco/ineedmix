#! /bin/bash

RUBY=~/.rvm/environments/ruby-2.3.0

if [[ ! -f $RUBY ]] ; then
  echo "File $RUBY is not there, aborting."
  exit
fi

source $RUBY

git pull
git push

./ineedmix.rb -i ../get_iplayer/get_iplayer -a refresh; ./ineedmix.rb -i ../get_iplayer/get_iplayer -d /tmp/ -a download
