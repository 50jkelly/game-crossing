; Template for program using standard Win32 headers

format PE GUI 4.0
entry createStackFrame:

include 'win32a.inc'

section '.code' code readable executable
	createStackFrame:
		push ebp
		mov ebp, esp
		sub esp, 4
		jmp initialiseWindow
	
	initialiseWindow:
		mov	eax, sizeof.WNDCLASSEX
		mov	[wcex.cbSize], eax
		mov	[wcex.style], CS_HREDRAW+CS_VREDRAW
		mov	[wcex.lpfnWndProc], WndProc
		mov	[wcex.cbClsExtra], 0
		mov	[wcex.cbWndExtra], 0
		mov	dword [esp], 0
		call GetModuleHandle
		mov	[wcex.hcInstance], eax
		sub esp, 8
		mov	[esp], IDI_APPLICATION
		mov	[esp+4], [wcex.hInstance]
		call LoadIcon
		mov	[wcex.hIcon], eax
		mov	[wcex.hIconSm], eax
		sub esp, 8
		mov	[esp], IDC_ARROW
		mov	[esp+4], NULL
		call LoadCursor
		mov	[wcex.hCursor], eax
		mov	[wcex.hbrBackground], COLOR_WINDOW+1
		mov dword [wcex.lpszClassName], szClass
		mov dword [wcex.lpszMenuName], NULL
		sub esp, 4
		mov [esp], wcex
		call RegisterClassEx
		test eax, eax
		jz regError
		jmp createWindow:
		
	createWindow:
		sub esp, 48
		mov dword [esp], NULL
		mov dword [esp+4], [wcex.hInstance]
		mov dword [esp+8], NULL
		mov dword [esp+12], NULL
		mov dword [esp+16], 120
		mov dword [esp+20], 240
		mov dword [esp+24], CW_USEDEFAULT
		mov dword [esp+28], CW_USEDEFAULT
		mov dword [esp+32], WS_OVERLAPPEDWINDOW
		mov dword [esp+36], applicationTitle
		mov dword [esp+40], szClass
		mov dword [esp+44], 0
		call CreateWindowEx
		test eax, eax
		jz createError
		mov [windowHandle], eax
		jmp showWindow
		
	showWindow:
		sub esp, 8
		mov dword [esp], SW_SHOWNORMAL
		mov dword [esp+4], [windowHandle]
		call ShowWindow
		jmp updateWindow
		
	updateWindow:
		sub esp, 4
		mov dword [esp], [windowHandle]
		call UpdateWindow
		jmp messageLoop
		
	messageLoop:
		sub esp, 16
		mov dword [esp], 0
		mov dword [esp+4], 0
		mov dword [esp+8], NULL
		mov dword [esp+12], msg
		call GetMessage
		test eax, eax
		jz exit
		sub esp 4
		mov dword [esp] msg
		call TranslateMessage
		sub esp 4
		mov dword [esp] msg
		call DispatchMessage
		jmp messageLoop
		
	regError:
		sub esp, 16
		mov dword [esp], MB_ICONERROR+MB_OK
		mov dword [esp+4], applicationTitle,
		mov dword [esp+8], szRegError,
		mov dword [esp+12], NULL
		call MessageBox
		jmp exit
		
	createError:
		sub esp, 16
		mov dword [esp], MB_ICONERROR+MB_OK
		mov dword [esp+4], applicationTitle
		mov dword [esp+8], szCreateError,
		mov dword [esp+12], NULL
		call MessageBox
		jmp exit
		
	exit:
		sub esp, 4
		mov eax, [msg.wParam]
		mov dword [esp], eax
		call ExitProcess
	
	proc WndProc uses ebx esi edi,hwnd,wmsg,wparam,lparam
		cmp [wsmg], WM_CLOSE
	endp

section '.data' data readable writeable
	szClass 		db	"Win32app",0
	applicationTitle db	"Win32 Application",0
	szGreeting		db	"Hello, world!",0
	szRegError		db	"Call to RegisterClassEx failed!",0
	szCreateError	db	"Call to CreateWindowEx failed!",0
	wcex			WNDCLASSEX
	ps				PAINTSTRUCT
	msg				MSG
	windowHandle	dd	0
	hdc				dd	0

section '.idata' import data readable writeable
  library	kernel32,'KERNEL32.DLL',\
			user32,'USER32.DLL',\
			gdi, 'GDI32.DLL'
  
  import	kernel32,\
			ExitProcess, 'ExitProcess',\
			GetModuleHandle, 'GetModuleHandle'
			
  import	user32,\
			RegisterClassEx, 'RegisterClassExA',\
			CreateWindowEx, 'CreateWindowExA',\
			ShowWindow, 'ShowWindow',\
			UpdateWindow, 'UpdateWindow',\
			GetMessage, 'GetMessageA',\
			TranslateMessage, 'TranslateMessage',\
			DispatchMessage, 'DispatchMessageA',\
			MessageBox, 'MessageBoxA',\
			DefWindowProc, 'DefWindowProcA',\
			BeginPaint, 'BeginPaint',\
			EndPaint, 'EndPaint',\
			PostQuitMessage, 'PostQuitMessage',\
			LoadIcon, 'LoadIconA',\
			LoadCursor, 'LoadCursorA'
			
	import gdi,\
			TextOut, 'TextOutA'
