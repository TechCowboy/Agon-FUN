
TARGET_EXEC ?= keystatus

EXTENSION := .bin

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

AS=../../../agon-ez80asm/bin/ez80asm 


SRCS := $(shell find $(SRC_DIRS) -name *.asm)

ASFLAGS=-l 


$(BUILD_DIR)/$(TARGET_EXEC): 
	$(MKDIR_P) $(dir $@)
	echo $(SRCS)
	$(AS) $(SRCS) -l 
	mv $(SRC_DIRS)/$(TARGET_EXEC)$(EXTENSION) $(BUILD_DIR)


.PHONY: clean

clean:
	$(RM) -r $(TARGET_EXEC)* $(BUILD_DIR)

go:
	cp ./$(BUILD_DIR)/$(TARGET_EXEC)$(EXTENSION) $(AGONEM_PATH)
	cd "$(AGONEM_PATH)"; \
	cargo run &

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


