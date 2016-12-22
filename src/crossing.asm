format PE GUI 4.0
entry start

include 'win32a.inc'

section '.code' code readable executable
	include 'code/message-box.asm'
	include 'code/window.asm'
	
	start:
		; Initialise the stack frame

		push ebp
		mov ebp, esp
		
		; Initialise the main window

		sub esp, 16
		mov dword [esp], IDI_APPLICATION
		mov dword [esp+4], IDC_ARROW
		mov dword [esp+8], mainWindowClass
		mov dword [esp+12], WndProc
		call InitialiseWindow
		
		; Create and show the main window
		
		call NewWindow

		; All done, exit with return code 0
		
		sub esp, 4
		mov dword [esp], 0
		call [ExitProcess]
    
section '.data' data readable writeable
	include 'data/message-box.asm'
	include 'data/window.asm'

section '.idata' import data readable writeable
    include 'data/imports.asm'
