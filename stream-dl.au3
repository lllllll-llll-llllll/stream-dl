#include <Array.au3>

global $input = ''		;full url input
global $output = ''		;full filename output
global $website = ''	;simplified name of website

$input  = $CmdLine[1]
$output = $CmdLine[2]

$website = stringsplit($input, '/', 2)
$website = $website[2]




switch $website
	case 'www.aparat.com', 'aparat.com'
		aparat()

	case 'www.facebook.com', 'facebook.com'
		facebook()

	case 'periscope.tv', 'pscp.tv', 'www.periscope.tv', 'www.pscp.tv',
		periscope()

	case 'vimeo.com', 'www.vimeo.com'
		vimeo()

	case 'twitch.tv', 'www.twitch.tv'
		twitch()

endswitch

#include "aparat\aparat.au3"
#include "facebook\facebook.au3"
#include "periscope\periscope.au3"
#include "twitch\twitch.au3"
#include "vimeo\vimeo.au3"


