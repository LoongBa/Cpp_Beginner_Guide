# C/C++ 新手避坑指南：方便设置 Path 环境变量的脚本

> **如何 在 Path 环境变量中**查看、查找、添加、删除，
> 
> 一个命令行小工具，不用在各个界面间一步步操作。

来自：**《C/C++ 新手避坑指南 系列》**

- 龙爸写给**初学 C/C++** 的朋友们的**新手避坑指南**，扫平入门的几个大障碍的**极简教程**。

原文发布、维护于龙爸**陪孩子学习 `Python`、`C++` 、`算法入门` 的练习项目**:

- [龙爸个人网站1](https://coffeedrunk.cn/archives/Cpp_Beginner_Guide)| [Github](https://github.com/LoongBa/Cpp_Beginner_Guide) 国外 | [GitCode](https://gitcode.com/LoongBa/Cpp_Beginner_Guide) 国内 | [Gitee](https://gitee.com/LoongBa/Cpp_Beginner_Guide) 国内 | [龙爸个人网站2](https://loongba.cn/archives/Cpp_Beginner_Guide)

- 欢迎意见、建议和帮助，谢谢 🥰💕❤️

- 如果对你有帮助，请支持 Star~ ✨✨✨

- 转载时请保留声明和出处，谢谢 🤝🤝🤝

- 如果是 `Github`、`MarkText`、`PDF` 等，请打开目录方便阅读 😎

--- 

# 方便设置 Path 环境变量的脚本 使用说明

> 目的：运行脚本，自动 **添加/删除** <u>当前工作目录</u> 或 <u>指定目录</u> 到 `Path` 环境变量。

可以很方便地设置 `C/C++` 编译器所在的路径到环境变量 `Path` 中，

例如，复制保存脚本的文件夹路径，按下快捷键组合 `Win + X`，

在菜单中选择 `终端管理员` ，随后切换到保存脚本的文件夹，运行：

```powershell
cd D:\_Dev_\_Repos_\Github\_CoffeeScholar_\C_CPP-Learning\CBeginnerHelper
.\SetEnvPath.ps1 D:\_Dev_\C_CPP\gcc\13.2.0\bin
```

> 用 `cd` 命令切换当前目录到脚本所在的目录：`你的脚本实际路径`
> 
> 要设置的路径改为你的实际路径：`D:_Dev_\C_CPP\gcc\13.2.0\bin`

**简单说明：**

1. 如果不指定参数开关，则默认检查 路径 是否存在于 `Path` 环境变量；

2. 开关 `-a` 或 `-add` 将 路径 添加到 `Path` 环境变量；

3. 开关 `-s` 或 `-search` 将在 `Path` 环境变量中搜索路径；

4. 开关 `-r` 或 `-remove` 将在 `Path` 环境变量中删除路径；

5. 开关 `-h` 或 `-help` 将显示本信息。

> 注意：
> 
> 1. 如果不指定路径，则默认取 `运行脚本时的工作路径`，而不是 `保存脚本的路径`；
> 
> 2. 如果当前以用户身份运行，则所有操作针对 `【用户级别】` 的环境变量，否则针对 `【系统级别】` 的环境变量；
> 
> ——设置 `C/C++` 编译环境，**建议用`【系统级别】`，请用系统管理员权限运行脚本**

## 举例如下

### 1. 确认当前路径是否存在

```powershell
.\SetEnvPath.ps1 [path:指定路径，如果不指定则取当前路径]
```

<img title="" src="./assets/2024-03-23-20-55-31-image.png" alt="" width="877">

> 注意：保存脚本的位置与当前运行路径不同，取当前路径。

### 2. 添加当前路径

```powershell
.\SetEnvPath.ps1 -a [path:指定路径，如果不指定则取当前路径]
```

<img title="" src="./assets/2024-03-23-20-56-42-image.png" alt="" width="875">

### 3. 搜索当前路径

```powershell
.\SetEnvPath.ps1 -s [path:指定路径，如果不指定则取当前路径]
```

<img title="" src="./assets/2024-03-23-20-57-38-image.png" alt="" width="765">

> 其中绿色提示是找到了指定的设置项。
> 
> <mark> 黄色提示【文件夹不存在】</mark>，
> 
> 表示环境变量中的该设置项，对应的路径在文件系统中并不存在，有可能是无效项。

### 4. 删除当前路径

```powershell
.\SetEnvPath.ps1 -r [path:指定路径，如果不指定则取当前路径]
```

<img title="" src="./assets/2024-03-23-20-58-13-image.png" alt="" width="782">
