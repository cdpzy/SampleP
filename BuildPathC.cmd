@echo off
@rem 点击后根据配置文件生成鱼路径文件

rmdir /s /q genPoint
mkdir genPoint
lua.exe main.lua

