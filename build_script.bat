%echo off
nasm -f win64 test_array_vector/test_array_with_N_C.asm -o p2R.obj
cl.exe p2R.obj /subsystem:console /link /OUT:p2R.exe /libpath:"E:\Microsoft Visual Studio\2022\Preview\VC\Tools\MSVC\14.44.35207\lib\x64" kernel32.lib legacy_stdio_definitions.lib msvcrt.lib /MACHINE:X64 /LARGEADDRESSAWARE:NO >nul 2>&1
if errorlevel 1 (
    echo -----------------------------------------------
    echo [NASM BUILD WITH CL STATUS]: BUILD FAILED!!!!!
    echo -----------------------------------------------
) else (
    echo -----------------------------------------------
    echo [NASM X64 BUILD RETURN] BUILD SUCCESS!!!
    echo -----------------------------------------------
)