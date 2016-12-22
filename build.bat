nasm -f win32 src\crossing.asm -o lib\crossing.obj

ld -e go -o bin\crossing.exe ^
lib\crossing.obj ^
-l kernel32 ^
-l user32