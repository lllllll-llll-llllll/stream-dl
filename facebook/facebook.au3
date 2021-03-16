#include <Array.au3>

facebook()

func facebook()
	$html =  ''		;initial page download
	$video = ''		;scraped video-only mp4
	$audio = ''		;scraped audio-only mp4
	$c = ''			;temp command line variable

	;get html
	$c = 'curl -o "html" "' & $input & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.5" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "TE: Trailers"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;scrape html
	$html = FileReadToArray('html')
	for $i = 0 to ubound($html)-1
		if stringinstr($html[$i], '"prefetch_dash_segments":[{"video":[{"url":"') then

			;get video url
			$video = stringsplit($html[$i], '"prefetch_dash_segments":[{"video":[{"url":"', 3)
			$video = stringsplit($video[1], '?&"', 2)
			local $url     = stringreplace($video[0], '\', '')
			local $_nc_ohc = $video[5]
			local $_nc_ht  = $video[6]
			local $oh      = $video[7]
			local $oe      = $video[8]
			$video = $url & '?' & $_nc_ohc &'&'& $_nc_ht &'&'& $oh &'&'& $oe

			;get audio url
			$audio = stringsplit($html[$i], '"dash_prefetch_resources":{"audio":[{"url":"', 3)
			$audio = stringsplit($audio[1], '?&"', 2)
			$url     = stringreplace($audio[0], '\', '')
			$_nc_ohc = $audio[5]
			$_nc_ht  = $audio[6]
			$oh      = $audio[7]
			$oe      = $audio[8]
			$audio = $url & '?' & $_nc_ohc &'&'& $_nc_ht &'&'& $oh &'&'& $oe

			exitloop
		endif
	next


	;download audio and video
	$c = 'ffmpeg -i "' & $video & '" -i "' & $audio & '" -c copy -map 0:v -map 1:a "' & $output & '"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;cleanup
	filedelete('html')

endfunc
