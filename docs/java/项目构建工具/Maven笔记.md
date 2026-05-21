---
title: Maven笔记
createTime: 2026/04/29 17:41:58
permalink: /java/89vep7l8/
---
## Maven笔记

为什么要学习这个技术？

1. 在Javaweb开发中，需要使用大量的jar包，我们手动去导入；

2. 如何能够让一个东西自动帮我导入和配置这个jar包。

	由此，Maven诞生了！

<br/>

### 1. Maven项目架构管理工具

我们目前用来就是方便导入jar包的！

Maven的核心思想：**约定大于配置**大于编码

- 有约束，不要去违反。

Maven会规定好你该如何去编写我们的Java代码。

<br/>

### 2.下载安装Maven

官网;https://maven.apache.org/

下载完成后，解压即可。

<br/>

### 3. 配置环境变量

在我们的系统环境变量中

配置如下配置：

- `M2_HOME`     maven目录下的bin目录(向下兼容maven2，避免出现一些很奇怪的问题)
- `MAVEN_HOME`      maven的目录
- 在系统的path中配置  `%MAVEN_HOME%\bin`

![1567842882993](https://img-blog.csdnimg.cn/20200517151020374.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

测试Maven是否安装成功，保证必须配置完毕！

<br/>

### 4. 阿里云镜像配置

![1567844609399](https://img-blog.csdnimg.cn/20200517151907711.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

- 镜像：mirrors
	- 作用：加速我们的下载
- 国内建议使用阿里云的镜像

```xml
<mirror>
    <!--阿里云私服配置-->
    <id>nexus-aliyun</id>  
    <mirrorOf>*,!jeecg,!jeecg-snapshots</mirrorOf>  
    <name>Nexus aliyun</name>  
    <url>http://maven.aliyun.com/nexus/content/groups/public</url> 
</mirror>
```

<br>

### 5. 配置本地仓库（localRepository）

在本地的仓库，远程仓库；

**建立一个本地仓库：**D:\develop\apache-maven-3.6.3\conf\settings.xml

```xml
<localRepository>D:\develop\apache-maven-3.6.3\maven-repo</localRepository>
```

<br>

### 6. 在IDEA中使用Maven

1、启动IDEA

2、创建一个Maven Web项目

![img](https://img-blog.csdnimg.cn/20200517152004558.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

![1567844841172](https://img-blog.csdnimg.cn/20200517152004473.png)

![1567844917185](https://img-blog.csdnimg.cn/20200517152004543.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

...

3. 等待项目初始化完毕(2020.1版没有这个)

	![1567845105970](https://img-blog.csdnimg.cn/2020051715213127.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

	![1567845137978](https://img-blog.csdnimg.cn/20200517152131375.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

4. IDEA中的Maven设置

  注意：IDEA项目创建成功后，看一眼Maven的配置

  IDEA中每次都要重复配置Maven

  在IDEA中的全局默认配置中去配置

  <br>![image-20200517145250376](Maven笔记.assets\20200517152911672.png)

  <br>![image-20200517145555891](https://img-blog.csdnimg.cn/20200517152911671.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

  <br>![1567845413672](https://img-blog.csdnimg.cn/20200517152209177.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

5. 到这里，Maven在IDEA中的配置和使用就OK了!

6. 解决 maven 默认web项目中的web.xml 版本问题（版本为2.3太老了，替换为4.0）

	![1567905537026](https://img-blog.csdnimg.cn/20200517152229910.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

将webapp中的内容替换为

```XML
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
         version="4.0"
         metadata-complete="true">
    
</web-app>
```

<br>

### 7. 创建一个普通的Maven项目

![1567845557744](https://img-blog.csdnimg.cn/20200517152314501.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

![1567845717377](https://img-blog.csdnimg.cn/20200517152314517.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

<br>


> 附：Maven仓库的使用（关于查找jar包）

地址：https://mvnrepository.com/

<br>

<br>

### <font color=red>8. Maven 核心概念</font>

#### 1. pom文件

pom.xml 是Maven的核心配置文件

POM：Project Object Model：项目对象模型。将 Java 工程的相关信息封装为对象作为便于操作和管理的模型。Maven 工程的核心配置。可以说学习 Maven 就是学习 pom.xml 文件中的配置。  

![1567846784849](https://img-blog.csdnimg.cn/20200517152416871.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

> pom文件的一些配置信息

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--Maven版本和头文件-->
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <!--这里就是我们刚才配置的GAV-->
  <groupId>com.kuang</groupId>
  <artifactId>javaweb-01-maven</artifactId>
  <version>1.0-SNAPSHOT</version>
  <!--Package：项目的打包方式
  jar：Java应用
  war：Web应用
  pom: 作为统一管理依赖版本的父工程
  -->
  <packaging>war</packaging>


  <!--配置-->
  <properties>
    <!--项目的默认构建编码-->
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <!--编码版本-->
    <maven.compiler.source>1.8</maven.compiler.source>
    <maven.compiler.target>1.8</maven.compiler.target>
  </properties>

  <!--项目依赖-->
  <dependencies>
    <!--具体依赖的jar包配置文件-->
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
    </dependency>
  </dependencies>

  <!--项目构建用的东西-->
  <build>
    <!--最终的工程名-->
    <finalName>javaweb-01-maven</finalName>
      <pluginManagement>
          <plugins>
              <plugin>
                  <artifactId>maven-clean-plugin</artifactId>
                  <version>3.1.0</version>
              </plugin>
              <plugin>
                  <artifactId>...</artifactId>
                  <version>...</version>
              </plugin>
          </plugins>
      </pluginManagement>
  </build>
</project>

```

![1567847410771](https://img-blog.csdnimg.cn/20200517152436613.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0dfcmFpbnk=,size_16,color_FFFFFF,t_70)

<br>

> 解决可能出现的资源导出失败问题

maven由于他的约定大于配置，我们之后可以能遇到我们写的配置文件，无法被导出或者生效的问题。

解决方案：

```xml
<!--在build中配置resources，来防止我们资源导出失败的问题-->
<build>
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>true</filtering>
        </resource>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>true</filtering>
        </resource>
    </resources>
</build>
```

<br>

#### 2. Maven约定的目录结构

```bash
Hello(项目名)
|------src    (源码)
|-------|------- main   (存放主程序类)
|-------|--------|-------java   (存放 Java 源文件)
|-------|--------|-------resources    (存放框架以及其他工具的配置文件)
|-------|-------test    (存放测试程序)
|-------|--------|-------java
|-------|--------|-------resources
|------pom.xml   (Maven工程的核心配置文件)
```

<br>

#### 3. Maven仓库管理(GAV)

> 仓库分类

1、本地仓库：为当前本机电脑上的所有 Maven 工程服务。

2、远程仓库：

（1）私服：架设在当前局域网环境下，为当前局域网范围内的所有 Maven 工程服务。

（2）中央仓库：架设在 Internet 上，为全世界所有 Maven 工程服务。

（3）中央仓库的镜像：架设在各个大洲，为中央仓库分担流量。减轻中央仓库的压力，同时更快的响应用

户请求。  

<br/>

> 仓库中的文件

1、Maven 的插件

2、我们`自己开发的项目的模块`	运行`mvn install` 会生成

3、第三方框架或工具的 jar 包

※不管是什么样的 jar 包，在仓库中都是按照坐标生成目录结构，所以可以通过统一的方式查询或依赖。

<br/>

> 如何在仓库中找到对应的 jar 包？

首先介绍什么是`jar包`：jar包就是别人已经写好的一些类，然后将这些类进行打包，你可以将这些jar包引入你的项目中，然后就可以直接使用这些jar包中的类和属性以及方法。

如何在仓库中找到对应的 jar 包？ 通过 `GAV`

<br/>

> GAV，也就是下面英文字母的首写，也叫做Maven坐标，是`用来唯一标识jar包的`。

【1】GroupId：  `项目`组织唯一的标识符，一般为反写的公司网址+项目名

【2】ArtifactId：`模块`的唯一的标识符，一般为项目名+模块名

【3】Version：   当前模块的`版本`

```xml
<!-- GAV 每个Maven项目必须都要配置的-->
<!--配置当前项目的坐标，在 mvn install 安装后其他项目可以通过这个 GAV 依赖于这个项目-->
<groupId>top.myMaven</groupId>
<artifactId>myMavenPro</artifactId>
<version>1.0-SNAPSHOT</version>

<!--SNAPSHOT    snapshot    快照，暂时的存储版本  -->
<!--RELEASE     release     分离的，表明该版本已开发完成并可用    -->
```

<br/>

> 在仓库中查找 jar 包的方式

1）将 GAV 三个坐标连起来

top.myMaven + myMavenPro + 1.0-SNAPSHOT

2）以连起来的字符串作为目录结构到仓库中查找

top / myMaven / myMavenPro / 1.0-SNAPSHOT / myMavenPro-1.0-SNAPSHOT . jar

※`注意`：**我们自己的 Maven 工程必须执行`安装操作`才会进入仓库**。 安装的命令是： `mvn install`

<br/>

<br>

#### 4. Maven 依赖管理

Maven 中最关键的部分， 我们使用 Maven 最主要的就是使用它的依赖管理功能。 要理解和掌握 Maven
的依赖管理，我们只需要解决一下几个问题：

> 依赖的目的是什么

当 A jar 包用到了 B jar 包中的某些类时， A 就对 B 产生了依赖，这是概念上的描述。

简单的说就是为了导入别的jar包来使用。

<br/>

> 依赖的范围

依赖信息中除了目标 jar 包的坐标还有一个 scope 设置， 这是依赖的范围。

依赖的范围有几个可选值， 我们用得到的是： compile、 test、 provided 三个    

**编译依赖范围（compile）**：表示编译范围，指A在编译时依赖B，该范围为默认依赖范围。编译范围的依赖会用在`编译，测试，运行`，**由于运行时需要，所以编译范围的依赖会被打包**。

**测试依赖范围（test）**：test范围依赖在编译和运行时都不需要，只在测试`编译和测试`运行时需要。例如：Junit。**由于运行时不需要，所以test范围依赖不会被打包。**

**已提供依赖范围(provided)**：provide依赖只有当jdk或者一个容器已提供该依赖之后才使用。provide依赖在`编译和测试时需要，在运行时不需要`。例如：**servlet api被Tomcat容器提供了**。

<br/>

>  依赖的传递性

好处：一次导入，全部解决

**注意：只能传递compile范围的依赖jar包**

<br/>

> 依赖的排除

如果我们在当前工程中引入了一个依赖是 A，而 A 又依赖了 B，那么 Maven 会自动将 A 依赖的 B 引入当
前工程，但是个别情况下 `B 有可能是一个不稳定版`，或`对当前工程有不良影响。` 这时我们可以在引入 A 的时候将 B 排除。  

```xml
<dependency>
    <groupId>com.atguigu.maven</groupId>
    <artifactId>HelloFriend</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <type>jar</type>
    <scope>compile</scope>
    <exclusions>
        <!--exclusion 排除-->
        <exclusion>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
        </exclusion> 
    </exclusions>
</dependency>
```

<br/>

> 依赖的原则，解决jar包冲突

1. 路径最短者优先原则![image-20200517111839920](https://img-blog.csdnimg.cn/20200517152544455.png)

2. 路径相同时先声明者优先原则![image-20200517112235724](https://img-blog.csdnimg.cn/20200517152555619.png)

	先声明指的是dependency标签的声明顺序（前后顺序）

	<br/>

> 统一管理依赖的版本

1）在properties标签内使用自定义标签统一声明版本号

```xml
<properties>
    <customize-version>4.0</customize-version>
</properties>
```

2）在需要统一配置的位置，使用$ { 自定义标签名 } 引用声明的版本号

```xml
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <!--引用配置的版本号-->
    <version>${customize-version}</version>
</dependency>
```

3）其他用法...

​	  凡是需要统一声明后在引用的场合都可以使用

```XML
<properties>
    <!--自定义标签名-->
	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    ...
</properties>
```

<br/>

> 继承

现状
Hello依赖的Junit：4.0
HelloFriend依赖的Junit：4.0
MakeFriends依赖的Junit：4.9

由于test范围的依赖不能传递，所以必然会分散在各个模块工程中，很容易造成版本不一致。

**<FONT COLOR=RED>需求：统一管理各个模块工程中对Junit依赖的版本。</FONT>**

解决思路：将Junit依赖统一提取到“父”工程中，在子工程中声明Junit依赖是不指定版本，以父工程中统一设定的为准。同时也便于修改。

**操作步骤：**
① **创建一个Maven工程作为父工程。**注意：打包方式为pom

创建父工程和创建一般的 Java 工程操作一致，唯一需要注意的是： 打包方式处要设置为 pom  

```XML
<groupId>...</groupId>
<artifactId>...</artifactId>
<version>...</version>
<!--以pom的方式打包，作为统一管理依赖版本的父工程-->
<packaging>pom</packaging>
```

② **在子工程中声明对父工程的引用**

```XML
<!--子工程中声明父工程-->
<parent>
    <groupId>com.study</groupId>
    <artifactId>MyBatis-Study</artifactId>
    <version>1.0-SNAPSHOT</version>
</parent>

<artifactId>MyBatis-01</artifactId>
```

③ **在父工程中声明对子工程的引用（并将子工程的坐标中与父工程坐标中重复的内容删除）**

此时如果子工程的 groupId 和 version 如果和父工程重复则可以删除。  

子工程中的 groupId 和 version 相对于父工程重复，可以删除！！！

```xml
<!--父工程中声明子工程-->
<modules>
    <module>MyBatis-01</module>
</modules>
```

④ **在父工程中统一管理Junit的依赖**

将 **父工程** 项目中的 dependencies 标签，用 **dependencyManagement** 标签括起来  

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
        	<groupId>junit</groupId>
            <artifactId>junit</artifactId>
			<scope>test</scope>
            <!--为所有子工程配置统一的版本-->
            <version>4.9</version>
         <dependency>
    <dependencies>
<dependencyManagement>
```

⑤ **在子项目中重新指定需要的依赖，删除范围和版本号。**

```XML
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <!--删除了版本号-->
        <!--删除了范围-->
    </dependency>
</dependencies>
```

注意：配置集成后，执行安装命令时要 先安装父工程。

<br/>


> 聚合

**1、 为什么要使用聚合？**
在使用Java开发项目时，一种常见的情形是项目由多个模块组成，软件开发人员往往会采用各种方式对软件划分模块，以得到更清晰的设计以及更高的重用性。

<FONT COLOR=RED>**Maven的聚合特性能够帮助把项目的各个模块聚合在一起构建。**</FONT>

**2、 如何配置聚合？**
在总的聚合工程中使用 modules/module 标签组合， 指定模块工程的相对路径即可

```xml
<!--配置聚合-->
<modules> 
    <!---指定各个子工程的相对路径-->
    <module>../Hello</module> 
    <module>../HelloFriend</module> 
    <module>../MakeFriends</module> 
</modules>
```

**3、使用方式：**

在`聚合工程`的maven构建中，执行`mvn install`

<br/>

<br/>

#### 5. Maven_Web工程的自动部署

在pom.xml 中添加如下配置：

```XML
  <!--配置当前工程构建过程中的特殊设置   -->
<build>
    <!--最终的工程名-->
    <finalName></finalName>
    <!-- 配置构建过程中需要使用的插件 -->
    <plugins>
        <plugin>
            <!-- cargo是一家专门从事启动Servlet容器的组织 -->
            <groupId>org.codehaus.cargo</groupId>
            <artifactId>cargo-maven2-plugin</artifactId>
            <version>1.2.3</version>
            <!-- 针对插件进行的配置 -->
            <configuration>
                <!-- 配置当前系统中容器的位置 -->
                <container>
                    <containerId>tomcat9.3</containerId>
                    <home>D:\develop\apache-tomcat-9.0.30</home>
                </container>
                <!-- 确认配置容器的位置 -->
                <configuration>
                    <type>existing</type>
                    <home>D:\develop\apache-tomcat-9.0.30</home>
                    <!-- 如果Tomcat端口为默认值8080则不必设置该属性 -->
                    <properties>
                        <cargo.servlet.port>8989</cargo.servlet.port>
                    </properties>
                </configuration>
            </configuration>
            <!-- 配置插件在什么情况下执行 -->
            <executions>  
                <execution>  
                    <id>cargo-run</id>
                    <!-- phase 生命周期的阶段 -->  
                    <phase>install</phase>  
                    <goals>
                        <!-- goal 插件的目标 -->  
                        <goal>run</goal>  
                    </goals>  
                </execution>  
            </executions>
        </plugin>
    </plugins>
</build>
```

<br/>
