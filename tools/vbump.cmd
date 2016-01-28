@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\vbump\vbump" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\vbump\vbump" %*
)