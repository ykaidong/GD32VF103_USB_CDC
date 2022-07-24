##### GD32V RISC-V MCU Makefile ######

######################################
# Target
######################################
TARGET = USB_CDC


######################################
# Source
######################################
# Standard peripheral
C_SOURCES =  \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_standard_peripheral/Source/*.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_standard_peripheral/*.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/drivers/*.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/env_Eclipse/*.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/stubs/*.c) \

# USB Lib
C_SOURCES += \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/driver/Source/drv_usb_core.c) \

# USB device
C_SOURCES += \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/driver/Source/drv_usb_dev.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/driver/Source/drv_usbd_int.c) \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/core/Source/*.c) \

# USB MSC
# C_SOURCES += \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/class/msc/Source/*.c) \

# USB CDC
C_SOURCES += \
$(wildcard GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/class/cdc/Source/*.c) \

# add your c sources here
C_SOURCES += \
$(wildcard ./src/*.c) \

# ASM sources
ASM_SOURCES =  \
GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/env_Eclipse/start.s \
GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/env_Eclipse/entry.s \


######################################
# Includes
######################################
# Standard peripheral
C_INCLUDES =  \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_standard_peripheral/Include \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_standard_peripheral \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/drivers \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/stubs \

# USB Lib
C_INCLUDES += \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/driver/Include \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/ustd/class/cdc \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/ustd/class/hid \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/ustd/class/msc \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/ustd/common \

# USB device
C_INCLUDES += \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/core/Include \

# USB MSC
# C_INCLUDES += \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/class/msc/Include \

# USB CDC
C_INCLUDES += \
-I GD32VF103_Firmware_Library_V1.1.3/Firmware/GD32VF103_usbfs_library/device/class/cdc/Include \

# add your includes here
C_INCLUDES += \
-I ./inc \

# AS includes
AS_INCLUDES = 


######################################
# Building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og

# Build path
BUILD_DIR = build


######################################
# Defines
######################################
# macros for gcc
C_DEFS =  \
-D USE_STDPERIPH_DRIVER \
-D HXTAL_VALUE=8000000U \
-D USE_USB_FS \

# AS defines
AS_DEFS = 


#######################################
# Linker
#######################################
# link script
LDSCRIPT = GD32VF103_Firmware_Library_V1.1.3/Firmware/RISCV/env_Eclipse/GD32VF103xB.lds


#######################################
# Binaries
#######################################
PREFIX = riscv-nuclei-elf-
# PREFIX = riscv32-unknown-elf-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
AR = $(PREFIX)ar
SZ = $(PREFIX)size
OD = $(PREFIX)objdump
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 

#######################################
# Flags
#######################################
# architecture
ARCH = -march=rv32imac -mabi=ilp32 -mcmodel=medlow

# compile gcc flags
CFLAGS = $(ARCH) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wl,-Bstatic #, -ffreestanding -nostdlib
ASFLAGS = $(ARCH) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wl,-Bstatic #, -ffreestanding -nostdlib

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" # -MT"$(@:%.o=%.d)"

# Generation a separate ELF section for each function and variable in the source file
# Cooperate -Wl,--gc-sections option to eliminating the unused code and data
# from the final executable
CFLAGS += -ffunction-sections -fdata-sections

# libraries
LIBS = -lc_nano -lm
LIBDIR = 
LDFLAGS = $(ARCH) -T$(LDSCRIPT) $(LIBDIR) $(LIBS) $(PERIFLIB_SOURCES) -Wl,--no-relax -Wl,--gc-sections -Wl,-Map,$(BUILD_DIR)/$(TARGET).map -nostartfiles #-ffreestanding -nostdlib

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# Build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	@echo "CC $<"
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	@echo "AS $<"
	@$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	@echo "LD $@"
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "OD $@"
	@$(OD) $(BUILD_DIR)/$(TARGET).elf -xS > $(BUILD_DIR)/$(TARGET).s $@
	@echo "SZ $@"
	@$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@


#######################################
# Clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)


#######################################
# Program
#######################################
flash: all
	$()openocd -c "adapter driver cmsis-dap; adapter speed 5000; transport select jtag" -f target/gd32vf103.cfg -c "program $(BUILD_DIR)/$(TARGET).elf" -c "reset; exit"

debug: all
	$()openocd -c "adapter driver cmsis-dap; adapter speed 5000; transport select jtag" -f target/gd32vf103.cfg 

dfu: all
	$()dfu-util -a 0 -s 0x08000000:leave -D $(BUILD_DIR)/$(TARGET).bin


#######################################
# dependencies
#######################################
# -include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)
-include $(wildcard $(BUILD_DIR)/*.d)
