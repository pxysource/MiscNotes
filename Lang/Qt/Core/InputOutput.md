---
title: InputOutput
date: 2024-05-28 20:46:00
categories: 博客
tags: [hexo,github pages]
toc: true
---





# 1 QFileInfo

- 代码

```c++
#include <QFileInfo>
#include <QDebug>
#include <QDir>

int main(int argc, char *argv[])
{
    Q_UNUSED(argc);
    Q_UNUSED(argv);

    QFileInfo fileInfo("D:\\User\\Documents\\QTprojects\\Core\\Input_Output\\file\\resources\\Test.txt");
    qDebug() << "FilePath: " << fileInfo.filePath();
    qDebug() << "Path:     " << fileInfo.path();
    qDebug() << "BaseName: " << fileInfo.baseName();
    qDebug() << "FileName: " << fileInfo.fileName();
    qDebug() << "Suffix:   " << fileInfo.suffix();
    qDebug() << "DirName:  " << fileInfo.dir().dirName();

    return 0;
}
```

- 结果

```
FilePath:  "D:/User/Documents/QTprojects/Core/Input_Output/file/resources/Test.txt"
Path:      "D:/User/Documents/QTprojects/Core/Input_Output/file/resources"
BaseName:  "Test"
FileName:  "Test.txt"
Suffix:    "txt"
DirName:   "resources"
Press <RETURN> to close this window...
```

