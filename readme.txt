autoit tool to download vods from popular streaming websites

i know it seems pointless since youtube-dl already exists. but i don't like python and they have a whole lot of extractors for junk websites. focusing on popular streaming websites like twitch, periscope, ok.ru, etc, hopefully will make it useful.

requirements:
  windows operating system
  autoit3
  ffmpeg
  curl
	
setup:
  make sure the requirements above are ok or installed already
  clone or download repo as zip
  optional: compile stream-dl.au3 into stream-dl.exe using autoit. add stream-dl folder to your windows PATH, that way you can run it easily via command line

usage:
  au3: AutoIt3.exe stream-dl.au3 <URL> <OUTPUT>
  exe: stream-dl <URL> <OUTPUT>

note:
  <URL> is the full url visible in the address bar, eg "https://www.periscope.tv/w/skghkasdhgjsd"
