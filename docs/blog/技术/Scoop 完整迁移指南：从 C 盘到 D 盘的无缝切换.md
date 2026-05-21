---
title: Scoop 完整迁移指南：从 C 盘到 D 盘的无缝切换
source: https://blog.csdn.net/u014451778/article/details/158315063
author:
  - '[[u014451778]]'
published: 2026-02-23T00:00:00.000Z
created: 2026-05-08T00:00:00.000Z
description: >-
  文章浏览阅读1.2k次，点赞26次，收藏9次。本文提供了完整的Scoop包管理器从C盘迁移到D盘的详细指南。主要内容包括：1）迁移前准备，导出软件清单和备份配置数据；2）彻底卸载C盘Scoop并清理环境变量；3）在D盘重新安装并配置Scoop；4）恢复软件和数据；5）迁移后优化配置。指南特别强调备份persist目录、彻底清理旧安装、预置安装路径等关键步骤，并提供了验证方法和常见问题解决方案。通过遵循本指南，用户可实现Scoop的无缝迁移，解决C盘空间不足问题，同时保留所有软件和配置。_scoop
  迁移
tags:
  - clippings
createTime: 2026/05/08 12:50:00
permalink: /blog/kadz1p50/
---
### 前言

随着软件越装越多，C 盘空间告急？本文将指导你如何 **完整迁移 Scoop** 到 D 盘，包括卸载旧版本、重新安装、快速恢复软件，以及处理环境变量和路径问题。

> [Windows 多 Git 环境冲突：一个环境变量优先级引发的血案](https://mp.csdn.net/mp_blog/creation/editor/158314199 "Windows 多 Git 环境冲突：一个环境变量优先级引发的血案")

> [Scoop 完全配置指南：打造高效的 Windows 软件管理环境](https://mp.csdn.net/mp_blog/creation/editor/158314831 "Scoop 完全配置指南：打造高效的 Windows 软件管理环境")

### 一、迁移前准备

#### 1.1 导出当前软件清单

```coffeescript
# 导出已安装软件列表（含版本和 bucket 信息）

scoop export > D:\scoop-backup.json

 

# 查看导出内容

Get-Content D:\scoop-backup.json | Select-Object -First 20
```

#### 1.2 备份持久化 数据

Scoop 的 `persist` 目录存放软件 配置 和数据，务必备份：

```php
# 备份 persist 目录

Copy-Item -Path "$env:USERPROFILE\scoop\persist" -Destination "D:\scoop-persist-backup" -Recurse -Force

 

# 或压缩备份

Compress-Archive -Path "$env:USERPROFILE\scoop\persist" -DestinationPath "D:\scoop-persist-backup.zip"
```

#### 1.3 记录自定义配置

```csharp
# 导出 scoop 配置

scoop config > D:\scoop-config-backup.txt

 

# 查看 bucket 列表

scoop bucket list > D:\scoop-buckets-backup.txt
```

### 二、卸载 C 盘 Scoop

#### 2.1 标准 卸载流程

```bash
# 1. 先尝试 scoop 自身卸载（如果还能运行）

scoop uninstall scoop

 

# 2. 强制删除 scoop 目录（无论上面是否成功）

$oldScoopPath = "$env:USERPROFILE\scoop"

if (Test-Path $oldScoopPath) {

    # 获取所有权并强制删除

    takeown /F $oldScoopPath /R /D Y 2>$null

    icacls $oldScoopPath /grant "$env:USERNAME\`:F" /T 2>$null

    

    # 使用 CMD 强制删除（绕过 PowerShell 限制）

    cmd /c "rmdir /s /q $oldScoopPath"

    

    if (Test-Path $oldScoopPath) {

        Write-Host "❌ 删除失败，请重启后手动删除: $oldScoopPath" -ForegroundColor Red

        return

    } else {

        Write-Host "✅ 旧 Scoop 目录已删除" -ForegroundColor Green

    }

}
```

![](https://i-blog.csdnimg.cn/direct/290aaf06766a4cfa803053c5d39c124b.png)

#### 2.2 清理环境变量

```perl
# 清理用户环境变量

[Environment]::SetEnvironmentVariable('SCOOP', $null, 'User')

[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $null, 'Machine')

 

# 清理 Path 中的 scoop 路径

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')

$cleanUserPath = ($userPath -split ';' | Where-Object { 

    $_ -notlike '*\scoop*' -and 

    $_ -notlike '*\shims*' 

}) -join ';'

[Environment]::SetEnvironmentVariable('Path', $cleanUserPath, 'User')

 

# 清理 PowerShell 配置文件中的 scoop 引用

$profiles = @(

    $PROFILE.CurrentUserCurrentHost,

    $PROFILE.CurrentUserAllHosts

) | Select-Object -Unique

 

foreach ($profilePath in $profiles) {

    if ($profilePath -and (Test-Path $profilePath)) {

        $content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue

        if ($content -match 'scoop') {

            $newContent = $content -split "\`r?\`n" | Where-Object { $_ -notmatch 'scoop' } | Join-String -Separator "\`n"

            Set-Content -Path $profilePath -Value $newContent -Force

        }

    }

}

 

# 重新加载环境变量

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User") + ";" + [System.Environment]::GetEnvironmentVariable("Path","Machine")

Remove-Item env:SCOOP -ErrorAction SilentlyContinue

 

Write-Host "✅ 环境变量清理完成" -ForegroundColor Green
```

![](https://i-blog.csdnimg.cn/direct/4b0e684236384b5da9e2f01b9618242b.png)

#### 2.3 验证卸载彻底

```php
# 检查残留

$checks = @(

    (Test-Path "$env:USERPROFILE\scoop"),

    (Get-Command scoop -ErrorAction SilentlyContinue),

    ([Environment]::GetEnvironmentVariable('SCOOP', 'User'))

)

 

if ($checks -contains $true) {

    Write-Host "⚠️ 仍有残留，请手动清理" -ForegroundColor Red

} else {

    Write-Host "✅ 卸载彻底，可以重新安装了" -ForegroundColor Green

}
```

![](https://i-blog.csdnimg.cn/direct/4b566bfe8f1f49edb09f1eddf0cf0ff3.png)

### 三、安装到 D 盘

#### 3.1 设置自定义路径

```ruby
# 设置 Scoop 安装路径（必须在安装前设置）

$env:SCOOP = 'D:\Scoop'

[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'User')

 

# 可选：设置全局安装路径

$env:SCOOP_GLOBAL = 'D:\ScoopGlobal'

[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')

 

# 验证设置

Write-Host "SCOOP: $env:SCOOP" -ForegroundColor Cyan

Write-Host "SCOOP_GLOBAL: $env:SCOOP_GLOBAL" -ForegroundColor Cyan
```

#### 3.2 执行安装

```coffeescript
# 设置执行策略

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

 

# 安装 Scoop（会自动使用 $env:SCOOP 路径）

Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

 

# 验证安装位置

scoop config | Select-String "root_path"

Get-Command scoop | Select-Object Source
```

#### 3.3 安装后验证

```perl
# 检查安装路径

scoop --version

scoop checkup

 

# 查看环境变量

[Environment]::GetEnvironmentVariable('SCOOP', 'User')

$env:PATH -split ';' | Select-String 'scoop'
```

![](https://i-blog.csdnimg.cn/direct/865194f3691e4c3aae6c1906960feb75.png)

### 四、恢复软件和数据

#### 4.1 恢复 Bucket

```perl
# 从备份恢复 bucket

$buckets = Get-Content D:\scoop-buckets-backup.txt | ForEach-Object {

    if ($_ -match '(\w+)\s+(\S+)') {

2

    }

}

 

foreach ($bucket in $buckets) {

    if ($bucket.Name -ne 'main') {  # main 已默认添加

        scoop bucket add $bucket.Name $bucket.Source

    }

}
```

#### 4.2 批量恢复软件

```puppet
# 从 JSON 导入（推荐）

scoop import D:\scoop-backup.json

 

# 或从列表手动安装（如果 JSON 导入失败）

$apps = Get-Content D:\scoop-backup.json | ConvertFrom-Json

$apps | ForEach-Object {

    Write-Host "Installing $($_.Name)..." -ForegroundColor Cyan

    scoop install $_.Name

}
```

#### 4.3 恢复持久化数据

```puppet
# 恢复 persist 数据

$persistBackup = "D:\scoop-persist-backup"

$persistTarget = "$env:SCOOP\persist"

 

if (Test-Path $persistBackup) {

    # 合并备份数据到新安装

    Get-ChildItem $persistBackup | ForEach-Object {

        $targetPath = Join-Path $persistTarget $_.Name

        if (Test-Path $targetPath) {

            # 备份新安装的空配置

            Rename-Item $targetPath "$targetPath.new"

            # 复制旧配置

            Copy-Item $_.FullName $targetPath -Recurse -Force

            Write-Host "✅ 恢复: $($_.Name)" -ForegroundColor Green

        }

    }

}
```

### 五、迁移后优化

#### 5.1 配置下载加速

```cobol
# 安装并配置 aria2

scoop install aria2

true

16

16

1
```

#### 5.2 设置“网络”（如需要）

```ruby
# 临时 daili

$env:HTTP_PROXY = "http://127.0.0.1:7897"

$env:HTTPS_PROXY = "http://127.0.0.1:7897"

 

# 永久 daili（可选）

[Environment]::SetEnvironmentVariable('HTTP_PROXY', 'http://127.0.0.1:7897', 'User')

[Environment]::SetEnvironmentVariable('HTTPS_PROXY', 'http://127.0.0.1:7897', 'User')
```

#### 5.3 验证所有软件

```haskell
# 检查软件状态

scoop status

scoop checkup

 

# 测试常用命令

git --version

python --version

node --version
```

![](https://i-blog.csdnimg.cn/direct/a3027bc2196a4203adf894049920a5c7.png)

### 六、常见问题

#### 6.1 环境变量未生效

```php
# 如果 scoop 命令找不到，手动添加 Path

$newPath = "$env:SCOOP\shims;$env:PATH"

[Environment]::SetEnvironmentVariable('Path', $newPath, 'User')

# 重启 PowerShell
```

#### 6.2 权限问题（全局安装）

```cobol
# 以管理员身份运行 PowerShell，然后：

scoop install <软件> --global
```

#### 6.3 旧软件路径残留

某些软件可能仍指向旧路径，需要重新安装：

```puppet
# 查找指向 C 盘的 shim

Get-ChildItem $env:SCOOP\shims | ForEach-Object {

    $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue

    if ($content -match 'C:\\Users\\.*\\scoop') {

        Write-Host "$($_.Name) 仍指向旧路径，建议重装" -ForegroundColor Yellow

    }

}
```

### 七、一键迁移 脚本

保存为 `Migrate-Scoop.ps1` ：

```php
# Scoop 迁移脚本：C 盘 -> D 盘

 

param(

    [string]$NewPath = 'D:\Scoop',

    [string]$BackupDir = 'D:\ScoopMigration'

)

 

# 1. 备份

Write-Host "=== 步骤 1: 备份数据 ===" -ForegroundColor Cyan

scoop export > "$BackupDir\apps.json"

scoop bucket list > "$BackupDir\buckets.txt"

Copy-Item "$env:USERPROFILE\scoop\persist" $BackupDir -Recurse -Force

 

# 2. 卸载

Write-Host "=== 步骤 2: 卸载旧 Scoop ===" -ForegroundColor Cyan

cmd /c "rmdir /s /q $env:USERPROFILE\scoop"

[Environment]::SetEnvironmentVariable('SCOOP', $null, 'User')

 

# 3. 安装到新位置

Write-Host "=== 步骤 3: 安装到 $NewPath ===" -ForegroundColor Cyan

[Environment]::SetEnvironmentVariable('SCOOP', $NewPath, 'User')

$env:SCOOP = $NewPath

irm get.scoop.sh | iex

 

# 4. 恢复

Write-Host "=== 步骤 4: 恢复软件 ===" -ForegroundColor Cyan

scoop import "$BackupDir\apps.json"

 

Write-Host "=== 迁移完成！===" -ForegroundColor Green

scoop status
```

### 结语

通过以上步骤，你可以将 Scoop 从 C 盘完整迁移到 D 盘，同时保留所有软件和配置。关键要点：

1. **备份三件套** ：软件清单、bucket 列表、persist 数据
2. **彻底清理** ：删除目录 + 环境变量 + Path 残留
3. **预置路径** ：安装前设置 `$env:SCOOP`
4. **验证彻底** ：确保旧路径无残留，新路径正常工作

现在你的 Scoop 已经安家在 D 盘，可以放心安装更多软件了！🚀

---

**提示** ：如果 C 盘空间仍然紧张，可以考虑将 `Downloads` 、 `Documents` 等用户文件夹也迁移到 D 盘，实现 系统 与数据的完全分离。