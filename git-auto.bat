@echo off
setlocal enabledelayedexpansion

set "remote=origin"

echo === Git Auto Commit and Push ===
echo.

git rev-parse --git-dir >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Not a git repository.
    pause
    exit /b 1
)

echo Current status:
git status -s
echo.

set /p confirm="Continue commit and push? (y/n) "
if /i not "!confirm!"=="y" (
    echo Cancelled.
    pause
    exit /b 0
)

set "commit_msg=%~1"
if "!commit_msg!"=="" (
    set /p commit_msg="Enter commit message: "
    if "!commit_msg!"=="" (
        echo Commit message cannot be empty.
        pause
        exit /b 1
    )
)

echo.
echo Adding changes...
git add -A
if %errorlevel% neq 0 (
    echo git add failed.
    pause
    exit /b 1
)

echo Committing...
git commit -m "!commit_msg!"
if %errorlevel% neq 0 (
    echo git commit failed (maybe nothing to commit?).
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('git branch --show-current') do set "branch=%%i"
if "!branch!"=="" (
    echo Cannot determine current branch.
    pause
    exit /b 1
)

echo Pushing to %remote%/%branch% ...
git push %remote% %branch%
if %errorlevel% neq 0 (
    echo git push failed.
    pause
    exit /b 1
)

echo.
echo === Success! ===
pause
exit /b 0