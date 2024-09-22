# 1 ResourceDictionay使用

- 创建一个Wpf应用程序

## 1.1 定义数据类型

- TestObj.cs

```csharp
namespace MergeXXX
{
    public class TestObjBase
    {
		private string _name;
        
        virtual public string Name
        {
            get { return _name; }
            set { _name = value; }
        }
    }
    
    public class TestObj : TestObjBase
    {
        public override string Name
        {
            get { return base.Name; }
            set { base.Name = value; }
        }
        
        private int myVar;
        
        public int MyProperty
        {
            get { return myVar; }
            set { myVar = value; }
        }
    }
}
```

## 1.2 创建资源

- Dictionary1.xaml

```xaml
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    xmlns:local="clr-namespace:MergeXXX">

    <DataTemplate DataType="{x:Type local:TestObjBase}">
        <StackPanel>
            <Button Content="{Binding Name}" HorizontalAlignment="Right" VerticalAlignment="Center" Width="100" Height="100" Background="Red"/>
        </StackPanel>
    </DataTemplate>
</ResourceDictionary>
```

## 1.3 使用资源

- MainWindow.xaml

```xaml
<Window x:Class="MergeXXX.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:MergeXXX"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MergeXXX;component/Dictionary1.xaml"/>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
    
    <Grid>
        <!-- 这里会导致绑定的对象一直向下传递 -->
        <UserControl Content="{Binding}"/>
    </Grid>
</Window>

```

- MainWindow.xaml.cs

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace MergeXXX
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            TestObj testObj = new TestObj();
            testObj.Name = "Dictionary Merge Test.";
            DataContext = testObj;
        }
    }
}

```

## 1.4 运行结果

![运行结果](ResourceDictionary/Run1.PNG)

# 2. 资源合注意事项

- 多个资源合并时，先搜索最后一个添加的 ResourceDictionary，并在找到请求的键时就立即停止搜索。即：找到第一个符合项目，就不再查找后面的相识内容。



## 2.1 上面的例子中新增内容

- Dictionary2.xaml

```xaml
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    xmlns:local="clr-namespace:MergeXXX">

    <DataTemplate DataType="{x:Type local:TestObjBase}">
        <StackPanel>
            <Button Content="{Binding Name}" HorizontalAlignment="Left" VerticalAlignment="Center" Width="100" Height="100" Background="Blue"/>
        </StackPanel>
    </DataTemplate>
</ResourceDictionary>
```

- Dictionary3.xaml

```xaml
<ResourceDictionary xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
                    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
                    xmlns:local="clr-namespace:MergeXXX">

    <DataTemplate DataType="{x:Type local:TestObjBase}">
        <StackPanel>
            <Button Content="{Binding Name}" HorizontalAlignment="Center" VerticalAlignment="Top" Width="100" Height="100" Background="Green"/>
        </StackPanel>
    </DataTemplate>
</ResourceDictionary>
```

- MainWindow.xaml

```xaml
<Window x:Class="MergeXXX.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:MergeXXX"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MergeXXX;component/Dictionary1.xaml"/>
                <ResourceDictionary Source="pack://application:,,,/MergeXXX;component/Dictionary2.xaml"/>
                <ResourceDictionary Source="pack://application:,,,/MergeXXX;component/Dictionary3.xaml"/>
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
    
    <Grid>
        <UserControl Content="{Binding}"/>
    </Grid>
</Window>

```

## 2.2 运行结果

![运行结果](ResourceDictionary/Run2.PNG)

