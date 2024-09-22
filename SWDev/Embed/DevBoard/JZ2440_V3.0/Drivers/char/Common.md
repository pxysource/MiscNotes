# 相关头文件

## fs.h

`include/linux/fs.h`

### struct file_operations

```c
/*
 * NOTE:
 * read, write, poll, fsync, readv, writev, unlocked_ioctl and compat_ioctl
 * can be called without the big kernel lock held in all filesystems.
 */
struct file_operations {
	struct module *owner;
	loff_t (*llseek) (struct file *, loff_t, int);
	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
	int (*readdir) (struct file *, void *, filldir_t);
	unsigned int (*poll) (struct file *, struct poll_table_struct *);
	int (*ioctl) (struct inode *, struct file *, unsigned int, unsigned long);
	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
	int (*mmap) (struct file *, struct vm_area_struct *);
	int (*open) (struct inode *, struct file *);
	int (*flush) (struct file *, fl_owner_t id);
	int (*release) (struct inode *, struct file *);
	int (*fsync) (struct file *, struct dentry *, int datasync);
	int (*aio_fsync) (struct kiocb *, int datasync);
	int (*fasync) (int, struct file *, int);
	int (*lock) (struct file *, int, struct file_lock *);
	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t, void *);
	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
	int (*check_flags)(int);
	int (*dir_notify)(struct file *filp, unsigned long arg);
	int (*flock) (struct file *, int, struct file_lock *);
	ssize_t (*splice_write)(struct pipe_inode_info *, struct file *, loff_t *, size_t, unsigned int);
	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *, size_t, unsigned int);
};
```

### register_chrdev

```c
/**
 * register_chrdev() - Register a major number for character devices.
 * @major: major device number or 0 for dynamic allocation
 * @name: name of this range of devices
 * @fops: file operations associated with this devices
 *
 * If @major == 0 this functions will dynamically allocate a major and return
 * its number.
 *
 * If @major > 0 this function will attempt to reserve a device with the given
 * major number and will return zero on success.
 *
 * Returns a -ve errno on failure.
 *
 * The name of this device has nothing to do with the name of the device in
 * /dev. It only helps to keep track of the different owners of devices. If
 * your module name has only one type of devices it's ok to use e.g. the name
 * of the module here.
 *
 * This function registers a range of 256 minor numbers. The first minor number
 * is 0.
 */
extern int register_chrdev(unsigned int major, const char *name,
		    const struct file_operations *fops);
```

### unregister_chrdev

```c
extern int unregister_chrdev(unsigned int major, const char *name);
```

## module.h

`include/linux/module.h`

### THIS_MODULE

```c
extern struct module __this_module;
#define THIS_MODULE (&__this_module)
```

### MODULE_AUTHOR

```c
/* Author, ideally of form NAME[, NAME]*[ and NAME] */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
```

### MODULE_DESCRIPTION

```c
/* What your module does. */
#define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
```

### MODULE_LICENSE

```c
/*
 * The following license idents are currently accepted as indicating free
 * software modules
 *
 *	"GPL"				[GNU Public License v2 or later]
 *	"GPL v2"			[GNU Public License v2]
 *	"GPL and additional rights"	[GNU Public License v2 rights and more]
 *	"Dual BSD/GPL"			[GNU Public License v2
 *					 or BSD license choice]
 *	"Dual MIT/GPL"			[GNU Public License v2
 *					 or MIT license choice]
 *	"Dual MPL/GPL"			[GNU Public License v2
 *					 or Mozilla license choice]
 *
 * The following other idents are available
 *
 *	"Proprietary"			[Non free products]
 *
 * There are dual licensed components, but when running with Linux it is the
 * GPL that is relevant so this is a non issue. Similarly LGPL linked with GPL
 * is a GPL combined work.
 *
 * This exists for several reasons
 * 1.	So modinfo can show license info for users wanting to vet their setup 
 *	is free
 * 2.	So the community can ignore bug reports including proprietary modules
 * 3.	So vendors can do likewise based on their own policies
 */
#define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
```

## init.h

`include/linux/init.h`

### module_init

```c
/* Each module must use one module_init(), or one no_module_init */
#define module_init(initfn)					\
	static inline initcall_t __inittest(void)		\
	{ return initfn; }					\
	int init_module(void) __attribute__((alias(#initfn)));
```

### module_exit

```c
/* This is only required if you want to be unloadable. */
#define module_exit(exitfn)					\
	static inline exitcall_t __exittest(void)		\
	{ return exitfn; }					\
	void cleanup_module(void) __attribute__((alias(#exitfn)));
```

## device.h

`include/linux/module.h`

### struct class

```c
/*
 * device classes
 */
struct class {
	const char		* name;
	struct module		* owner;

	struct kset		subsys;
	struct list_head	children;
	struct list_head	devices;
	struct list_head	interfaces;
	struct kset		class_dirs;
	struct semaphore	sem;	/* locks both the children and interfaces lists */

	struct class_attribute		* class_attrs;
	struct class_device_attribute	* class_dev_attrs;
	struct device_attribute		* dev_attrs;

	int	(*uevent)(struct class_device *dev, char **envp,
			   int num_envp, char *buffer, int buffer_size);
	int	(*dev_uevent)(struct device *dev, char **envp, int num_envp,
				char *buffer, int buffer_size);

	void	(*release)(struct class_device *dev);
	void	(*class_release)(struct class *class);
	void	(*dev_release)(struct device *dev);

	int	(*suspend)(struct device *, pm_message_t state);
	int	(*resume)(struct device *);
};
```

### struct class_device

```c

/**
 * struct class_device - class devices
 * @class: pointer to the parent class for this class device.  This is required.
 * @devt: for internal use by the driver core only.
 * @node: for internal use by the driver core only.
 * @kobj: for internal use by the driver core only.
 * @devt_attr: for internal use by the driver core only.
 * @groups: optional additional groups to be created
 * @dev: if set, a symlink to the struct device is created in the sysfs
 * directory for this struct class device.
 * @class_data: pointer to whatever you want to store here for this struct
 * class_device.  Use class_get_devdata() and class_set_devdata() to get and
 * set this pointer.
 * @parent: pointer to a struct class_device that is the parent of this struct
 * class_device.  If NULL, this class_device will show up at the root of the
 * struct class in sysfs (which is probably what you want to have happen.)
 * @release: pointer to a release function for this struct class_device.  If
 * set, this will be called instead of the class specific release function.
 * Only use this if you want to override the default release function, like
 * when you are nesting class_device structures.
 * @uevent: pointer to a uevent function for this struct class_device.  If
 * set, this will be called instead of the class specific uevent function.
 * Only use this if you want to override the default uevent function, like
 * when you are nesting class_device structures.
 */
struct class_device {
	struct list_head	node;

	struct kobject		kobj;
	struct class		* class;	/* required */
	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
	struct class_device_attribute *devt_attr;
	struct class_device_attribute uevent_attr;
	struct device		* dev;		/* not necessary, but nice to have */
	void			* class_data;	/* class-specific data */
	struct class_device	*parent;	/* parent of this child device, if there is one */
	struct attribute_group  ** groups;	/* optional groups */

	void	(*release)(struct class_device *dev);
	int	(*uevent)(struct class_device *dev, char **envp,
			   int num_envp, char *buffer, int buffer_size);
	char	class_id[BUS_ID_SIZE];	/* unique to this class */
};

```

### class_create

```c
/**
 * class_create - create a struct class structure
 * @owner: pointer to the module that is to "own" this struct class
 * @name: pointer to a string for the name of this class.
 *
 * This is used to create a struct class pointer that can then be used
 * in calls to class_device_create().
 *
 * Note, the pointer created here is to be destroyed when finished by
 * making a call to class_destroy().
 */
extern struct class *class_create(struct module *owner, const char *name)
```

### class_destroy

```c
/**
 * class_destroy - destroys a struct class structure
 * @cls: pointer to the struct class that is to be destroyed
 *
 * Note, the pointer to be destroyed must have been created with a call
 * to class_create().
 */
extern void class_destroy(struct class *cls)
```

### class_device_create

```c
/**
 * class_device_create - creates a class device and registers it with sysfs
 * @cls: pointer to the struct class that this device should be registered to.
 * @parent: pointer to the parent struct class_device of this new device, if any.
 * @devt: the dev_t for the char device to be added.
 * @device: a pointer to a struct device that is assiociated with this class device.
 * @fmt: string for the class device's name
 *
 * This function can be used by char device classes.  A struct
 * class_device will be created in sysfs, registered to the specified
 * class.
 * A "dev" file will be created, showing the dev_t for the device, if
 * the dev_t is not 0,0.
 * If a pointer to a parent struct class_device is passed in, the newly
 * created struct class_device will be a child of that device in sysfs.
 * The pointer to the struct class_device will be returned from the
 * call.  Any further sysfs files that might be required can be created
 * using this pointer.
 *
 * Note: the struct class passed to this function must have previously
 * been created with a call to class_create().
 */
extern struct class_device *class_device_create(struct class *cls,
						struct class_device *parent,
						dev_t devt,
						struct device *device,
						const char *fmt, ...)
					__attribute__((format(printf,5,6)));
```

### class_device_destroy

```c
/**
 * class_device_destroy - removes a class device that was created with class_device_create()
 * @cls: the pointer to the struct class that this device was registered * with.
 * @devt: the dev_t of the device that was previously registered.
 *
 * This call unregisters and cleans up a class device that was created with a
 * call to class_device_create()
 */
extern void class_device_destroy(struct class *cls, dev_t devt);
```

## kdev_t.h

`include/linux/kdev_t.h`

### MAJOR

```c
#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
```

### MINOR

```c
#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
```

### MKDEV

```c
#define MKDEV(ma,mi)	(((ma) << MINORBITS) | (mi))
```

## io.h

`include/asm-arm/io.h`

### ioremap

```c
#define ioremap(cookie,size)		__arm_ioremap(cookie, size, MT_DEVICE)
```

### iounmap

```c
#define iounmap(cookie)			__iounmap(cookie)
```

## uaccess.h

`include/asm-arm/uaccess.h`

### copy_from_user

```c
static inline unsigned long __must_check copy_from_user(void *to, const void __user *from, unsigned long n)
```

### copy_to_user

```c
static inline unsigned long __must_check copy_to_user(void __user *to, const void *from, unsigned long n)
```

# shell命令

### insmod

加载驱动模块

```c
# ls                        
Makefile               hello_world_app.c      hello_world_drv.mod.c
Module.symvers         hello_world_drv.c      hello_world_drv.mod.o
hello_world_app        hello_world_drv.ko     hello_world_drv.o
# insmod hello_world_drv.ko 
init.
```

### lsmod

查看已加载驱动模块

```c
# lsmod 
Module                  Size  Used by    Not tainted
hello_world_drv         1924  0 

```

### rmmod

卸载驱动模块

```c
# rmmod hello_world_drv 
exit.

```

### cat /proc/devices

查看所有设备

```c
# cat /proc/devices 
Character devices:
  1 mem
  2 pty
  3 ttyp
  4 /dev/vc/0
  4 tty
  4 ttyS
  5 /dev/tty
  5 /dev/console
  5 /dev/ptmx
  6 lp
  7 vcs
 10 misc
 13 input
 14 sound
 29 fb
 90 mtd
 99 ppdev
111 hello_world_drv
116 alsa
128 ptm
136 pts
180 usb
189 usb_device
204 s3c2410_serial
253 usb_endpoint
254 rtc

Block devices:
  1 ramdisk
  7 loop
  8 sd
 31 mtdblock
 65 sd
 66 sd
 67 sd
 68 sd
 69 sd
 70 sd
 71 sd
128 sd
129 sd
130 sd
131 sd
132 sd
133 sd
134 sd
135 sd
179 mmc

```

- Character devices：字符设备
- Block devices：块设备
- 设备前面的数字为`主设备号`

`hello_world_drv`，加载`hello_world_drv.ko`驱动模块时创建的设备

### mknod

创建设备节点，即在`/dev`目录下创建一个设备文件

```c
# mknod /dev/xxx c 111 0
# 
# ls -l /dev/xxx
crw-r--r--    1 0        0        111,   0 Jan  1 02:30 /dev/xxx

```

- `/dev/xxx`为设备节点名称
- `c`指定创建字符设备节点
- 111为主设备号，0为次设备号
- `设备节点`与`设备`通过设备号关联，与设备的名称无关

- 直接删除设备文件(`rm /dev/xxx`)，即可删除设备节点