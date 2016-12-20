format PE GUI 4.0
entry start

include 'win32a.inc'

section '.code' code readable executable
	start:
		; Initialise the stack frame

		push ebp
		mov ebp, esp
		sub esp, 8

		; Initialise the window

		mov dword [esp], NULL
		call [GetModuleHandle]
		mov dword [wcex.hInstance], eax
		mov dword [esp], NULL
		mov dword [esp+4], IDI_APPLICATION
		call [LoadIcon]
		test eax, eax
		jz loadIconError
		mov dword [wcex.hIcon], eax
		mov dword [wcex.hIconSm], eax
		mov dword [esp], NULL
		mov dword [esp+4], IDC_ARROW
		call [LoadCursor]
		mov dword [wcex.hCursor], eax
		mov dword [wcex.hbrBackground], COLOR_WINDOW+1
		mov dword [wcex.lpszClassName], szClass
		mov dword [wcex.lpszMenuName], NULL
		mov	eax, sizeof.WNDCLASSEX
		mov dword [wcex.cbSize], eax
		mov dword [wcex.style], CS_HREDRAW+CS_VREDRAW
		mov dword [wcex.lpfnWndProc], WndProc
		mov dword [wcex.cbClsExtra], 0
		mov dword [wcex.cbWndExtra], 0
		mov dword [esp], wcex
		call [RegisterClassEx]
		test eax, eax
		jz regError

		; Create the window

		sub esp, 48
		mov dword [esp], 0
		mov dword [esp+4], szClass
		mov dword [esp+8], applicationTitle
		mov dword [esp+12], WS_OVERLAPPEDWINDOW
		mov dword [esp+16], CW_USEDEFAULT
		mov dword [esp+20], CW_USEDEFAULT
		mov dword [esp+24], 240
		mov dword [esp+28], 120
		mov dword [esp+32], NULL
		mov dword [esp+36], NULL
		mov dword [esp+40], wcex.hInstance
		mov dword [esp+44], NULL
		call [CreateWindowEx]
		test eax, eax
		jz createError
		mov [windowHandle], eax
	
		; Show the window

		sub esp, 8
		mov eax, [windowHandle]
		mov dword [esp], eax
		mov dword [esp+4], SW_SHOWNORMAL
		call [ShowWindow]

		; Update the window

		sub esp, 4
		mov eax, [windowHandle]
		mov dword [esp], eax
		call [UpdateWindow]

	messageLoop:
		sub esp, 16
		mov dword [esp], msg
		mov dword [esp+4], NULL
		mov dword [esp+8], 0
		mov dword [esp+12], 0
		call [GetMessage]
		test eax, eax
		jz exit
		sub esp, 4
		mov dword [esp], msg
		call [TranslateMessage]
		sub esp, 4
		mov dword [esp], msg
		call [DispatchMessage]
		jmp messageLoop

	loadIconError:
		sub esp, 4
		mov dword [esp], loadIconErrorMessage
		call ErrorMessageBox
		jmp exit

	regError:
		sub esp, 4
		mov dword [esp], registerClassErrorMessage
		call ErrorMessageBox
		jmp exit

    createError:
		sub esp, 4
		mov dword [esp], createWindowErrorMessage
		call ErrorMessageBox
		jmp exit

    exit:
		sub esp, 4
		mov eax, [msg.wParam]
		mov dword [esp], eax
		call [ExitProcess]

    WndProc:
		push ebp
		mov ebp, esp
		sub esp, 16

		cmp dword [ebp+12], WM_CLOSE
		je destroyWindow

		cmp dword [ebp+12], WM_DESTROY
		je postQuitMessage

		mov dword eax, [ebp+8] 
		mov dword [esp], eax
		mov dword eax, [ebp+12]
		mov dword [esp+4], eax
		mov dword eax, [ebp+16]
		mov dword [esp+8], eax
		mov dword eax, [ebp+20]
		mov dword [esp+12], eax
		call [DefWindowProc]
		jmp done

		destroyWindow:
			sub esp, 4
			mov eax, [ebp+8]
			mov dword [esp], eax
			call [DestroyWindow]
			mov dword eax, 0
			jmp done

		postQuitMessage:
			sub esp, 4
			mov dword [esp], 0
			call [PostQuitMessage]
			mov dword eax, 0
			jmp done

		done:
			pop ebp
			ret
	
	ErrorMessageBox:
		; Initialise stack frame
		push ebp
		mov ebp, esp

		; Call the message box
		mov dword [esp], NULL ; hWnd
		mov dword eax, [ebp+8]
		mov dword [esp+4], eax ; lpText
		mov dword eax, [ebp+12]
		mov dword [esp+8], applicationTitle ; lpCaption
		mov dword [esp+12], MB_ICONERROR+MB_OK ; uType
		call [MessageBox]

		; Restore previous stack frame
		pop ebp
		ret
    
section '.data' data readable writeable
    szClass 					db "CrossingMainWindow",0
    applicationTitle 			db "Crossing",0
    szGreeting 					db "Hello, world",0
    registerClassErrorMessage 	db "Call to RegisterClassEx failed",0
    createWindowErrorMessage    db "Call to CreateWindowEx failed",0
    loadIconErrorMessage 		db "Call to LoadIcon failed",0
    windowHandle 				dd	0
    hdc 						dd 0

    wcex 	WNDCLASSEX
    ps 		PAINTSTRUCT
    msg 	MSG

section '.idata' import data readable writeable
    library	kernel32,'KERNEL32.DLL',\
	    user32,'USER32.DLL',\
	    gdi, 'GDI32.DLL'

	import	kernel32,\
		ExitProcess, 'ExitProcess',\
		GetModuleHandle, 'GetModuleHandleA'

	include 'API\user32.inc'

	import gdi,\
		TextOut, 'TextOutA'
