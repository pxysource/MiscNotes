# 简介

yt-dlp：https://github.com/yt-dlp/yt-dlp

目前支持的网站列表：https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md

OS：Windows

# 简单用法

`<yt-dlp.exe> <视频URL>`

如：`yt-dlp.exe https://www.youtube.com/watch?v=1QZOdURNBcE `

- `URL`：可以是完整路径，也可以是后面的`1QZOdURNBcE`。

  :warning: 注意复制网址的时候，尽量不要复制后面的`t=`多少秒这些信息。因为这些信息没有用。 

- 下载的文件就在`yt-dlp`所在的目录，格式有可能是`webm`。

# 下载MP4 视频

下载MP4 格式：

- 借助ffmpeg工具包转换为Mp4 ffmpeg工具包。
- 借助后面音视频组合的下载方式 ，在下文中体现。

## ffmpeg转换为Mp4

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
