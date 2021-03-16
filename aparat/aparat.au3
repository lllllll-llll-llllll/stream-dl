func aparat()
	$html = ''	;
	$video = ''	;
	$c = ''		;

	;download html
	$c = 'curl -o "html" "' & $input & '" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;scrape video url
	$html = FileReadToArray('html')
	for $i = 0 to ubound($html)-1
		if stringinstr($html[$i], '<meta property="og:video"') Then
			$video = stringsplit($html[$i], '"', 3)
			$video = $video[3]
			ExitLoop
		EndIf
	next

	;download video
	$c = 'curl -o "' & $output & '" "' & $video & '"'
	runwait(@ComSpec & " /c " & $c, "", @SW_HIDE)

	;cleanup
	filedelete('html')


EndFunc
