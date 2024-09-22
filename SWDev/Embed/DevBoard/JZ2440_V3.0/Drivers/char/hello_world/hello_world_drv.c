/**
 * @file hello_world_drv.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief The "hello world" driver.
 * @version 0.1
 * @date 2022-06-25 18:20:15
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <linux/module.h>            /** THIS_MODULE. */
#include <linux/fs.h>                /** struct file_operations. */
#include <linux/init.h>              /** module_init and module_exit. */
#include <linux/kernel.h>            /** printk. */
#include <linux/device.h>            /** class_create, class_device_create. */

#define MODULE_NAME "hello_world_drv"
#define MODULE_PRINTF(format, args...) printk("["MODULE_NAME"] "format"\n", ##args)

static struct class *hello_world_class = NULL;
static struct class_device *hello_world_class_dev = NULL;
static int major = 0;

static int open(struct inode *inode, struct file *file)
{
    MODULE_PRINTF("open.");
    return 0;
}

static ssize_t write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
{
    MODULE_PRINTF("write.");
    return 0;
}

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = open,
    .write = write
};

/**
 * @brief  init
 * @return int,
 *         -1 - Failed to register char device.
 *         -2 - Failed to create class.
 *         -3 - Failed to create class device.
 */
static int __init hello_world_init(void)
{
    MODULE_PRINTF("init.");

    major = register_chrdev(0, "hello_world_drv", &fops);
    if (major < 0)
    {
        MODULE_PRINTF("Failed to register char device!");
        return -1;
    }

    hello_world_class = class_create(THIS_MODULE, "hello_world_drv");
    if (hello_world_class == NULL)
    {
        MODULE_PRINTF("Failed to create class!");
        return -2;
    }

    /**
     * Create /dev/hello_world_drv_dev.
     */
    hello_world_class_dev = class_device_create(hello_world_class, NULL, MKDEV(major, 0), NULL, "hello_world_drv_dev");
    if (hello_world_class_dev == NULL)
    {
        MODULE_PRINTF("Failed to create class device!");
        return -3;
    }

    return 0;
}

static void __exit hello_world_exit(void)
{
    MODULE_PRINTF("exit.");

    if (major > 0)
    {
        unregister_chrdev(major, "hello_world_drv");
    }

    if (hello_world_class_dev != NULL)
    {
        class_device_unregister(hello_world_class_dev);
    }

    if (hello_world_class != NULL)
    {
        class_destroy(hello_world_class);
    }
}

module_init(hello_world_init);
module_exit(hello_world_exit);

MODULE_AUTHOR("panxingyuan1@163.com");
MODULE_DESCRIPTION("hello world driver");
MODULE_LICENSE("GPL");
