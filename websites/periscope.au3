func periscope()
	$id = ''		;broadcast id from url
	$json = ''		;json request
	$m3u8 = ''		;final url to download
	$c = ''			;temp cmdline variable

	;get json
	$id = stringsplit($input, '/', 3)
	$id = $id[ubound($id)-1]
	$c = 'curl -o "json" "https://api.periscope.tv/api/v2/accessVideoPublic?broadcast_id=' & $id & '&replay_redirect=false" -H "Accept: */*"'
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

