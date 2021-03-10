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

usage:
  autoit3.exe stream-dl.au3 https://vimeo.com/502163294 vimeo.mp4
  autoit3.exe stream-dl.au3 <video url input> <video filename output>

note:
  <URL> is the full url visible in the address bar, eg "https://www.periscope.tv/w/skghkasdhgjsd"
