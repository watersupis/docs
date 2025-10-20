---
title: IO流
# description：
# icon: 
category: java
# tag: 
order: 7
---

## 一、IO流

### 1.1 流概述

流是一组有序的数据序列，根据操作的类型，可分为输入流和输出流两种。I/O（Input/Output）流提供了一条通道程序，可以使用这条通道把源中的字节序列送到目的地。虽然I/O流经常与磁盘文件存取有关，但是程序的源和目的地也可以是键盘、鼠标、内存或显示器窗口等。

Java由数据流处理输入输出模式，程序从指向源的输入流中读取源中的数据。源可以是文件、网络、压缩包或者其他数据源。

### 1.2 输入输出流

![image-20220307184346595](others/13_IO%20%E6%B5%81.assets/image-20220307184346595.png)

#### 1.2.1 输入流

1. InputStream类是字节输入流的抽象类，是所有字节输入流的父类。

   （1）read()：从输入流中读取数据的下一个字节。返回0到255范围内的int字节值。如果因为已经到达流末尾而没有可用的字节，则返回值-1。

   （2）read(byte[] b)：从输入流中读入一定长度的字节，并以整数的形式返回字节数。

   （3）mark(int readlimit)：在输入流的当前位置放置一个标记，readlimit参数告知此输入流在标记位置失效之前允许读取的字节数。

   （4）reset()：将输入指针返回到当前所做的标记处。

   （5）skip(long n)：跳过输入流上的n个字节并返回实际跳过的字节数。

   （6）markSupported()：如果当前流支持mark()/reset()操作就返回true。

   （7）close()：关闭此输入流并释放与该流关联的所有系统资源。

2. Reader类是字符输入流的抽象类。

   Java中的字符是Unicode编码，是双字节的，InputStream是用来处理字节的，在处理字符文本时不是很方便。Java为字符文本的输入提供了专门一套单独的类Reader。但Reader类并不是InputStream类的替换者，只是在处理字符串时简化了编程。

#### 1.2.2 输出流

1. OutputStream类是字符输出流的抽象类，此抽象类是表示输出字节流的所有类的超类。

   （1）write(int b)方法：将指定的字节写入此输出流。

   （2）write(byte[] b)方法：将b.length个字节从指定的byte数组写入此输出流。

   （3）write(byte[] b , int off , ,int len)方法：将指定byte数组中从偏移量off开始的len个字节写入此输出流。

   （4）flush()方法：彻底完成输出并清空缓存区。

   （5）close()方法：关闭输出流。

2. Writer类是字符输出流的抽象类，所有字符输出类的实现都是它的子类。

### 1.3 File类

#### 1.3.1 File类

1. 说明

   File类是io包中唯一代表磁盘文件本身的对象，File类定义了一些与平台无关的方法来操作文件。可以通过调用File类中的方法，实现创建、删除、重命名文件等。File类的对象主要用来获取文件本身的一些信息，例如文件所在的目录、文件的长度、文件读写权限等。由于数据流可以将数据写入到文件中，另外文件也是数据流最常用的数据媒体。

2. 语法

   ```java
   // 语法1：new File(String pathname)
   // 该构造方法通过将给定路径名字符串转换为抽象路径名来创建一个新File实例。
   File file = new File("D:/word.txt");
   
   // 语法2：new File(String parent , String child)
   // 该构造方法根据定义的父路径和子路径字符串（包含文件名），创建一个新的File对象。
   File file = new File("D:/word","word.txt");
   
   // 语法3：new File(File f , String child)
   // 该构造方法根据parent抽象路径名和child路径名字符串创建一个新File实例。
   File father = new File("E:/word");
   File file = new File(father,"word.txt");
   ```

#### 1.3.2 常用方法


1. 判断

|  返回   | 方法          | 说明                     |
| :-----: | ------------- | ------------------------ |
| boolean | exists()      | 判断文件或文件夹是否存在 |
| boolean | isFile()      | 判断是不是文件类型       |
| boolean | isHidden()    | 判断是不是隐藏文件       |
| boolean | canRead()     | 判断文件是否可读         |
| boolean | canWrite()    | 判断文件是否可写         |
| boolean | idDirectory() | 判断是不是文件夹类型     |
| boolean | isAbsolute()  | 判断是不是绝对路径       |

2. 操作

|  返回   | 方法                   | 说明                                                         |
| :-----: | ---------------------- | ------------------------------------------------------------ |
| boolean | createNewFile()        | 创建文件，如果创建路径中包含目录且目录不存在，则抛出异常     |
| boolean | mkdir()                | 创建文件夹，父目录不存在，创建失败，返回false                |
| boolean | mkdirs()               | 创建路径中包含所有的父文件夹和子文件夹，如果所有父文件夹和子文件夹都成功创建，返回结果为true |
| boolean | delete()               | 删除文件或文件夹，如果删除成功返回结果为true                 |
| boolean | renameTo(File newFile) | 重命名、移动文件，相当于move/mv；如果newFile已存在 或 原文件和新文件所处不同文件系统（NTFS、ext32、FAT32），则返回false |
| boolean | setReadOnly()          | 设置此文件或文件夹的只读属性                                 |

3. 获取

| 返回     | 方法               | 说明                                                         |
| -------- | ------------------ | ------------------------------------------------------------ |
| String   | getName()          | 获取文件名称                                                 |
| String   | getParent()        | 获取文件的父路径字符串                                       |
| File     | getParentFile()    | 获取上级目录                                                 |
| String   | getPath()          | 获取文件的相对路径字符串                                     |
| String   | getAbsolutePath()  | 获取文件的绝对路径字符串                                     |
| String   | getCanonicalPath() | 获取规范路径，例如：../   /                                  |
| long     | length()           | 获取文件的长度                                               |
| long     | lastModified()     | 获取文件的最后修改日期                                       |
| String[] | list()             | 获取文件夹中的文件和子文件夹的名称，并存放到字符串数组中     |
| File[]   | listFiles()        | 获取文件夹中的文件和子文件夹的名称，并存放到File类型的数组中 |

4. 其它

（1）获取目录大小（递归）

```Java
public long getDirLength(File dir) {
	if (dir.isFile()) { // 如果是文件，直接返回文件的大小
		return dir.length();
	} else if (dir.isDirectory()) {
		long sum = 0;
		File[] listFiles = dir.listFiles();
		for (File sub : listFiles) {
			// sum += 下一级的大小;
			sum += getDirLength(sub);
		}
		return sum;
	}
	return 0; // 既不是文件又不是文件夹，不存在
}
```

（2）获取文件名后缀

```java
String fileName = file.getName(); //得到文件名,包含扩展名
String ext = fileName.substring(fileName.lastIndexOf('.'));
```



### 1.4 文件输入输出流

#### 1.4.1 FileInputStream与FileOutputStream类

1. FileInputStream

   ```java
   // 构造方法
   FileInputStream(String name);
   FileInputStream(File file);
   ```

2. FileOutputStream

   ```java
   // 构造方法
   new FileOutputStream(File file);
   new FileOutputStream(String path);
   ```

#### 1.4.2 FileReader类和FileWriter类

1. FileReader

   ```java
   // 构造方法
   new FileReader(File file);
   new FileReader(String fileName)
   ```

2. FileWriter

   ```java
   // 构造方法
   new FileWriter(File file);
   new FileWriter(String path);
   ```

#### 1.4.3 区别和使用

1. FileInputStream与FileOutputStream类只提供了对字节或字节数组的读取方法，由于汉字在文件中占用两个字节，如果使用字节流，读取不好可能会出现乱码现象。采用字符流Reader或Writer类可以避免这个现象。

### 1.5 缓存输入输出流

#### 1.5.1 BufferedInputStream类

1. 说明：BufferedInputStream类可以对任何的InputStream类进行带缓存区的包装以达到性能的优化。

2. 语法

   ```JAVA
   // 创建一个新的缓存输出流，以将数据写入指定的底层输出流。
   new BufferedInputStream(InputStream in);
   // 创建指定缓冲区大小的BufferedInputStream。
   new BufferedInputStream(InputStream ins,int size);
   // 第一种形式的构造函数创建了一个带有32个字节的缓存流；第二种形式的构造函数按指定的大小来创建缓存区。
   ```

#### 1.5.2 BufferedOutputStream类

1. 说明：使用BufferedOutputStream输出信息和往OutputStream输出信息完全一样，只不BufferedOutputStream有一个flush()方法用来将缓存区的数据强制输出完。

2. 语法

   ```java
   // 语法1：创建一个新的缓存输出流，以将数据写入指定的底层输出流。
   new BufferedOutputStream(OutputStream in)
   // 语法2：创建一个新的缓存输出流，以将具有指定缓存区大小的数据，写入指定的底层输出流。
   new BufferedOutputStream(OutputStream out,int size)
   ```

### 1.6 数据输入输出流

1. 说明：

   数据输入输出流（DataInputStream类与DataOutputStream类）允许应用程序以与机器无关方式从底层输入流中读取基本Java数据类型。也就是说，当读取一个数据时，不必再关心这个数值应当是什么字节。

2. 构造方法

   ```java
   // 使用指定的基础InputStream创建一个DataInputStream。
   new DataInputStream(InputStream in)
   // 创建一个新的数据输出流，将数据写入指定基础输出流。
   new DataOutputStream(OutputStream out) 
   ```

   

3. 常用方法

表1 DataInputStream类的方法

| 返回类型 | 方法名称      | 说明                                                         |
| -------- | ------------- | ------------------------------------------------------------ |
| boolean  | readBoolean() | 读取一个输入布尔值。适用于读取用接口DataOutput的writeBoolean()方法写入的字节 |
| byte     | readByte()    | 读取一个字节。该方法适用于读取用接口DataOutput的writeByte()方法写入的字节 |
| char     | readChar()    | 读取一个字符。该方法适用于读取用接口DataOutput的writeChar()方法写入的字节 |
| int      | readInt()     | 从文件中读取一个int值，该方法适用于读取用接口DataOutput的writeInt()方法写入的字节 |
| float    | readFloat()   | 从文件中读取一个单精度浮点值，该方法适用于读取用接口DataOutput的writeFloat()方法写入的字节 |
| String   | readUTF()     | 读取一个UTF字符串，可以使用DataOutput接口的writeUTF()方法写入适合此方法读取的数据 |

表2  DataOutputStream类的方法

| 返回类型 | 方法名称                   | 说明                                 |
| -------- | -------------------------- | ------------------------------------ |
| void     | writeBoolean(boolean bool) | 把一个布尔值作为单字节值写入         |
| void     | writeBytse(String str)     | 将字符串按字节顺序写出到基础输出流中 |
| void     | writeChars(String str)     | 将字符串按字符顺序写入基础输出流     |
| void     | writeUTF(String str)       | 写入一个UTF字符串                    |
| void     | writeInt(int v)            | 写入一个int型数据                    |
| void     | writeFloat(float f)        | 写入一个float型数据                  |



