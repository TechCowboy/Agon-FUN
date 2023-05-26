# set these environment variables in your .bashrc or windows environment
# to automagically copy the TARGET_EXEC file to the TNFS server

# .bashrc
# TNFS_SERVER="192.168.2.21" or if in windows "\\server"
# TNFS_SHARE="tnfs" - the name of the share
# export TNFS_SERVER
# export TNFS_SHARE
#
# windows
# SET TNFS_SERVER=tnfs
# SET TNFS_SHARE=tnfs
#
# TNFS_DIR - the directory within the share


# COLEM_EXEC Coleco vision emulator executible with full path 
# NABEM_PATH NABU emulator executible path
# NABEM_EXEC NABU emulator executible name
# APPEM_EXEC Apple emualtor executible with full path

PROJECT_DEVICE := agon

TARGET_EXEC ?= hello

EXTENSION := 

ifeq ('$(PROJECT_DEVICE)', 'adam')
	EXTENSION := .ddp
endif

ifeq ('$(PROJECT_DEVICE)', 'agon')
	EXTENSION := .bin
endif

ifeq ('$(PROJECT_DEVICE)','apple')
	EXTENSION := .po
endif

ifeq ('$(OS)','')
	WINE_REQUIRED := wine
else
	WINE_REQUIRED := 
endif

TNFS_SERVER ?= $(shell echo $$TNFS_SERVER)
TNFS_SHARE  ?= $(shell echo $$TNFS_SHARE)
TNFS_DIR    ?= AGON
OS          ?= $(shell echo $$OS)

COLEM_EXEC  ?= $(shell echo $$COLEM_EXEC)
COLEM_WINE  :=
NABEM_PATH  ?= $(shell echo $$NABEM_PATH)
NABEM_EXEC  ?= $(shell echo $$NABEM_EXEC)
NABEM_WINE  := WINE_REQUIRED
APPEM_EXEC  ?= $(shell echo $$APPEM_EXEC)
APPEM_WINE  := WINE_REQURED
AGONEM_EXEC ?= $(shell echo $$AGONEM_EXEC)
AGONEM_WINE :=

NABU_CACHE  ?= $(shell echo $$NABU_CACHE)
NABU_WINE   := WINE_REQURED


BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

CC=zcc
AS=zcc

ADDL_DIR1 := ../../agon-mos/src
ADDL_DIR2 := $(Z88DK_HOME)
ADDL_DIR3 := src

ADDL_LIB1 := 
ADDL_LIB2 := 

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.asm)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CFLAGS=+agon -pragma-define:CRT_ORG_BSS=0x4000 -pragma-define:REGISTER_SP=0x0000  -DBUILD_AGON  -I$(ADDL_DIR1) -I$(ADDL_DIR2) -I$(ADDL_DIR3)
LDFLAGS=+agon -clib=classic -m -s -o$(TARGET_EXEC) -create-app -l$(ADDL_LIB1) -l$(ADDL_LIB2) 
ASFLAGS=+agon 

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS)
	z88dk-dis -o 0x0000 -x hello.map hello.bin > hello.lst

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# asm source
$(BUILD_DIR)/%.asm.o: %.asm
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c -o$@  $< 


.PHONY: clean

clean:
	$(RM) -r $(TARGET_EXEC)* $(BUILD_DIR)

go:
ifeq ('$(PROJECT_DEVICE)','adam')
	$(COLEM_WINE) "$(COLEM_EXEC)" -ntsc -adam $(TARGET_EXEC).ddp
endif
ifeq ('$(PROJECT_DEVICE)','apple')
	$(APPEM_WINE) "$(APPEM_EXEC)" -d1 $(TARGET_EXEC).po
endif
ifeq ('$(PROJECT_DEVICE)','nabu')
	cp ./$(TARGET_EXEC) "$(NABU_CACHE)/000001.nabu"
	cd "$(NABEM_PATH)"; \
	$(NABUEM_WINE) "$(NABEM_PATH)/$(NABEM_EXEC)" nabupc -window -kbd nabu_hle -hcca null_modem -bitb socket.127.0.0.1:5816
endif
ifeq ('$(PROJECT_DEVICE)', 'agon')
	cp ./$(TARGET_EXEC)$(EXTENSION) $(AGONEM_PATH)
	cd "$(AGONEM_PATH)"; \
	cargo run &
endif

tnfs: $(TARGET_EXEC)$(EXTENSION) 
ifneq ('$(TNFS_SERVER)','')

ifneq ('$(OS)','')
	cp $(TARGET_EXEC)$(EXTENSION). //$(TNFS_SERVER)/$(TNFS_SHARE)/$(TNFS_DIR)
else
	cp $(TARGET_EXEC)$(EXTENSION) /run/user/1000/gvfs/smb-share:server=$(TNFS_SERVER),share=$(TNFS_SHARE)/$(TNFS_DIR)
endif
else
	$(info ***********************************************)
	$(info *** No TNFS server environment variable set ***)
	$(info ***********************************************)
endif

-include $(DEPS)

MKDIR_P ?= mkdir -p


