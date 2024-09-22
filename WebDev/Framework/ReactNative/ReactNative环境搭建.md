# 1 简介

指导搭建React Native环境。

# 2 准备

1. 网速稳定的代理。

# 3 搭建

## 3.1 Windows

1. 参考React Native中文网的[搭建开发环境](https://www.react-native.cn/docs/next/environment-setup)，进行基础环境的配置。

2. 安装过程中请一直保持代理开启中。

### 3.1.1 安装依赖

- Node
- JDK
- Android Studio

#### Node

1. 直接在[Node官网](https://nodejs.org/en/)下载安装即可，注意版本应大于14。

2. 检查Node版本

   ```cmd
   node --version
   ```

注意：如果找不到命令，请设置node的环境变量。

#### JDK

1. 直接在[Java Download](https://www.oracle.com/java/technologies/downloads/#java11-windows)下载安装即可，注意需要JDK11

2. 检查Node版本

   ```cmd
   javac --version
   ```

注意：如果找不到命令，请设置JDK的环境变量。

##### 配置JAVA_HOME环境变量(!)

变量名称未JAVA_HOME，其值为JDK所在路径。

#### Yarn

```cmd
npm install -g yarn
```

### 3.1.2 Android开发环境

#### Android Studio

安装Android Studio，用以安装和配置Android环境。

直接在[Android Studio](https://developer.android.google.cn/studio/)官网下载安装即可，无须其他安装包。

安装选项：

- Android SDK
- Android SDK Platform
- Android Virtual Device

#### 安装Android SDK

在SDK Manager中选择"SDK Platforms"，选择 Android 11 (R)，选择如下配置：

- Android SDK Platform 30
- Intel x86 Atom_64 System Image（官方模拟器镜像文件）

在"SDK Tools"，选择如下配置：

- "Android SDK Build-Tools"选择30.0.2版本
- "NDK"选择20.1.5948944

#### 配置Android SDK环境变量(!)

- 添加ANDROID_HONE环境变量，其值未`Android SDK`所在路径。
- 添加如下值到Path环境变量

```
%ANDROID_HONE%\platform-tools
%ANDROID_HONE%\emulator
%ANDROID_HONE%\tools
%ANDROID_HONE%\tools\bin
```

### 3.1.3 创建新项目

#### cmd开启代理(!)

```cmd
set http_proxy=http://127.0.0.1:10809
set https_proxy=http://127.0.0.1:10809
```

注意：

- 端口号为代理软件中设置的`http代理`的端口号
- 这种设置方法只在当前`cmd`中生效，重新打开`cmd`需要重新进行设置

检查cmd代理是否开启如果有`html`返回，证明开启代理成功：

```cmd
curl www.google.com -i
```

#### 创建项目

```cmd
npx react-native init AwesomeProject
```

##### 在项目文件中配置代理(!)

在项目文件的Android目录下找到gradle.properties文件，并在文件中配置代理

```
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=10809
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=10809
```

注意：端口号为代理软件中设置的`http代理`的端口号

### 3.1.4 运行Android模拟器

使用Android Studio创建Android模拟器，模拟器版本选择"**Q** API Level 30 image"，运行模拟器。

可使用如下命令检查Android模拟器是否运行成功

```cmd
adb devices
```

### 3.1.5 编译并运行React Native应用

```cmd
cd AwesomeProject
yarn android
```

等待运行成功。

# 4 问题及解决方案

## https相关的错误

代理为设置成功

- 检查`cmd`中是否开启了代理
- 检查`gradle.properties`文件中是否设置了代理

## 提示找不到JDK环境

JDK的环境变量未设置

- 添加JAVE_HOME环境变量。

# 附录

| 符号 | 意义     |
| ---- | -------- |
| !    | 重要步骤 |
|      |          |
|      |          |

