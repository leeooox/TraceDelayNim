@echo off
%NIMPATH%\dist\mingw64\bin\windres -O coff wNim.rc -o wNim64.res
%NIMPATH%\dist\mingw64\bin\windres -O coff wNimTcc.rc -o wNimTcc64.res
