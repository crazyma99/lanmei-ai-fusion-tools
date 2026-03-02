@echo off
setlocal enabledelayedexpansion

:: 设置 UTF-8 编码，避免中文乱码
chcp 65001 >nul

:: 获取脚本所在目录并切换
cd /d "%~dp0"

set PORT=7860
echo 正在检查端口 %PORT%...

:: 查找占用端口的 PID 并终止进程
for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%PORT% "') do (
    if "%%a" neq "0" (
        echo 发现端口 %PORT% 被进程 PID: %%a 占用，正在终止...
        taskkill /F /PID %%a >nul 2>&1
        if !errorlevel! equ 0 (
            echo 进程已终止。
        ) else (
            echo 无法终止进程，可能需要管理员权限。
        )
    )
)

:: 激活虚拟环境
if exist "venv\Scripts\activate.bat" (
    echo 正在激活虚拟环境...
    call venv\Scripts\activate.bat
) else (
    echo 未找到 venv\Scripts\activate.bat，将尝试直接使用系统 python...
)

:: 启动服务
echo 正在启动 Photo Fusion 服务...
python fusion-tools/app.py

pause
