#include <windows.h>

boolean RegisterWindowClass(char* className, HINSTANCE hInstance, WNDPROC windowProcedure) {
	WNDCLASSEX wc;
	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = 0;
	wc.lpfnWndProc = windowProcedure;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hInstance;
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hIconSm = LoadIcon(NULL, IDI_APPLICATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = className;

	if (! RegisterClassEx(&wc)) {
		MessageBox(NULL, "Window registration failed.", "Error", MB_ICONEXCLAMATION | MB_OK);
		return 0;
	}
	return 1;
}

HWND CreateAndShowWindow(char* className, char* windowName, int width, int height, HINSTANCE hInstance) {
	HWND hwnd = CreateWindowEx(
			WS_EX_CLIENTEDGE,
			className,
			windowName,
			WS_OVERLAPPEDWINDOW,
			CW_USEDEFAULT,
			CW_USEDEFAULT,
			width,
			height,
			NULL,
			NULL,
			hInstance,
			NULL);

	if (hwnd == NULL) {
		MessageBox(NULL, "Window creation failed.", "Error", MB_ICONEXCLAMATION | MB_OK);
		return NULL;
	}
}

int StartMessageLoop() {
	MSG msg;
	while (GetMessage(&msg, NULL, 0, 0) > 0) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	return msg.wParam;
}

boolean CreateMainWindow(
		char* APP_NAME,
		int WIDTH,
		int HEIGHT,
		WNDPROC windowProcedure,
		HINSTANCE hInstance,
		int nCmdShow) {
	if (! RegisterWindowClass(APP_NAME, hInstance, windowProcedure)) return 1;

	HWND hwnd = CreateAndShowWindow(APP_NAME, APP_NAME, WIDTH, HEIGHT, hInstance);
	if (hwnd == NULL) return 1;

	ShowWindow(hwnd, nCmdShow);
	UpdateWindow(hwnd);
	StartMessageLoop();
}
