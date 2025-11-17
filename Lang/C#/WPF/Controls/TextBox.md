# 为TextBox的Text设置默认值

- 默认值为灰色。
- 当用户输入值后，默认值被替换为用户输入。
- 当用户清空输入值后，显示默认值。

## Xaml

- 文件名称MainWindow.xaml。

```xaml
<Window x:Class="TextBoxTest.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:TextBoxTest"
        mc:Ignorable="d"
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <StackPanel Orientation="Horizontal" VerticalAlignment="Top" HorizontalAlignment="Left">
            <TextBlock Text="给输入框默认值" VerticalAlignment="Stretch" HorizontalAlignment="Stretch"/>
            <TextBox MinWidth="100" HorizontalContentAlignment="Left" VerticalContentAlignment="Center">
                <TextBox.Resources>
                    <VisualBrush x:Key="DefaultIpValueBrush" TileMode="None" Opacity="0.3" Stretch="None" AlignmentX="Left">
                        <VisualBrush.Visual>
                            <TextBlock FontStyle="Normal" Text="192.168.1.88"/>
                        </VisualBrush.Visual>
                    </VisualBrush>
                </TextBox.Resources>
                <TextBox.Style>
                    <Style TargetType="{x:Type TextBox}">
                        <Style.Triggers>
                            <Trigger Property="Text" Value="{x:Null}">
                                <Setter Property="Background" Value="{StaticResource DefaultIpValueBrush}"/>
                            </Trigger>
                            <Trigger Property="Text" Value="">
                                <Setter Property="Background" Value="{StaticResource DefaultIpValueBrush}"/>
                            </Trigger>
                        </Style.Triggers>
                    </Style>
                </TextBox.Style>
            </TextBox>
        </StackPanel>
    </Grid>
</Window>
```

## CS

- 文件名称MainWindow.xaml.cs。

```c#
using System;
using System.Collections.Generic;
using System.ComponentModel;
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

namespace TextBoxTest
{
    /// <summary>
    /// MainWindow.xaml 的交互逻辑
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }
    }
}

```



