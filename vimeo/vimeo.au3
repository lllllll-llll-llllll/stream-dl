#include <Array.au3>

$input = $CmdLine[1] ;url

;download html
$split = stringsplit($input, '/', 3)
$id = $split[ubound($split)-1] ;vid id
$command = 'curl -o "HTML" "' & $input & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://vimeo.com/watch" -H "DNT: 1" -H "Connection: keep-alive" -H "Upgrade-Insecure-Requests: 1" -H "Pragma: no-cache" -H "Cache-Control: no-cache"'
runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)


;scrape session id from html
$sid = ''
$html = FileReadToArray('HTML')
$match  = '    window.vimeo.clip_page_config = {"clip":'
$length = stringlen($match)
for $i = 0 to ubound($html)-1
	$line = $html[$i]
	if stringleft($line, $length) = $match then
		$split = stringsplit($line, 'watch_trailer', 3)
		$split = stringsplit($split[1], '","player_url"', 3)
		$split = stringsplit($split[0], '=', 3)
		$sid = $split[ubound($split)-1]
		exitloop
	endif
next


;get json
$command = 'curl -o "JSON" "https://player.vimeo.com/video/' & $id & '/config?autopause=1&byline=0&collections=1&context=Vimeo"%"5CController"%"5CClipController.main&default_to_hd=1&outro=nothing&portrait=0&share=1&title=0&watch_trailer=0&s=' & $sid & '" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://vimeo.com/' & $id & '" -H "Origin: https://vimeo.com" -H "DNT: 1" -H "Connection: keep-alive" -H  "Pragma: no-cache" -H "Cache-Control: no-cache"'
runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)


;scrape json for progressive 1080p mp4 video
$vid = ''
$json = fileread('JSON')
$regex = stringregexp($json, 'vod-progressive(.*?)"id":', 3)
for $i = 0 to ubound($regex)-1
	$result = $regex[$i]
	if stringinstr($result, '"1080p"') then
		$split = stringsplit($result, '","', 3)
		$vid = 'https://vod-progressive' & $split[0]
		exitloop
	endif
next


;write video url so main script can dl it
$split = stringsplit(@scriptdir, '\', 2)
$path = _arraytostring($split, '\', 0, ubound($split)-2)
filewrite($path & '\mp4', $vid)


;cleanup
filedelete('HTML')
filedelete('JSON')






