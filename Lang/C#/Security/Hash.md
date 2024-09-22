# 1 MD5

- MD5值为128bits整数



## 1.1 例子

- 获取字符串的MD5值：

  ```c#
  using System;
  using System.Collections.Generic;
  using System.Linq;
  using System.Text;
  using System.Threading.Tasks;
  
  namespace MD5Test
  {
      class Program
      {
          static void Main(string[] args)
          {
              using(var md5 = System.Security.Cryptography.MD5.Create())
              {
                  string str = ",sjdfksdfm,dfdfdfgdgfgfg";
                  byte[] md5Value = md5.ComputeHash(Encoding.UTF8.GetBytes(str));
                  Console.WriteLine(md5Value.Length);
  
                  foreach (var item in md5Value)
                  {
                      Console.Write(item + " ");
                  }
                  Console.WriteLine();
  
                  StringBuilder sb = new StringBuilder();
                  foreach (var item in md5Value)
                  {
                      sb.Append(item.ToString("x2"));
                  }
                  Console.WriteLine(sb.ToString());
              }
          }
      }
  }
  ```

- 输出结果

  ![image-20220213201947811](Hash\MD5_1.png)