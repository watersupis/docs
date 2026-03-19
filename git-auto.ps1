param(
    [string]$commitMessage = ""
)

# 日志设置
$logDir = "log"
if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
$logFile = Join-Path $logDir ("git-auto_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".log")

# 启动转录，记录所有输出
Start-Transcript -Path $logFile -Append

Write-Host "=== Git 自动提交与推送脚本 ==="
Write-Host ""

# 检查 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "错误：当前目录不是一个 Git 仓库！"
    pause
    exit 1
}

# 显示状态
Write-Host "当前仓库状态："
git status -s
Write-Host ""

# 确认
$confirm = Read-Host "是否继续提交并推送？(y/n) "
if ($confirm -ne "y") {
    Write-Host "操作已取消。"
    pause
    exit 0
}

# 获取提交信息
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = Read-Host "请输入提交信息"
    if ([string]::IsNullOrWhiteSpace($commitMessage)) {
        Write-Host "提交信息不能为空，操作取消。"
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "正在添加更改..."
git add -A
if ($LASTEXITCODE -ne 0) {
    Write-Host "git add 失败，请检查。"
    pause
    exit 1
}

Write-Host "正在提交..."
git commit -m $commitMessage   # PowerShell 会自动正确处理引号
if ($LASTEXITCODE -ne 0) {
    Write-Host "git commit 失败（可能没有需要提交的更改？）。"
    pause
    exit 1
}

# 获取当前分支
$branch = git branch --show-current
if ([string]::IsNullOrEmpty($branch)) {
    Write-Host "无法获取当前分支，请手动推送。"
    pause
    exit 1
}

Write-Host "正在推送到 origin/$branch ..."
git push origin $branch
if ($LASTEXITCODE -ne 0) {
    Write-Host "git push 失败，请检查网络或权限。"
    pause
    exit 1
}

Write-Host ""
Write-Host "=== 操作成功完成！==="

Stop-Transcript
pause