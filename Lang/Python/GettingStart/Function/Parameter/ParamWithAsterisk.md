# 函数中星号的使用

## 函数定义

1. 使用单个\*，会将所有的参数放入一个元组（tuple）供函数使用。
2. 使用两个\*\*，会将所有的关键字参数，放入一个字典（dict）供函数使用。

## 函数调用

1. 在list、tuple、set前加一个\*会把容器中的所有元素解包（unpack）编程位置参数。
2. 在dict前加一个\*会把字典的键变成位置参数。
3. 在dict前加两个星号会把字典的键值变成关键字参数。

## 示例

```python
def test(*arg):
    print(arg)


def test2(**arg):
    print(arg)


a = [1, 2, 3, 4, 5]
test(*a)                    # (1, 2, 3, 4, 5)
test(a)                     # ([1, 2, 3, 4, 5],)
test(1, 2, 3, 4, 5)         # (1, 2, 3, 4, 5)
# test2(**a)                  # TypeError: __main__.test2() argument after ** must be a mapping, not list
# test2(*a)                   # TypeError: test2() takes 0 positional arguments but 5 were given
# test2(a)                    # TypeError: test2() takes 0 positional arguments but 1 was given

print()

b = {'a': 'Ass', 'b': 'We', 'c': 'Can'}
test2(**b)                          # {'a': 'Ass', 'b': 'We', 'c': 'Can'}
# test2(*b)                           # TypeError: test2() takes 0 positional arguments but 3 were given
# test2(b)                            # TypeError: test2() takes 0 positional arguments but 1 was given
test2(a='Ass', b='We', c='Can')     # {'a': 'Ass', 'b': 'We', 'c': 'Can'}
# test(**b)                           # TypeError: test() got an unexpected keyword argument 'a'
test(*b)                            # ('a', 'b', 'c')
test(b)                             # ({'a': 'Ass', 'b': 'We', 'c': 'Can'},)

```





