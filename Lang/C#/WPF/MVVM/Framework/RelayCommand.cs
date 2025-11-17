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
