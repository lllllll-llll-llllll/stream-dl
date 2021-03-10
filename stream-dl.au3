#include <Array.au3>

$input  = $CmdLine[1] ;url
$output = $CmdLine[2] ;filename for saved video

$split = stringsplit($input, '/', 2)
$website = $split[2]

$script = ''

switch $website
	case 'www.pscp.tv', 'www.periscope.tv'
		$script = 'AutoIt3.exe ' & @scriptdir & '\periscope\periscope.au3 ' & $input

	case 'vimeo.com'
		$script = 'AutoIt3.exe ' & @scriptdir & '\vimeo\vimeo.au3 ' & $input

endswitch

runwait(@ComSpec & " /c " & $script, "", @SW_HIDE)

select
	case fileexists('m3u8')
		m3u8()

	case fileexists('mp4')
		mp4()

	case fileexists('m4s')
		m4s()
endselect




;downloaders

func m4s()
	;join video files, add audio

endfunc


func m3u8()
	$url = fileread('m3u8')
	filedelete('m3u8')
	$command = 'ffmpeg -i "' & $url & '" -c copy -bsf:a aac_adtstoasc "' & $output & '"'
	runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)

endfunc


func mp4()
	$url = fileread('mp4')
	filedelete('mp4')
	$command = 'curl -o "' & $output & '" "' & $url
	runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)
endfunc


























