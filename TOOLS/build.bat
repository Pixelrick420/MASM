@echo off
cls
masm ASM\%1.asm;
if exist %1.obj copy %1.obj OBJ\
if exist %1.obj del %1.obj
link OBJ\%1.obj;
if exist %1.exe copy %1.exe EXE\
if exist %1.exe del %1.exe
echo.
echo Build complete: EXE\%1.exe
echo.
pause
EXE\%1.exe
