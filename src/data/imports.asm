library	kernel32,'KERNEL32.DLL',\
	user32,'USER32.DLL'

import kernel32,\
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
	MessageBoxA,'MessageBoxA',\
	AdjustWindowRectEx, 'AdjustWindowRectEx'