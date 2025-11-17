# ViewMode

## ViewModelBase

- 作为所有ViewModel的基类，实现INotifyPropertyChanged接口。

```c#
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVVMLib.ViewModel
{
    /// <summary>
    /// MVVM模式的ViewModel的基类
    /// </summary>
    public class ViewModelBase : INotifyPropertyChanged
    {
        /// <summary>
        /// 在属性值更改后发生
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        /// <summary>
        /// 引发"PropertyChanged"事件。
        /// </summary>
        /// <remarks>
        /// 如果"propertyName"参数对应的属性在当前类中不存在，则仅在"DEBUG"配置中引发异常。
        /// </remarks>
        /// <param name="propertyName">更改的属性的名称。</param>
        public virtual void RaisePropertyChanged(string propertyName)
        {
            VerifyPropertyName(propertyName);
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }

        /// <summary>
        /// 验证当前"ViewModel"中是否存在对应的属性名。
        /// 可以在使用属性之前调用此方法，例如在调用"RaisePropertyChanged"之前。
        /// 当属性名称更改但某些地方丢失时，它可以避免错误。
        /// </summary>
        /// <remarks>此方法仅在 DEBUG 模式下有效。</remarks>
        /// <param name="propertyName">将被检查的属性的名称。</param>
        [Conditional("DEBUG")]
        private void VerifyPropertyName(String propertyName)
        {
            Type type = GetType();
            Debug.Assert(
              type.GetProperty(propertyName) != null,
              propertyName + " property does not exist on object of type : " + type.FullName);
        }

        /// <summary>
        /// 为属性分配一个新值，并引发"PropertyChanged"事件。
        /// </summary>
        /// <typeparam name="T">更改的属性的类型。</typeparam>
        /// <param name="field">存储属性值的字段。</param>
        /// <param name="value">发生更改后的属性值。</param>
        /// <param name="propertyName">更改的属性的名称。</param>
        /// <returns>
        /// 如果已引发"PropertyChanged"事件，则为 true，否则为 false。
        /// 如果旧值等于新值，则不会引发事件。
        /// </returns>
        public bool SetProperty<T>(ref T field, T value, string propertyName)
        {
            if (!EqualityComparer<T>.Default.Equals(field, value))
            {
                field = value;
                VerifyPropertyName(propertyName);
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
```



# Command

## RelayCommand

- 实现ICommand接口。

```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace MVVMLib.Command
{
    /// <summary>
    /// 命令，其唯一目的是通过调用委托将其功能传递给其他对象。
    /// "CanExecute"方法的默认返回值为“true”。
    /// 此类不允许您在"Execute"和"CanExecute"回调方法中接受命令参数。
    /// </summary>
    public sealed class RelayCommand : ICommand
    {
        private readonly Action<object> _execute;

        private readonly Predicate<object> _canExecute;

        /// <summary>
        /// 初始化"RelayCommand"类的新实例。
        /// </summary>
        /// <param name="execute">执行逻辑。</param>
        /// <exception cref="ArgumentNullException">如果execute为null。</exception>
        public RelayCommand(Action<object> execute) : this(execute, null)
        {
        }

        /// <summary>
        /// 初始化"RelayCommand"类的新实例。
        /// </summary>
        /// <param name="execute">执行逻辑。</param>
        /// <param name="canExecute">执行状态逻辑。</param>
        /// <exception cref="ArgumentNullException">如果execute为null。</exception>
        public RelayCommand(Action<object> execute, Predicate<object> canExecute)
        {
            _execute = execute ?? throw new ArgumentNullException("execute");
            _canExecute = canExecute;
        }

        /// <summary>
        /// 确定命令是否可以在其当前状态下执行。
        /// </summary>
        /// <param name="parameter">此参数将始终被忽略。</param>
        /// <returns>如果命令可被执行返回true，否则返回false。</returns>
        public bool CanExecute(object parameter)
        {
            return _canExecute == null ? true : _canExecute(parameter);
        }

        /// <summary>
        /// 当发生”影响命令是否应执行“的更改时发生。即当前命令的可执行状态改变，会引发事件。
        /// </summary>
        public event EventHandler CanExecuteChanged
        {
            add { CommandManager.RequerySuggested += value; }
            remove { CommandManager.RequerySuggested -= value; }
        }

        /// <summary>
        /// 调用命令时要调用的方法。
        /// </summary>
        /// <param name="parameter">此参数将始终被忽略。</param>
        public void Execute(object parameter)
        {
            _execute(parameter);
        }
    }
}

```



