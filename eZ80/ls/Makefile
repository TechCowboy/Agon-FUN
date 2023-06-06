
TARGET_EXEC ?= ls

EXTENSION := .bin

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

AS=../../../agon-ez80asm/bin/ez80asm 


TNFS_SERVER ?= $(shell echo $$TNFS_SERVER)
TNFS_SHARE  ?= $(shell echo $$TNFS_SHARE)
TNFS_DIR    ?= AGON
OS          ?= $(shell echo $$OS)


SRCS := $(shell find $(SRC_DIRS) -name *.asm)

ASFLAGS=-l 

$(BUILD_DIR)/$(TARGET_EXEC): 
	$(MKDIR_P) $(dir $@)
	$(AS) $(SRCS) $(BUILD_DIR)/$(TARGET_EXEC)$(EXTENSION) -l 

.PHONY: clean

clean:
	$(RM) -r $(TARGET_EXEC)* $(BUILD_DIR)

go:
	cp ./$(BUILD_DIR)/$(TARGET_EXEC)$(EXTENSION) $(AGONEM_PATH)
	cd "$(AGONEM_PATH)"; \
	cargo run &

tnfs: 
ifneq ('$(TNFS_SERVER)','')

ifneq ('$(OS)','')
	cp ./$(BUILD_DIR)/$(TARGET_EXEC)$(EXTENSION) //$(TNFS_SERVER)/$(TNFS_SHARE)/$(TNFS_DIR)
else
	cp ./$(BUILD_DIR)/$(TARGET_EXEC)$(EXTENSION) /run/user/1000/gvfs/smb-share:server=$(TNFS_SERVER),share=$(TNFS_SHARE)/$(TNFS_DIR)
endif
else
	$(info ***********************************************)
	$(info *** No TNFS server environment variable set ***)
	$(info ***********************************************)
endif

-include $(DEPS)

MKDIR_P ?= mkdir -p


