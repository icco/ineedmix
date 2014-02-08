# ineedmix

A simple tool to run nightly to mirror essential mix.

```
Usage: ./ineedmix.rb [options]
    -a, --action [ACTION]            Select action to perform: refresh or download.
    -d, --directory [DOWNLOAD_PATH]  Directory to Download to.
    -i, --get_iplayer [bin_path]     get_iplayer binary location.
    -s, --shows x,y,z                List of shows to try and download.
    -h, --help                       Show this message
```

Based off of the work by @dougochris at https://gist.github.com/dougochris/441636.

## Dependencies

 * Debian: `sudo aptitude install ffmpeg mplayer libmp3-tag-perl libnet-smtp-ssl-perl libauthen-sasl-perl`
 * Other: https://github.com/dinkypumpkin/get_iplayer/wiki/installation

## Installation

First install the deps for your OS.

Just `git clone https://github.com/icco/ineedmix` and `https://github.com/dinkypumpkin/get_iplayer`. Then `cd ineedmix`.

Finally `./ineedmix.rb -i ../get_iplayer/get_iplayer -a refresh; ./ineedmix.rb -i ../get_iplayer/get_iplayer -d /tmp/ -a download` and watch this weeks music appear in your `/tmp` directory.
