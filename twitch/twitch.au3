;$input
;$output
;$website

func twitch()
	local $type = ''	;"vod" or "clip"
	local $id = ''		;url video id
	local $slug = ''	;the weird url id naming scheme for twitch clips
	local $hash = ''	;hash of clip access token query, doesnt change
	local $cid = ''		;client id. seems to not change??
	local $sig = ''		;playback access token signature
	local $exp = ''		;playback access token expiration
	local $json = ''	;json string
	local $m3u8 = ''	;line 5 of retrieved m3u, vid playlist at source resolution?
	local $mp4 = ''		;mp4 url for clips
	local $c = ''		;temp command line variable

	if stringinstr($input, '/clip/') then $type = 'clip'
	if stringinstr($input, '/videos/') then $type = 'vod'

	;client id - for guests?
	$cid = 'kimne78kx3ncx6brgo4mv6wki5h1ko'




	if $type = 'clip' then

		;<streamer>clip<RandomWordsFoundHere>-F2_FJ5U01XaoCLOr
		$slug = stringsplit($input, '/clip/', 3)
		$slug = $slug[1]

		;query hash
		$hash = '36b89d2507fce29e5ca551df756d27c1cfe079e2609642b4390aa4c35796eb11'

		;get playback access token/signature
		$c = 'curl -o "json" "https://gql.twitch.tv/gql#origin=twilight" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US" -H "Referer: ' & $input & '" -H "Client-Id: ' & $cid & '" -H "X-Device-Id: undefined" -H "Content-Type: text/plain;charset=UTF-8" -H "Origin: https://www.twitch.tv" -H "DNT: 1" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data-raw "[{\"operationName\":\"VideoAccessToken_Clip\",\"variables\":{\"slug\":\"' & $slug & '\"},\"extensions\":{\"persistedQuery\":{\"version\":1,\"sha256Hash\":\"' & $hash & '\"}}}]"'
		runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)
		$json = FileRead('json')
		$sig = stringsplit($json, '"signature"', 3)
		$sig = stringsplit($sig[1], '"', 3)
		$sig = $sig[1]

		;get token expires value
		$exp = stringsplit($json, 'expires', 3)
		$exp = stringsplit($exp[1], ':,', 2)
		$exp = $exp[1]

		;get mp4 url
		$json =fileread('json')
		$mp4 = stringsplit($json, 'sourceURL', 3)
		$mp4 = stringsplit($mp4[1], '"', 3)
		$mp4 = $mp4[2]

		$c ='curl -g -o "' & $output & '" "' & $mp4 & '?sig=' & $sig & '&token={\"authorization\":{\"forbidden\":false,\"reason\":\"\"},\"clip_uri\":\"\",\"device_id\":\"undefined\",\"expires\":' & $exp & ',\"user_id\":\"\",\"version\":2}"'
		runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

		;cleanup
		filedelete('json')




	elseif $type = 'vod' then
		;video id
		$id = stringsplit($input, '/?', 2)
		$id = $id[4]


		;get playback access token/signature
		$c = 'curl.exe -o "json" "https://gql.twitch.tv/gql" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US" -H "Referer: https://www.twitch.tv/videos/' & $id & '" -H "Authorization: undefined" -H "Client-ID: ' & $cid & '" -H "Content-Type: text/plain; charset=UTF-8" -H "Device-ID: undefined" -H "Origin: https://www.twitch.tv" -H "DNT: 1" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache" --data-raw "{\"operationName\":\"PlaybackAccessToken_Template\",\"query\":\"query PlaybackAccessToken_Template($login: String!, $isLive: Boolean!, $vodID: ID!, $isVod: Boolean!, $playerType: String!) {  streamPlaybackAccessToken(channelName: $login, params: {platform: \\\"web\\\", playerBackend: \\\"mediaplayer\\\", playerType: $playerType}) @include(if: $isLive) {    value    signature    __typename  }  videoPlaybackAccessToken(id: $vodID, params: {platform: \\\"web\\\", playerBackend: \\\"mediaplayer\\\", playerType: $playerType}) @include(if: $isVod) {    value    signature    __typename  }}\",\"variables\":{\"isLive\":false,\"login\":\"\",\"isVod\":true,\"vodID\":\"' & $id & '\",\"playerType\":\"site\"}}"'
		runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)
		$json = FileRead('json')
		$sig = stringsplit($json, '"signature"', 3)
		$sig = stringsplit($sig[1], '"', 3)
		$sig = $sig[1]


		;get token expires value
		$exp = stringsplit($json, 'expires', 3)
		$exp = stringsplit($exp[1], ':,', 2)
		$exp = $exp[1]


		;download m3u
		$c = 'curl -g -o "m3u" "https://usher.ttvnw.net/vod/' & $id & '.m3u8?allow_source=true&sig=' & $sig & '&token={\"authorization\":{\"forbidden\":false,\"reason\":\"\"},\"chansub\":{\"restricted_bitrates\":[]},\"device_id\":\"undefined\",\"expires\":' & $exp & ',\"https_required\":true,\"privileged\":false,\"user_id\":null,\"version\":2,\"vod_id\":' & $id & '}" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.5" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache"'
		runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


		;download m3u8
		$m3u8 = filereadline('m3u', 5)
		$c = 'ffmpeg -y -i "' & $m3u8 & '" -c copy -bsf:a aac_adtstoasc "' & $output & '"'
		runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)


		;cleanup
		filedelete('json')
		filedelete('m3u')
	endif

EndFunc











