@echo off
setlocal

echo ==========================
echo EXPORTANDO ARCHIVOS MUGEN
echo ==========================

:: Carpeta raíz del personaje
set ROOT=../Raziel_Char

:: Eliminar exportaciones anteriores
del /q "*.def.txt" 2>nul
del /q "*.air.txt" 2>nul
del /q "*.cmd.txt" 2>nul
del /q "*.cns.txt" 2>nul
del /q "*.st.txt" 2>nul

:: DEF
for %%F in ("%ROOT%\*.def") do (
    copy /y "%%F" "%%~nxF.txt" >nul
)

:: AIR
for %%F in ("%ROOT%\assets\*.air") do (
    copy /y "%%F" "%%~nxF.txt" >nul
)

:: CMD
for %%F in ("%ROOT%\logic\*.cmd") do (
    copy /y "%%F" "%%~nxF.txt" >nul
)

:: CNS
for %%F in ("%ROOT%\logic\*.cns") do (
    copy /y "%%F" "%%~nxF.txt" >nul
)

:: ST
for %%F in ("%ROOT%\logic\*.st") do (
    copy /y "%%F" "%%~nxF.txt" >nul
)

echo.
echo Exportacion completada.
pause