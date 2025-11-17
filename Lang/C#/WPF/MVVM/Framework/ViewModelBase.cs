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
