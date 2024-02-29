@echo off

:: Function to copy contents from source to destination

:CopyContents

:: Loop for the source directory input

:SourceLoop

echo Enter the source directory:

set /p SourceDir=

if not exist "%SourceDir%\" (

    echo The source directory "%SourceDir%" does not exist, please try again.

    goto SourceLoop

)


:: Loop for the destination directory input

:DestLoop

echo Enter the destination directory:

set /p DestDir=

if not exist "%DestDir%\" (

    echo The destination directory "%DestDir%" does not exist, please try again.

    goto DestLoop

)

echo Copying contents from "%SourceDir%" to "%DestDir%"...

ROBOCOPY "%SourceDir%" "%DestDir%" /E

if %ERRORLEVEL% LEQ 1 (

    echo Copy operation completed successfully.

) else (

    echo An error occurred during the copy operation.

)

goto :eof
:: Call the function

call :CopyContents




:: In a real world scenario, the optimal destination for a backup is anywhere but the same machine you are on! especially the same drive!

