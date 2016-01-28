@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\taggen\taggen" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\taggen\taggen" %*
)