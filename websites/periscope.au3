func periscope()
	$id = ''		;broadcast id from url
	$json = ''		;json request
	$m3u8 = ''		;final url to download
	$c = ''			;temp cmdline variable

	;get json
	$id = stringsplit($input, '/', 3)
	$id = $id[ubound($id)-1]
	$c = 'curl -o "json" "https://api.periscope.tv/api/v2/accessVideoPublic?broadcast_id=' & $id & '&replay_redirect=false" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://www.periscope.tv/w/' & $id & '" -H "X-Attempt: 1" -H "Origin: https://www.periscope.tv" -H "DNT: 1" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


	;get m3u8
	$json = fileread('json')
	$m3u8 = stringsplit($json, ',', 2)
	$m3u8 = stringsplit($m3u8[1], '"', 2)
	_arraydisplay($m3u8)
	$m3u8 = $m3u8[3]


	;download m3u8
	$c = 'ffmpeg -y -i "' & $m3u8 & '" -c copy -bsf:a aac_adtstoasc "' & $output & '"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


	;cleanup
	filedelete('json')


endfunc

