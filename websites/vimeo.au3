;$input
;$output
;$website

func vimeo()
	local $id = ''		;url id
	local $sid = ''		;session id
	local $vid = ''		;url of 1080p mp4 to be downloaded
	local $html = ''	;array of html response of url
	local $json = ''	;string of json response containing video metadata

	local $match = ''	;string to match the line containing session id in the html
	local $regex = ''	;regexp matches found in $json
	local $length = ''	;length of $match
	local $s = '' 		;temp var reused for string splitting
	local $c = ''		;temp var reused for making command line calls
	local $i = ''		;current line of html array
	local $line = ''	;^
	local $j = ''		;current $regex array index
	local $result = ''	;^


	;download html
	$s = stringsplit($input, '/', 3)
	$id = $s[ubound($s)-1] ;vid id
	$c = 'curl -o "HTML" "' & $input & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://vimeo.com/watch" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


	;scrape session id from html
	$html = FileReadToArray('HTML')
	$match  = '    window.vimeo.clip_page_config = {"clip":'
	$length = stringlen($match)
	for $i = 0 to ubound($html)-1
		$line = $html[$i]
		if stringleft($line, $length) = $match then
			$s = stringsplit($line, 'watch_trailer', 3)
			$s = stringsplit($s[1], '","player_url"', 3)
			$s = stringsplit($s[0], '=', 3)
			$sid = $s[ubound($s)-1]
			exitloop
		endif
	next


	;get json
	$c = 'curl -o "JSON" "https://player.vimeo.com/video/' & $id & '/config?autopause=1&byline=0&collections=1&context=Vimeo"%"5CController"%"5CClipController.main&default_to_hd=1&outro=nothing&portrait=0&share=1&title=0&watch_trailer=0&s=' & $sid & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://vimeo.com/' & $id & '" -H "Origin: https://vimeo.com" -H "DNT: 1" -H "Connection: keep-alive" -H  "Pragma: no-cache" -H "Cache-Control: no-cache"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


	;scrape json for progressive 1080p mp4 video
	$json = fileread('JSON')
	$regex = stringregexp($json, 'vod-progressive(.*?)"id":', 3)
	for $j = 0 to ubound($regex)-1
		$result = $regex[$j]
		if stringinstr($result, '"1080p"') then
			$s = stringsplit($result, '","', 3)
			$vid = 'https://vod-progressive' & $s[0]
			exitloop
		endif
	next


	;download vid mp4
	$c = 'curl -o "' & $output & '" "' & $vid
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


	;cleanup
	filedelete('HTML')
	filedelete('JSON')

endfunc




