@echo off

REM Ensure VLC directory exists
set vlcpath=%appdata%\vlc

if not exist %vlcpath% (
  @echo on
  echo %vlcpath% could not be found
  exit /b
)

REM Ensure directory exists
set extpath=%vlcpath%\lua\extensions

if not exist %extpath% (
  mkdir %extpath%
  @echo on
  echo Creating directory %extpath%
  @echo off
)

REM Show changes
set mainpath=%extpath%\chapter_skipper.lua
if exist %mainpath% (
  @echo on
  echo Updating extension...
  @echo off
)

if not exist %mainpath% (
  @echo on
  echo Installing extension...
  @echo off
)

REM Copy extension and configuration
copy *.lua %extpath%