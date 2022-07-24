
使用GD32VF103的USB固件库模拟USB串口, 硬件为TTGO-T-Display-GD32, 官方例程, 更改为使用Makefile编译, 有以下几点需要注意的:

1. 如果要使用USB, 时钟频率需要调整到96MHz, 修改 GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_standard_peripheral/system_gd32vf103.c, 启用 __SYSTEM_CLOCK_96M_PLL_HXTAL 宏即可.

2. GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library中的四个目录:
device: 主机模式和设备模式都要使用
driver: 主机模式和设备模式都要使用
ustd: 主机模式和设备模式都要使用
host: 主机模式下使用
在driver/source文件夹中, 主机模式和从机模式所需要的文件全部都在其中, 不能将主机模式下需要的文件编译进工程, 否则会起冲突, 所以在Makefile中指定了文件名.

4. 在Makefile中定义 USE_USB_FS 宏.

3. 在 usb_conf.h 中将 #include "gd32vf103v_eval.h" 删除, 并添加下面一段:

```c
/* __packed keyword used to decrease the data type alignment to 1-byte */
#if defined (__CC_ARM)         /* ARM Compiler */
    #define __packed __packed
#elif defined (__ICCARM__)     /* IAR Compiler */
    #define __packed __packed
#elif defined (__GNUC__)       /* GNU Compiler */
    #define __packed __attribute__ ((__packed__))
#elif defined (__TASKING__)    /* TASKING Compiler */
    #define __packed __unaligned
#endif /* __CC_ARM */
```

