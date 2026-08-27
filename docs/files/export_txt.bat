@echo off
setlocal EnableExtensions EnableDelayedExpansion

title MUGEN - Exportador de archivos

echo ============================================================
echo              EXPORTADOR DE ARCHIVOS MUGEN
echo ============================================================
echo.


:: ============================================================
:: CARPETA DE SALIDA
:: Es la carpeta donde esta este BAT:
::
:: docs\files\
:: ============================================================

for %%I in ("%~dp0.") do set "OUT=%%~fI"


:: ============================================================
:: BUSCAR AUTOMATICAMENTE LA CARPETA *_Char
:: ============================================================

set "SEARCH=%OUT%"
set "ROOT="


:FindRoot

:: Verificar si la carpeta actual termina en _Char
for %%I in ("!SEARCH!") do set "FOLDER_NAME=%%~nxI"

if /I "!FOLDER_NAME:~-5!"=="_Char" (
    set "ROOT=!SEARCH!"
    goto RootFound
)


:: Buscar una carpeta hija terminada en _Char
set "FOUND_COUNT=0"
set "FOUND_CHAR="

for /D %%D in ("!SEARCH!\*_Char") do (
    set /a FOUND_COUNT+=1
    set "FOUND_CHAR=%%~fD"
)


:: Si encontramos exactamente una
if !FOUND_COUNT! EQU 1 (
    set "ROOT=!FOUND_CHAR!"
    goto RootFound
)


:: Si encontramos varias
if !FOUND_COUNT! GTR 1 (
    echo ERROR:
    echo Se encontraron varias carpetas *_Char dentro de:
    echo.
    echo   !SEARCH!
    echo.
    echo Carpetas encontradas:
    echo.

    for /D %%D in ("!SEARCH!\*_Char") do (
        echo   %%~nxD
    )

    echo.
    echo No se puede determinar automaticamente cual exportar.
    echo.
    pause
    exit /b 1
)


:: Subir un nivel
for %%I in ("!SEARCH!\..") do set "PARENT=%%~fI"


:: Llegamos a la raiz del disco
if /I "!PARENT!"=="!SEARCH!" goto RootNotFound


set "SEARCH=!PARENT!"
goto FindRoot



:: ============================================================
:: ERROR
:: ============================================================

:RootNotFound

echo ERROR:
echo No se encontro ninguna carpeta que termine en "_Char".
echo.
echo Busqueda iniciada desde:
echo.
echo   %OUT%
echo.
pause
exit /b 1



:: ============================================================
:: ROOT ENCONTRADO
:: ============================================================

:RootFound

echo Char detectado:
echo.
echo   %ROOT%
echo.

echo Carpeta de salida:
echo.
echo   %OUT%
echo.



:: ============================================================
:: LIMPIAR EXPORTACIONES ANTERIORES
:: ============================================================

echo ============================================================
echo LIMPIANDO ARCHIVOS TXT ANTERIORES
echo ============================================================
echo.

del /q "%OUT%\*.def.txt" 2>nul
del /q "%OUT%\*.air.txt" 2>nul
del /q "%OUT%\*.cmd.txt" 2>nul
del /q "%OUT%\*.cns.txt" 2>nul
del /q "%OUT%\*.st.txt"  2>nul
del /q "%OUT%\structure.txt" 2>nul

echo Limpieza completada.
echo.



:: ============================================================
:: GENERAR STRUCTURE.TXT
:: ============================================================

echo ============================================================
echo GENERANDO STRUCTURE.TXT
echo ============================================================
echo.

set "TMP_STRUCTURE=%TEMP%\mugen_structure_%RANDOM%_%RANDOM%.txt"

(
    echo ============================================================
    echo MUGEN CHARACTER STRUCTURE
    echo ============================================================
    echo.
    echo Proyecto:
    echo %ROOT%
    echo.
    echo Generado:
    echo %DATE% %TIME%
    echo.
    echo ============================================================
    echo.
) > "%TMP_STRUCTURE%"

tree "%ROOT%" /F /A >> "%TMP_STRUCTURE%"

move /y "%TMP_STRUCTURE%" "%OUT%\structure.txt" >nul

echo structure.txt creado.
echo.



:: ============================================================
:: EXPORTAR ARCHIVOS
::
:: Busca de manera RECURSIVA:
::
:: *.def
:: *.air
:: *.cmd
:: *.cns
:: *.st
::
:: Y genera:
::
:: archivo.def.txt
:: archivo.air.txt
:: archivo.cmd.txt
:: archivo.cns.txt
:: archivo.st.txt
:: ============================================================

echo ============================================================
echo EXPORTANDO ARCHIVOS DEL CHAR
echo ============================================================
echo.

set /a COUNT=0


:: ------------------------------------------------------------
:: DEF
:: ------------------------------------------------------------

for /R "%ROOT%" %%F in (*.def) do (
    echo   %%~nxF  ^>  %%~nxF.txt
    copy /y "%%~fF" "%OUT%\%%~nxF.txt" >nul
    set /a COUNT+=1
)


:: ------------------------------------------------------------
:: AIR
:: ------------------------------------------------------------

for /R "%ROOT%" %%F in (*.air) do (
    echo   %%~nxF  ^>  %%~nxF.txt
    copy /y "%%~fF" "%OUT%\%%~nxF.txt" >nul
    set /a COUNT+=1
)


:: ------------------------------------------------------------
:: CMD
:: ------------------------------------------------------------

for /R "%ROOT%" %%F in (*.cmd) do (
    echo   %%~nxF  ^>  %%~nxF.txt
    copy /y "%%~fF" "%OUT%\%%~nxF.txt" >nul
    set /a COUNT+=1
)


:: ------------------------------------------------------------
:: CNS
:: ------------------------------------------------------------

for /R "%ROOT%" %%F in (*.cns) do (
    echo   %%~nxF  ^>  %%~nxF.txt
    copy /y "%%~fF" "%OUT%\%%~nxF.txt" >nul
    set /a COUNT+=1
)


:: ------------------------------------------------------------
:: ST
:: ------------------------------------------------------------

for /R "%ROOT%" %%F in (*.st) do (
    echo   %%~nxF  ^>  %%~nxF.txt
    copy /y "%%~fF" "%OUT%\%%~nxF.txt" >nul
    set /a COUNT+=1
)



:: ============================================================
:: RESULTADO
:: ============================================================

echo.
echo ============================================================
echo                 EXPORTACION COMPLETADA
echo ============================================================
echo.

echo Char:
echo   %ROOT%
echo.

echo Archivos convertidos a TXT:
echo   %COUNT%
echo.

echo Carpeta:
echo   %OUT%
echo.

echo Tambien se genero:
echo   structure.txt
echo.

pause

endlocal