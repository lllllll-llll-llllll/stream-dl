autoit tool to download vods from popular streaming websites

requirements:
  windows
  autoit3
  ffmpeg
  curl
	
setup:
  clone or download repo as zip
  optional: compile stream-dl.au3 into stream-dl.exe using autoit. add stream-dl folder to your windows PATH, that way you can run it easily via command line

usage:
  au3: AutoIt3.exe stream-dl.au3 <URL> <OUTPUT>
  exe: stream-dl <URL> <OUTPUT>

note:
  <URL> is the full url visible in the address bar, eg "https://www.periscope.tv/w/skghkasdhgjsd"
