@echo off
"%~dp0\..\bootstrap\node.bat" --openssl-legacy-provider --experimental-modules "%~dp0\build.js" %*
