personal practice for scraping videos from popular streaming websites

requires:
  windows operating system
  autoit3
  ffmpeg
  curl

tests:
  autoit3 stream-dl.au3 https://www.pscp.tv/WhiteHouse/1vOxwEPwDrmGB periscope.mp4
  autoit3 stream-dl.au3 https://www.twitch.tv/paymoneywubby/clip/TenuousSucculentPancakeTheThing-F2_FJ5U01XaoCLOr twitch-clip.mp4
  autoit3 stream-dl.au3 https://www.twitch.tv/videos/887056377 twitch-vod.mp4
  autoit3 stream-dl.au3 https://vimeo.com/502163294 vimeo.mp4

