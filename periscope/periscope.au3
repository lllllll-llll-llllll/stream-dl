#include <Array.au3>

$input = $CmdLine[1]
$split = stringsplit($input, '/', 3)
$broadcast_id = $split[ubound($split)-1]
$command = 'curl -o "response" "https://api.periscope.tv/api/v2/accessVideoPublic?broadcast_id=' & $broadcast_id & '&replay_redirect=false" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0" -H "Accept: */*" -H "Accept-Language: en-US,en;q=0.5" -H "Referer: https://www.periscope.tv/w/' & $broadcast_id & '" -H "X-Attempt: 1" -H "Origin: https://www.periscope.tv" -H "DNT: 1" -H "Connection: keep-alive" -H "Pragma: no-cache" -H "Cache-Control: no-cache"'
runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)

$json = fileread('response')
$split = stringsplit($json, ',', 2)
$split = stringsplit($split[1], '"', 2)
$m3u8 = $split[3]

filedelete('response')

$split = stringsplit(@scriptdir, '\', 2)
$path = _arraytostring($split, '\', 0, ubound($split)-2)
filewrite($path & '\m3u8', $m3u8)































