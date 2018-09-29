@echo off

set vlcpath=%appdata%\vlc

if not exist %vlcpath% (
  @echo on
  echo %vlcpath% could not be found
  exit /b
)

set extpath=%vlcpath%\lua\extensions

if not exist %extpath% (
  mkdir %extpath%
  @echo on
  echo Creating directory %extpath%
  @echo off
)

set targetpath=%extpath%\chapter_skipper.lua

if exist %targetpath% (
  @echo on
  echo Updating extension...
  @echo off
)

if not exist %targetpath% (
  @echo on
  echo Installing extension...
  @echo off
)

copy chapter_skipper.lua %extpath%