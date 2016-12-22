; void InitialiseWindow(dword icon, dword cursor, string* className, dword windowsProcedure)

InitialiseWindow:

	; Initialise the stack frame

	push ebp
	mov ebp, esp

	; Initialise the window

	sub esp, 4
	mov dword [esp], NULL
	call [GetModuleHandle]
	mov dword [wcex.hInstance], eax

	sub esp, 8
	mov dword [esp], NULL
	mov eax, [ebp+8]
	mov dword [esp+4], eax
	call [LoadIconA]
	test eax, eax
	jz loadIconError
	mov dword [wcex.hIcon], eax
	mov dword [wcex.hIconSm], eax

	sub esp, 8
	mov dword [esp], NULL
	mov eax, [ebp+12]
	mov dword [esp+4], eax
	call [LoadCursorA]
	mov dword [wcex.hCursor], eax

	mov dword [wcex.hbrBackground], COLOR_WINDOW+1
	mov eax, [ebp+16]
	mov dword [wcex.lpszClassName], eax
	mov dword [wcex.lpszMenuName], NULL
	mov	eax, sizeof.WNDCLASSEX
	mov dword [wcex.cbSize], eax
	mov dword [wcex.style], CS_HREDRAW+CS_VREDRAW
	mov eax, [ebp+20]
	mov dword [wcex.lpfnWndProc], eax
	mov dword [wcex.cbClsExtra], 0
	mov dword [wcex.cbWndExtra], 0

	sub esp, 4
	mov dword [esp], wcex
	call [RegisterClassExA]
	test eax, eax
	jz regError

	pop ebp
	ret 16
	
; int NewWindow()

NewWindow:

		push ebp
		mov ebp, esp
		
		; Calculate window size
		
		mov dword [rect.left], 0
		mov dword [rect.top], 0
		mov dword eax, [windowWidth]
		mov dword [rect.right], eax
		mov dword eax, [windowHeight]
		mov dword [rect.bottom], eax
		sub esp, 16
		mov dword [esp], rect
		mov dword [esp+4], WS_OVERLAPPEDWINDOW
		mov dword [esp+8], 0
		mov dword [esp+12], WS_EX_OVERLAPPEDWINDOW
		call [AdjustWindowRectEx]
		
		; Calculate window width
		
		mov dword eax, [rect.right]
		sub eax, [rect.left]
		mov dword [calculatedWindowWidth], eax
		
		; Calculate window height
		
		mov dword eax, [rect.bottom]
		sub eax, [rect.top]
		mov dword [calculatedWindowHeight], eax
		
		; Create the window

		sub esp, 48
		mov dword [esp], WS_EX_OVERLAPPEDWINDOW
		mov dword [esp+4], mainWindowClass
		mov dword [esp+8], applicationTitle
		mov dword [esp+12], WS_OVERLAPPEDWINDOW
		mov dword [esp+16], CW_USEDEFAULT
		mov dword [esp+20], CW_USEDEFAULT
		mov dword eax, [calculatedWindowWidth]
		mov dword [esp+24], eax
		mov dword eax, [calculatedWindowHeight]
		mov dword [esp+28], eax
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
		
; int WndProc()
		
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
