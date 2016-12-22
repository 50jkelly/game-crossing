; void ErrorMessageBox(string* message)
ErrorMessageBox:

	; Initialise stack frame
	push ebp
	mov ebp, esp

	; Call the message box
	sub esp, 16
	mov dword [esp], NULL ; hWnd
	mov dword eax, [ebp+8]
	mov dword [esp+4], eax
	mov dword [esp+8], applicationTitle
	mov dword [esp+12], MB_ICONERROR+MB_OK ; uType
	call [MessageBoxA]

	; Restore previous stack frame
	pop ebp
	ret 4
