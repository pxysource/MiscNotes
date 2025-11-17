# 引用程序集中的资源

## 资源文件编译方法

- 资源文件需要编译到程序集中。

## 引用方法

- 本地程序集

  - 本地程序集项目文件夹根目录XAML 资源文件的 pack URI

  ```
  pack://application:,,,/ResourceFile.xaml
  ```

  - 本地程序集的项目文件夹的子文件夹中的 XAML 资源文件的 pack URI

  ```
  pack://application:,,,/Subfolder/ResourceFile.xaml
  ```

- 其他程序集

  - 资源文件 - 引用的程序集

  ```
  "pack://application:,,,/ReferencedAssembly;component/ResourceFile.xaml"
  ```

  - 所引用程序集的子文件夹中的资源文件

  ```
  "pack://application:,,,/ReferencedAssembly;component/Subfolder/ResourceFile.xaml"
  ```

- 所引用版本化程序集中的资源文件

```
"pack://application:,,,/ReferencedAssembly;v1.0.0.0;component/ResourceFile.xaml"
```

# 引用外部资源

- 测试发现引用资源时只能使用相对路径，为相对于引用资源文件的程序文件的路径。

## 资源文件编译方法

- 不编译，复制文件即可。

## 引用方法

- 源站点文件

```
"pack://siteoforigin:,,,/SOOFile.xaml"
```

- 子文件夹中的源站点文件

```
"pack://siteoforigin:,,,/Subfolder/SOOFile.xaml"
```

# 参考

[WPF 中的 Pack URI](https://docs.microsoft.com/zh-cn/dotnet/desktop/wpf/app-development/pack-uris-in-wpf?view=netframeworkdesktop-4.8)