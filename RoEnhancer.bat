@echo off
color 8f
title RoEnhancer - Quality Of Life Roblox Script!
mode 60,15
set d=%temp%\RoEnhancer
md %d% 2>nul >nul
cd %d%
set c=ClientAppSettings.json
echo Fetching latest RoEnhancer..
bitsadmin /transfer RoEnhancer /download /priority high /dynamic https://raw.githubusercontent.com/xf1op/RoEnhancer/refs/heads/main/code.txt %d%\code.bat >nul
start /b %d%\code.bat & exit
