# conda
## 1、安装

使用scoop安装anaconda3，或者miniconda

```
scoop install anaconda3
```

## 2、配置
### 2.1 配置下载源
```
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
```

- 下载链接时能显示我们手动配置的通道地址

```
conda config --set show_channel_urls yes
```

当然，除了通过命令行的形式添加下载源，也可以直接修改配置文件 .condarc，在 Windows 系统下，它通常位于 “C:\Users\用户名\” 路径下，可以手动添加如下内容进行配置：

 ```
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
 ```

只有在执行前面的配置下载源的命令时才会出现 .condarc 文件，默认情况下时没有的，如果没有该文件，可以自己手动创建一个文件并写入以上的内容，保存后，conda 将会使用其中配置的下载源来获取软件包。

## 3、环境管理

- 创建

```
conda create -n "env_name" "python/nodejs"="version" "software_package_name"
# 例：conda create -n python311 python=3.11 
```

- 初始化

```
conda init --all
```

- 切换

```
conda activate "env_name"
```

- 删除

```
conda remove -n "env_name" --all
```

- 更新

```
conda remove "software_package_name"
```

- 显示列表

```
conda env list
```

- 安装包

```
conda install "software_package_name"
```

- conda 信息

```
conda info
```



## 4、配置pip

在`C:\Users\xxxx（用户名）\AppData\Roaming\pip`下创建pip.ini文件

```ini
[global]
timeout = 6000
proxy = http://127.0.0.1:7890 #代理，如果镜像源访问慢，需要外网访问
index-url = https://pypi.tuna.tsinghua.edu.cn/simple # 清华大学的镜像源
```


```
# pip国内镜像源：
# 阿里云——http://mirrors.aliyun.com/pypi/simple/
# 中国科技大学——https://pypi.mirrors.ustc.edu.cn/simple/
# 豆瓣————http://pypi.douban.com/simple
# Python官方——https://pypi.python.org/simple/
# v2ex——http://pypi.v2ex.com/simple/
# 中国科学院——http://pypi.mirrors.opencas.cn/simple/
# 清华大学——https://pypi.tuna.tsinghua.edu.cn/simple/
```


## 5、Bug处理

- Error while loading conda entry point: anaconda-cloud-auth (cannot import name 'AliasGenerator' from 'pydantic' 

  ```bash
  # 方法1：更新 Anaconda
  conda update --all
  co方法1：nda update anaconda
  # 方法2：修复环境
  conda install --fix-broken
  # 方法3：重新安装 anaconda-cloud-auth
  conda install anaconda-cloud-auth
  ```

  
- CondaError: Run 'conda init' before 'conda activate'
``` 输入命令
conda init --all
```