func rumble()
	local $html  = ''			;initial html download via input url
	local $embed = ''			;embed code needed to make the json request
	local $json  = ''			;json request string
	local $video = ''			;initially an array of messy urls from json. in the end it is a string, a url for the video we download

	local $c = ''				;temp command line variable
	local $i = ''				;temp loop variable
	local $rate = ''			;parsed bitrate from a url from the json
	local $best_index = ''		;$video[] index of the url with highest bitrate
	local $best_rate  = ''		;highest prased bitrate encountered via the $video[] urls

	;download html
	$c = 'curl -o "html" "' & $input & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101 Firefox/83.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;scrape embed code
	$html = filereadtoarray('html')
	for $i = 0 to ubound($html)-1
		if StringInStr($html[$i], '"VideoObject"') then
			$embed = stringsplit($html[$i], 'embedUrl":"https://rumble.com/embed/', 3)
			$embed = stringsplit($embed[1], '/', 3)
			$embed = $embed[0]
		endif
	next

	;json request using embed code
	$c = 'curl -g -o "json" "https://rumble.com/embedJS/u3/?request=video&ver=2&v=' & $embed & '&ext={"ad_count":null}&ad_wt=0"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;get urls
	$json = fileread('json')
	$video = stringsplit($json, '"url":"', 3)

	;pick url with largest bitrate
	$best_rate = 0
	$best_index = 1
	for $i = 1 to ubound($video)-4
		if stringinstr($video[$i], '"bitrate":') then
			$rate = stringsplit($video[$i], '"bitrate":', 3)
			$rate = stringsplit($rate[1], ',', 3)
			$rate = number($rate[0])
			if $rate > $best_rate then
				$best_rate  = $rate
				$best_index = $i
			endif
		endif
	next
	$video = stringsplit($video[$best_index], '"',  3)
	$video = $video[0]

	;download mp4
	$c = 'curl -o "' & $output & '" "' & $video & '"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;cleanup
	filedelete('html')
	filedelete('json')



EndFunc
