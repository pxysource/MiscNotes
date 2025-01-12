# 简介

yt-dlp：https://github.com/yt-dlp/yt-dlp

目前支持的网站列表：https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md

OS：`Windows`

# 简单用法

`<yt-dlp.exe> <视频URL>`

如：`yt-dlp.exe https://www.youtube.com/watch?v=1QZOdURNBcE `

- `URL`：可以是完整路径，也可以是后面的`1QZOdURNBcE`。 
- 下载的文件就在`yt-dlp`所在的目录，格式有可能是`webm`。



:warning: 注意复制网址的时候，尽量不要复制后面的`t=`多少秒这些信息。因为这些信息没有用。

# 下载`MP4`视频

下载`MP4`格式：

- 借助`ffmpeg`工具转换为`Mp4` 。
- 借助后面音视频组合的下载方式 ，在下文中体现。

## `ffmpeg`转换为`Mp4`

举例： `yt-dlp.exe --merge-output-format mp4 https://www.youtube.com/watch?v=1QZOdURNBcE`

下载之后是一个`mp4`的文件，中间有一个转换的过程，从`webm`->`mp4`。

如果这样的参数下载下来，可能清晰度是`720P`而不是更高清晰度。

如果想要更高清的下载，就需要借助使用配置文件`yt-dlp.conf`。

## 音视频组合的下载方式 

见下文。

# 使用配置文件配置下载

在yt-dlp.exe 所在的目录，新建一个文本文件`yt-dlp.conf` 。

编辑配置文件`yt-dlp.conf`：

- 下载文件保存的路径和名称，`--output "~/Downloads/%(uploader)s/%(title)s-%(resolution)s.%(ext)s"`。
  - `~/Downloads/`：下载路径，通常在C盘，这部分你可以随意替换为你想保存的目录。
  - `uploader`：频道名称或者up主名称。
  - `title`：视频标题。
  - `resolution`：视频分辨率。
  - `ext`：扩展名。

- 进度条标题栏显示（可以不设置），`--console-title --progress-template "download-title:%(info.id)s-%(progress.eta)s"`

- 将下载的视频转换为MP4格式，`--merge-output-format mp4`。

- 下载的多国语言字幕：
  - 下载全部字幕，`--sub-langs all,-live_chat`。
  - 只下载中文字幕和英文字幕，`--sub-langs "en.*,zh-Hans"`。（前提是这个视频的确有中文和英文字幕，注意不是翻译的） 

- 将字幕、缩图、视频描述等信息内嵌到视频文件：

  ````
  --embed-subs
  --embed-thumbnail
  --embed-metadata
  --convert-subs srt
  ````

- `ffmpeg`的路径设置，`--ffmpeg-location D:/NoInstallSoftware/ffmpeg-master-latest-win64-gpl/bin`



:information_source: 查询视频支持的字幕，`-list-subs`参数查询这个视频支持的字幕。举例：`yt-dlp.exe --list-subs https://www.youtube.com/watch?v=220nXk_mJiE`，这样第一列就是语言tag。

## yt-dlp.config示例

```
--output "E:/Videos/YouTube/%(uploader)s/%(title)s-%(resolution)s.%(ext)s"
--console-title --progress-template "download-title:%(info.id)s-%(progress.eta)s"
--merge-output-format mp4
--sub-langs "en.*,zh-Hans"
--embed-subs
--embed-thumbnail 
--embed-metadata
--convert-subs srt
--ffmpeg-location D:/NoInstallSoftware/ffmpeg-master-latest-win64-gpl/bin
```

## 注意

:warning: 配置文件的名称必须是`yt-dlp.conf`！

:warning: `yt-dlp.conf`配置文件，不能输入中文，包括中文注释！

:warning: `yt-dlp.exe`最好放入无中文的路径下！

# 下载指定分辨率的视频

首先，查询这个视频支持下载的分辨率格式。

```
yt-dlp.exe -F https://www.youtube.com/watch?v=1QZOdURNBcE
```

这里包含了一个重要的信息，那就是`文件ID`。这里的`文件ID`，可以是`音频文件ID`，也可以是`视频文件ID`。利用`yt-dlp.exe -F`来查询。

如果想下载`1920x1080`分辨率的视频，需要记录`音频和视频id`，比如我们可以把`140`作为视频的音轨，把`137`作为视频的图像，这样最终会合成一个有图像有声音的视频。

```
yt-dlp.exe https://www.youtube.com/watch?v=1QZOdURNBcE -f137+140
```

还可以自由的组合音视频，这样就把指定分辨率的视频下载出来了。

:warning: `f137`前面有一个`-`。

# 下载播放列表的所有视频

api直接就支持，注意播放列表形如：

`https://www.youtube.com/watch?v=f8yA1jGhpfk&list=PL8mPWv3h4qJeg6iH5yt92jB5jT6kfLg2r`

up主的主页，点击播放列表，出来的就都是播放列表了。

下载命令：

```
yt-dlp.exe https://www.youtube.com/watch?v=f8yA1jGhpfk&list=PL8mPWv3h4qJeg6iH5yt92jB5jT6kfLg2r
```

# 如何升级yt-dlp的版本 

执行`yt-dlp.exe -U` ，即可完成版本升级，更新到最新的Release版本。

# 2025-01-12使用方法

## 环境

### Windows

> Edition	Windows 11 Pro
> Version	23H2
> Installed on	‎2022/‎10/‎6
> OS build	22631.4602
> Experience	Windows Feature Experience Pack 1000.22700.1055.0

### Google chrome

> Version 131.0.6778.205 (Official Build) (64-bit)

### yt-dlp

> yt-dlp 2024.12.23

## 设置yt-dlp环境

### 安装yt-dlp

1. 下载[yt-dlp](https://github.com/yt-dlp/yt-dlp/releases/tag/2024.12.23)，选择`yt-dlp_win.zip`。
2. 解压`yt-dlp_win.zip`（无需安装） —> `yt-dlp_win`。

### 创建插件目录

在`yt-dlp_win`目录下`yt-dlp.exe`同级目录下，创建插件目录`yt-dlp-plugins`。

### 安装插件

1. 下载插件[bgutil-ytdlp-pot-provider 0.7.2](https://github.com/Brainicism/bgutil-ytdlp-pot-provider/releases/tag/0.7.2)，选择下载`zip`文件，放入插件目录`yt-dlp-plugins`。
2. 下载插件[yt-dlp-get-pot v0.2.0](https://github.com/coletdjnz/yt-dlp-get-pot/releases/tag/v0.2.0)，选择下载`zip`文件，放入插件目录`yt-dlp-plugins`。

## 获取YouTube cookie

1. Google chrome安装[Get cookies.txt LOCALLY](https://chromewebstore.google.com/detail/get-cookiestxt-locally/cclelndahbckbenkjhflpdbgdldlbecc?utm_source=ext_app_menu)。
2. 进入`https://music.youtube.com/watch?v=OZytLLasceA&list=RDAMVMqXU1maQ9eFA`，播放任意视频。（已在此页面，进行刷新即可）
3. 运行`chrome`插件`Get cookies.txt LOCALLY`，提取`cookie`，保存到文件`cookies.txt`。
4. 修改配置文件，`--cookies cookies.txt`。（改为对应的文件名称）

出现需要登录的情况（如下），重复2~4。

>ERROR: [youtube+GetPOT] QSRjbYM-eN4: Sign in to confirm you’re not a bot. Use --cookies-from-browser or --cookies for the authentication. See  https://github.com/yt-dlp/yt-dlp/wiki/FAQ#how-do-i-pass-cookies-to-yt-dlp  for how to manually pass cookies. Also see  https://github.com/yt-dlp/yt-dlp/wiki/Extractors#exporting-youtube-cookies  for tips on effectively exporting YouTube cookies

## 设置PO_TOKEN

安装`bgutil-ytdlp-pot-provider`和`yt-dlp-get-pot`实现。

## yt-dlp配置文件

配置文件放置在`yt-dlp_win`目录下`yt-dlp.exe`同级目录。

`yt-dlp.conf`：

```
--no-playlist
--output "E:/Videos/YouTube/ITZY/%(uploader)s/%(title)s-%(resolution)s.%(ext)s"
--console-title --progress-template "download-title:%(info.id)s-%(progress.eta)s"
--merge-output-format mp4
--sub-langs "en.*,zh-Hans"
--embed-subs
--embed-thumbnail 
--embed-metadata
--convert-subs srt
--ffmpeg-location D:/NoInstallSoftware/ffmpeg-master-latest-win64-gpl/bin
--extractor-args "youtube:player-client=mweb"
--cookies music.youtube.com_cookies.txt
```

## 参考

- https://github.com/yt-dlp/yt-dlp/wiki/Extractors#exporting-youtube-cookies
