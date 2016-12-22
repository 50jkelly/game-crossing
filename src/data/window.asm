mainWindowClass			db "CrossingMainWindow",0
applicationTitle 		db "Crossing",0
windowHandle			dd	0
windowWidth				dd 800
windowHeight			dd 600
calculatedWindowWidth	dd 0
calculatedWindowHeight	dd 0

rect	RECT
wcex	WNDCLASSEX
msg 	MSG