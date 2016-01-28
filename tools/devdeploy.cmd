@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\devdeploy\devdeploy" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\devdeploy\devdeploy" %*
)