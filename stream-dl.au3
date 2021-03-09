#include <Array.au3>

$input  = $CmdLine[1] ;url
$output = $CmdLine[2] ;filename for saved video

$split = stringsplit($input, '/', 2)
$website = $split[2]

$p =  'AutoIt3.exe '
$script = ''

switch $website
	case 'www.pscp.tv', 'www.periscope.tv'
		$script = 'AutoIt3.exe ' & @scriptdir & '\periscope\periscope.au3 ' & $input
endswitch

select
	case fileexists('m3u8')
		m3u8()

	case fileexists('mp4')
		mp4()
endselect















;downloaders

func m3u8()
	$url = fileread('m3u8')
	$command = 'ffmpeg -i "' & $url & '" -c copy -bsf:a aac_adtstoasc "' & $output & '"'
	runwait(@ComSpec & " /c " & $command, "", @SW_HIDE)
	filedelete('m3u8')

endfunc


func mp4()
endfunc
