

	SELECT distinct ROCO_CODE,TERMINAL_CODE FROM ROCO_ROUTEMASTER WHERE Reverification='Normal'
	AND ROCO_CODE+'$'+TERMINAL_CODE NOT IN (
	SELECT distinct ROCO_CODE+'$'+TERMINAL_CODE FROM ROCO_ROUTEMASTER WHERE Reverification='Reverification-1')

