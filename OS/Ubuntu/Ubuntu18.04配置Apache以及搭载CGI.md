# 1 安装Apache

## 1.1 安装Apache2

```shell
linux@ubuntu:~$ sudo apt-get install apache2
```

## 1.2 用浏览器访问网址检查是否安装成功

www.127.0.0.1 or http://localhost

![LoginLocalHost](Images\LoginLocalHost.png)

## 1.3 停止Apache

```shell
linux@ubuntu:~$ sudo /etc/init.d/apache2 stop 
[ ok ] Stopping apache2 (via systemctl): apache2.service.
```

## 1.4 启动Apache

```shell
linux@ubuntu:~$ sudo /etc/init.d/apache2 start 
[ ok ] Starting apache2 (via systemctl): apache2.service.
```

## 1.5 重启Apache

```shell
linux@ubuntu:~$ sudo /etc/init.d/apache2 restart 
[ ok ] Restarting apache2 (via systemctl): apache2.service.
```

# 2 搭建Apache服务器

## 2.1 配置CGI

1. 创建一个目录文件cgi-bin，用于保存需要执行的cgi文件

   ```shell
   linux@ubuntu:/var/www$ sudo mkdir cgi-bin
   linux@ubuntu:/var/www$ ls
   cgi-bin  html
   ```

2. Apache2的配置文件在如下位置

   ```shell
   linux@ubuntu:/etc/apache2$ ls
   apache2.conf    conf-enabled  magic           mods-enabled  sites-available
   conf-available  envvars       mods-available  ports.conf    sites-enabled
   ```
-enabled中的文件是相应-available中文件的软链接

3.  查看mods-enabled中是否有如下文件：cgi.load、cgid.load，没有则创建软链接文件

   ```shell
   linux@ubuntu:/etc/apache2$ sudo ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load
   
   linux@ubuntu:/etc/apache2$ sudo ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/cgid.load
   ```

4. 修改conf-enabled中的serve-cgi-bin.conf文件如下位置

   原文件：

   ```shell
   <IfModule mod_alias.c>
       <IfModule mod_cgi.c>
           Define ENABLE_USR_LIB_CGI_BIN
       </IfModule>
   
       <IfModule mod_cgid.c>
           Define ENABLE_USR_LIB_CGI_BIN
       </IfModule>
   
       <IfDefine ENABLE_USR_LIB_CGI_BIN>
           ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
           <Directory "/usr/lib/cgi-bin">
               AllowOverride None
               Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
               Require all granted
           </Directory>
       </IfDefine>
   </IfModule>
   
   # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
   ```

   修改后：

   ```shell
   <IfModule mod_alias.c>
       <IfModule mod_cgi.c>
           Define ENABLE_USR_LIB_CGI_BIN
       </IfModule>
   
       <IfModule mod_cgid.c>
           Define ENABLE_USR_LIB_CGI_BIN
       </IfModule>
   
       <IfDefine ENABLE_USR_LIB_CGI_BIN>
           ScriptAlias /cgi-bin/ /var/www/cgi-bin/
           <Directory "/var/www/cgi-bin/">
               AllowOverride None
               Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
               Require all granted
               AddHandler cgi-script .cgi .pl
           </Directory>
       </IfDefine>
   </IfModule>
   
   # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
   ```

5. 修改sites-enabled中的文件000-default.conf如下位置

   ```shell
   DocumentRoot /var/www/html
   ```

   改为：

   ```shell
   DocumentRoot /var/www/cgi-bin/
   ```

## 2.2 重启Apache

```shell
linux@ubuntu:~$ sudo /etc/init.d/apache2 restart 
[ ok ] Restarting apache2 (via systemctl): apache2.service.
```

## 2.3 测试

1. 用浏览器访问网址检查

   www.127.0.0.1 or http://localhost

   ![LoginLocalHostSucceed](Images\LoginLocalHostSucceed.png)

2. 在/var/www/cgi-bin/下写个cgi程序进行测试，test.cgi

   ```shell
   linux@ubuntu:/var/www/cgi-bin$ sudo vi test.cgi
   ```

   ```shell
   #!/usr/bin/perl
    
   print "Content-type:text/html\r\n\r\n";
   print '<html>';
   print '<head>';
   print '<meta charset="utf-8">';
   print '<title>菜鸟教程(runoob.com)</title>';
   print '</head>';
   print '<body>';
   print '<h2>Hello Word! </h2>';
   print '<p>来自菜鸟教程第一个 CGI 程序。</p>';
   print '</body>';
   print '</html>';
   ```
   为test.cgi添加上可执行权限
   ```shell
   linux@ubuntu:/var/www/cgi-bin$ sudo chmod +x test.cgi
   linux@ubuntu:/var/www/cgi-bin$ ls -l
   total 4
   -rwxr-xr-x 1 root root 327 3月  10 20:47 test.cgi
   ```

   在浏览器中访问http://localhost/test.cgi
   
   ![LoginLocalHostSucceed2](Images\LoginLocalHostSucceed2.png)

## 2.4 可能出现的问题

- 403：可能是cgi-bin目录是个空目录，写个测试文件放里面
- 500：可能是需要为cgi文件文件加上可执行权限