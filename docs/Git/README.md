---
title: Git
createTime: 2026/03/27 11:00:23
permalink: /git/
---

## 一、Git 简介

Git 是一个分布式版本控制系统，用于跟踪文件变更、协同开发。

### 1.1 基本概念

| 概念 | 说明 |
|------|------|
| 仓库（Repository） | 项目目录，包含所有版本历史 |
| 工作区（Working Directory） | 本地看到的文件 |
| 暂存区（Stage/Index） | `git add` 后的区域 |
| 本地仓库（Local Repository） | `git commit` 后的区域 |
| 远程仓库（Remote Repository） | GitHub、GitLab 等远程服务器 |

### 1.2 配置

```bash
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
git config --global core.editor vim
git config --global color.ui auto
git config --list
```

## 二、基础操作

### 2.1 初始化与克隆

```bash
git init                    # 初始化本地仓库
git clone <url>             # 克隆远程仓库
git clone <url> <dirname>   # 克隆到指定目录
```

### 2.2 工作流程

```
工作区 → git add → 暂存区 → git commit → 本地仓库 → git push → 远程仓库
```

### 2.3 常用命令

```bash
git status                  # 查看状态
git add .                   # 暂存所有修改
git add <file>              # 暂存指定文件
git commit -m "提交信息"    # 提交到本地仓库
git commit --amend          # 修改最后一次提交
git log --oneline --graph   # 查看提交历史（图形化）
git log -n 5                # 最近5条提交
git diff                    # 查看未暂存的差异
git diff --staged           # 查看已暂存的差异
git diff <branch1>..<branch2>  # 比较两个分支
```

### 2.4 撤销操作

```bash
git restore <file>          # 撤销工作区修改（丢弃）
git restore --staged <file> # 撤销暂存区，回退到工作区
git reset HEAD~1            # 撤销最后一次提交，保留修改到工作区
git reset --soft HEAD~1     # 撤销提交，保留修改到暂存区
git reset --hard HEAD~1     # 撤销提交，丢弃所有修改
git revert <commit-id>      # 生成反向提交（安全撤销，适合公共分支）
```

## 三、分支操作

### 3.1 分支管理

```bash
git branch                  # 查看本地分支
git branch -a               # 查看所有分支（含远程）
git branch <name>           # 创建分支
git branch -d <name>        # 删除分支（已合并）
git branch -D <name>        # 强制删除分支
git branch -m <old> <new>   # 重命名分支
git branch --merged         # 查看已合并的分支
git branch --no-merged      # 查看未合并的分支
```

### 3.2 切换分支

```bash
git checkout <name>         # 切换分支（旧语法）
git switch <name>           # 切换分支（新语法，推荐）
git checkout -b <name>      # 创建并切换（旧语法）
git switch -c <name>        # 创建并切换（新语法，推荐）
```

### 3.3 合并分支

```bash
git merge <branch>          # 将 branch 合并到当前分支
git merge --no-ff <branch>  # 禁用快进合并，保留分支历史
```

合并时遇到冲突：

```bash
# 1. 手动编辑冲突文件，解决冲突
# 2. 标记冲突已解决
git add <file>
git commit -m "解决冲突"
```

## 四、远程操作

```bash
git remote -v               # 查看远程仓库地址
git remote add origin <url> # 添加远程仓库
git remote remove <name>    # 删除远程仓库
git remote rename <old> <new> # 重命名远程仓库

git push origin main        # 推送到远程
git push -u origin main     # 推送并设置上游（首次）
git push origin --delete <branch> # 删除远程分支
git push --tags             # 推送所有标签

git pull                    # 拉取并合并（= fetch + merge）
git pull --rebase           # 拉取并变基（= fetch + rebase）
git fetch                   # 仅拉取远程更新，不合并
git fetch --all             # 拉取所有远程仓库
```

## 五、stash 储藏

临时保存工作区修改，用于切换分支前。

```bash
git stash                   # 储藏当前修改
git stash save "说明"       # 带说明储藏
git stash list              # 查看储藏列表
git stash pop               # 恢复最新储藏并删除
git stash apply             # 恢复最新储藏但保留
git stash drop stash@{0}    # 删除指定储藏
git stash clear             # 清空所有储藏
```

## 六、rebase 变基

将当前分支的提交重新应用到目标分支之上，使历史更清晰。

```bash
git rebase main             # 将当前分支变基到 main
git rebase -i HEAD~3        # 交互式变基（合并、修改、删除提交）
git rebase --continue       # 解决冲突后继续
git rebase --abort          # 放弃变基
```

### 6.1 交互式变基操作

| 命令 | 说明 |
|------|------|
| pick | 保留该提交 |
| reword | 修改提交信息 |
| edit | 暂停，修改提交内容 |
| squash | 合并到上一个提交 |
| fixup | 合并到上一个提交，丢弃提交信息 |
| drop | 删除该提交 |

### 6.2 merge vs rebase

| | merge | rebase |
|--|-------|--------|
| 历史 | 保留分支拓扑 | 线性历史 |
| 冲突 | 一次性解决 | 每个提交可能解决一次 |
| 适用 | 公共分支（如 main） | 本地特性分支 |
| 安全性 | 安全，不改变历史 | 会改变历史，不要对公共分支使用 |

## 七、tag 标签

```bash
git tag v1.0.0              # 创建轻量标签
git tag -a v1.0.0 -m "说明" # 创建附注标签
git tag                     # 查看所有标签
git show v1.0.0             # 查看标签详情
git push origin v1.0.0      # 推送单个标签
git push origin --tags      # 推送所有标签
git tag -d v1.0.0           # 删除本地标签
git push origin --delete v1.0.0 # 删除远程标签
```

## 八、.gitignore

```gitignore
# 编译产物
target/
*.class
*.jar
*.war

# IDE 配置
.idea/
.vscode/
*.iml
.project

# 环境文件
.env
*.log

# 依赖目录
node_modules/
vendor/

# 系统文件
.DS_Store
Thumbs.db
```

## 九、常见工作流

### 9.1 Git Flow

```
main        生产分支（始终保持可部署）
develop     开发主分支
feature/*   功能分支（从 develop 分出，合回 develop）
release/*   发布分支（从 develop 分出，合回 main 和 develop）
hotfix/*    紧急修复分支（从 main 分出，合回 main 和 develop）
```

### 9.2 GitHub Flow（简化）

```
main        始终可部署
feature/*   从 main 分出 → 开发 → PR → Code Review → 合并到 main
```

### 9.3 Trunk Based Development

```
main        主干分支，所有开发都在 main 上进行
short/*     短生命周期分支（1-2天），快速合并回 main
```

## 十、实用技巧

```bash
# 查看某行代码是谁写的
git blame <file>

# 搜索提交历史中的关键词
git log --grep="bugfix"

# 查看某个文件的修改历史
git log --follow -p <file>

# 查看某个提交修改了哪些文件
git show --stat <commit-id>

# 挑选某个提交应用到当前分支
git cherry-pick <commit-id>

# 二分查找引入 bug 的提交
git bisect start
git bisect bad          # 当前提交有问题
git bisect good <commit> # 该提交没问题
# Git 会自动切换提交让你测试
```
