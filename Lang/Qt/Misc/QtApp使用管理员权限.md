# 创建manifest文件

在项目目录下创建`app.manifest`文件，并设置一下内容：

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="requireAdministrator" uiAccess="false"/>
      </requestedPrivileges>
    </security>
  </trustInfo>
</assembly>
```

# pro文件配置manifest

```qmake
win32 {
        QMAKE_MANIFEST = $$PWD/app.manifest
}
```

:warning: `app.manifest`与pro在同一目录，也要这样进行设置`$$PWD/app.manifest`，否则编译项目时会报错`Syntax Error`！