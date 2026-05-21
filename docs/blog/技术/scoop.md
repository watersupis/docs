---
title: scoop
createTime: 2026/05/08 12:14:04
permalink: /blog/lir1bde8/
---
## 1、介绍

[scoop](https://scoop.sh/ "scoop") 可以通过命令行轻松安装您熟悉且喜爱的程序。它：  
- 消除权限弹出窗口
- 隐藏图形用户界面向导式安装程序
- 防止 PATH 环境变量污染，从而避免安装大量程序。
- 避免因安装和卸载程序而产生的意外副作用
- 自动查找并安装依赖项
- 它会自动执行所有额外的设置步骤，以获得一个可运行的程序。


## 2、安装
说明：
	以下命令全部在powershell终端下运行。
	打开Windows powershell，运行以下命令，执行策略更改。
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
`
下载脚本
- gitee
```
irm scoop.201704.xyz -outfile 'install.ps1'
```
- github
```
irm get.scoop.sh -outfile 'install.ps1'
```

运行脚本
```
.\install.ps1 -ScoopDir 'G:\Applications\Scoop' -ScoopGlobalDir 'G:\Applications\GlobalScoopApps'
```

## 3、常用命令
### 3.1 功能
```
alias      Manage scoop aliases
	- scoop alias <subcommand> [options] [<args>]
bucket     Manage Scoop buckets
	- scoop bucket add|list|known|rm [<args>]
cache      Show or clear the download cache
	- scoop cache rm *
	  (删除缓存软件包)
cat        Show content of specified manifest. If available, `bat` will be used to pretty-print the JSON.
checkup    Check for potential problems
cleanup    Cleanup apps by removing old versions
config     Get or set configuration values
create     Create a custom app manifest
depends    List dependencies for an app, in the order they'll be installed
download   Download apps in the cache folder and verify hashes
export     Exports installed apps, buckets (and optionally configs) in JSON format
help       Show help for a command
hold       Hold an app to disable updates
home       Opens the app homepage
import     Imports apps, buckets and configs from a Scoopfile in JSON format
info       Display information about an app
install    Install apps
list       List installed apps
prefix     Returns the path to the specified app
reset      Reset an app to resolve conflicts
search     Search available apps
shim       Manipulate Scoop shims
status     Show status and check for new app versions
unhold     Unhold an app to enable updates
uninstall  Uninstall an app
update     Update apps, or Scoop itself
virustotal Look for app's hash or url on virustotal.com
which      Locate a shim/executable (similar to 'which' on Linux)
```

### 3.2 bucket

- 查询已知bucket
```
scoop bucket known
```

- 添加bucket
```
scoop bucket add extras
```

- 添加第三方bucket 基本语法
```
scoop bucket add <别名> <git地址>
#举例添加scoopcn（[Mostly Chinese applications / 大多是国内应用程序](https://github.com/scoopcn/scoopcn)）
scoop bucket add spc https://mirror.ghproxy.com/github.com/lzwme/scoop-proxy-cn
```

- 删除bucket
```
scoop bucket rm <别名>
```

### 3.3 软件管理

```
# 软件安装/卸载
# 基本语法 可添加多个
# scoop install/uninstall <库名/软件名>
# scoop install spc/<app_name>
# scoop install spc/7zip spc/aria2 spc/scoop-search
#必装git，scoop及bucket更新均依赖此软件
scoop install git

# 软件暂停更新
# scoop hold <软件名>
# 切换到指定版本
# scoop reset <软件名@版本号>
# 重置所有软件链接及图标
# scoop reset *

# 删除缓存软件包
# scoop cache rm *

# 删除软件老版本
# scoop cleanup rm *
```


```
echo 更换scoop的repo地址
scoop config SCOOP_REPO "https://gitee.com/scoop-installer/scoop"
echo 切换scoop分支
# 切换分支到develop
# scoop config scoop_branch develop
```

