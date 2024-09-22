# typeof

## 简介

- typeof关键字是C语言中的一个新扩展，这个特性在linux内核中应用非常广泛。

## 参数

- typeof的参数可以是两种形式：表达式或类型。

### 表达式参数

```c
// 这里假设x是一个函数指针数组，这样就可以得到这个函数返回值的类型了。
typeof(x[0](1))
```

- 如果将typeof用于表达式，则该表达式不会执行。只会得到该表达式的类型。

```c
// 以下示例声明了int类型的var变量，因为表达式foo()是int类型的。
// 由于表达式不会被执行，所以不会调用foo函数。
extern int foo();
typeof(foo()) var;
```

### 类型参数

```c
typeof(int *) a,b;
// 等价于：
int *a,*b;
```

## 使用typeof创建变量

1. 把y定义成x指向的数据类型：

   ```c
   typeof(*x) y;
   ```

2. 把y定义成x指向数据类型的数组：

   ```c
   typeof(*x) y[4];
   ```

3. Declares two int pointers p1, p2.

   ```c
   // Declares two int pointers p1, p2.
   // int *p1, *p2;
   typeof(int *) p1,p2;
   ```

4. Declares int pointer p3 and int p4.

   ```c
   // Declares int pointer p3 and int p4.
   // int *p3, p4;
   typeof(int) *p3,p4;
   ```

5. Declares two arrays of integers.

   ```c
   // Declares two arrays of integers.
   // int a1[10], a2[10];
   typeof(int [10]) a1, a2;
   ```

## 局限

- typeof构造中的类型名不能包含存储类说明符，如extern或static。不过允许包含类型限定符，如const或volatile。如：

```c
// 例如，下列代码是无效的，因为它在typeof构造中声明了extern：
typeof(extern int) a;
```

