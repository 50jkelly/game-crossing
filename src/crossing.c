#include <windows.h>
#include "windowhelper.h"

const LPSTR APP_NAME = "Crossing";
const int WIDTH = 800;
const int HEIGHT = 600;
HBITMAP ballBitmap = NULL;

LRESULT CALLBACK WindowProcedure(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	switch(msg) {
		case WM_CREATE:
			ballBitmap = LoadBitmap(GetModuleHandle(NULL), MAKEINTRESOURCE(IDB_BALL));
			if (ballBitmap == NULL) {
				MessageBox(hwnd, "Could not load IDB_BALL!", APP_NAME, MB_OK | MB_ICONEXCLAMATION);
			}
			break;
		case WM_PAINT:
			{
				BITMAP bitmap;
				PAINTSTRUCT paintStruct;

				HDC hdc = BeginPaint(hwnd, &paintStruct);
				HDC hdcMem = CreateCompatibleDC(hdc);
				HBITMAP oldBitmap = SelectObject(hdcMem, ballBitmap);

				GetObject(ballBitmap, sizeof(bitmap), &bitmap);
				BitBlt(hdc, 0, 0, bitmap.bmWidth, bitmap.bmHeight, hdcMem, 0, 0, SRCCOPY);

				SelectObject(hdcMem, oldBitmap);
				DeleteDC(hdcMem);
				EndPaint(hwnd, &paintStruct);
			}
			break;
		case WM_CLOSE:
			DestroyWindow(hwnd);
			break;
		case WM_DESTROY:
			DeleteObject(ballBitmap);
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hwnd, msg, wParam, lParam);
	}
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	return CreateMainWindow(APP_NAME, WIDTH, HEIGHT, WindowProcedure, hInstance, nCmdShow);
}
