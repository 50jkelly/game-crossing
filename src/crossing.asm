global go
extern _ExitProcess@4
extern _MessageBoxA@16

section .data
	msg: db 'Hello, Man',0
	caption: db 'Hi',0
	MB_ICON_EXCLAMATION equ 0x00000030
	MB_YESNO equ 0x00000004
	
section .text
	go:
		; Create stack frame
		push ebp
		mov ebp, esp
	
		; MessageBox(0, &msg, &caption, MB_ICON_EXCLAMATION | MB_YESNO)
		push dword MB_ICON_EXCLAMATION | MB_YESNO
		push caption
		push msg
		push 0
		call _MessageBoxA@16
		
		; ExitProcess(0)
		push 0
		call _ExitProcess@4