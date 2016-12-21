format PE GUI 4.0
entry start

include 'win32a.inc'

section '.code' code readable executable
	include 'message-box.code'
	include 'window.code'

		NewWindow:

			push ebp
			mov ebp, esp

			; Create the window

			sub esp, 48
			mov dword [esp], 0
			mov dword [esp+4], mainWindowClass
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
			call [CreateWindowExA]
			test eax, eax
			jz createError
			mov [windowHandle], eax
		
			; Show the window

			sub esp, 8
			mov eax, [windowHandle]
			mov dword [esp], eax
			mov dword [esp+4], SW_SHOWNORMAL
			call [ShowWindow]

		messageLoop:
			sub esp, 16
			mov dword [esp], msg
			mov eax, [windowHandle]
			mov dword [esp+4], NULL
			mov dword [esp+8], 0
			mov dword [esp+12], 0
			call [GetMessageA]
			cmp eax, 0
			je exit
			sub esp, 4
			mov dword [esp], msg
			call [TranslateMessage]
			sub esp, 4
			mov dword [esp], msg
			call [DispatchMessageA]
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
			pop ebp
			mov eax, [msg.wParam]
			ret

    WndProc:
		push ebp
		mov ebp, esp

		mov eax, [ebp+12]
		cmp eax, WM_DESTROY
		je destroy

		sub esp, 16
		mov dword eax, [ebp+8] 
		mov dword [esp], eax
		mov dword eax, [ebp+12]
		mov dword [esp+4], eax
		mov dword eax, [ebp+16]
		mov dword [esp+8], eax
		mov dword eax, [ebp+20]
		mov dword [esp+12], eax
		call [DefWindowProcA]
		jmp done

		destroy:
			sub esp, 4
			mov dword [esp], 0
			call [PostQuitMessage]
			mov eax, 0
		done:
			pop ebp
			ret
	

	start:
		; Initialise the stack frame

		push ebp
		mov ebp, esp

		sub esp, 16
		mov dword [esp], IDI_APPLICATION
		mov dword [esp+4], IDC_ARROW
		mov dword [esp+8], mainWindowClass
		mov dword [esp+12], WndProc
		call InitialiseWindow
		call NewWindow
		call NewWindow

		sub esp, 4
		mov dword [esp], 0
		call [ExitProcess]

    
section '.data' data readable writeable
    mainWindowClass				db "CrossingMainWindow",0
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

	import user32,\
		LoadIconA, 'LoadIconA',\
		LoadCursorA, 'LoadCursorA',\
		RegisterClassExA, 'RegisterClassExA',\
		CreateWindowExA, 'CreateWindowExA',\
		ShowWindow, 'ShowWindow',\
		GetMessageA, 'GetMessageA',\
		TranslateMessage, 'TranslateMessage',\
		DispatchMessageA,'DispatchMessageA',\
		DefWindowProcA,'DefWindowProcA',\
		PostQuitMessage,'PostQuitMessage',\
		MessageBoxA,'MessageBoxA'

	import gdi,\
		TextOut, 'TextOutA'
