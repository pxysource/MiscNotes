@REM ConvertDecimalToHexString.bat Test
@echo off
SETLOCAL

call ConvertDecimalToHexString.bat 1000
echo 1000=%CrtDecToHexStrRtnValue%

call ConvertDecimalToHexString.bat 100
echo 100=%CrtDecToHexStrRtnValue%

call ConvertDecimalToHexString.bat 256
echo 256=%CrtDecToHexStrRtnValue%

call ConvertDecimalToHexString.bat 64
echo 64=%CrtDecToHexStrRtnValue%

ENDLOCAL