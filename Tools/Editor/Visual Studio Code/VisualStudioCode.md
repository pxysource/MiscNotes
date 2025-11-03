# Plugins

## Hex Editor

Allows viewing and editing files in a hex editor.

# 使用

## 以 **GB2312** 编码打开文件

### Workspace

`.vscode/settings.json`文件中添加编码设置。

- 文件能识别出编码，并且可能有些文件不是`GB2312`编码格式，设置如下：

  ```json
  "files.autoGuessEncoding": true
  ```

- 文件不能识别出编码格式，指定全部以`GB2312`编码格式解析，设置如下：

  ```json
  "files.encoding": "gb2312",
  "files.autoGuessEncoding": true
  ```

### 全局

修改全局设置。（全局的`settings.json`文件）