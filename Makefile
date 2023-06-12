# Makefile

# 定义编译器和链接器
ASM = nasm
CC = rustc
LD = ld
OBJCOPY = objcopy

# 定义编译选项
ASMBFLAGS = -f elf -w-orphan-labels
CFLAGS = --target i686-unknown-none-elf.json
LDFLAGS = -T linker.lds
OJCYFLAGS = -S -O binary

# 定义源文件和目标文件
SRC_ASM = boot.asm
OBJ_ASM = boot.o
OBJ_RUST = target/i686-unknown-none-elf/debug/librust_os.rlib
OBJ_ELF = HelloOS.elf
OBJ_BIN = HelloOS.bin

# 定义编译规则
all: clean build link bin

build:
	$(ASM) $(ASMBFLAGS) -o $(OBJ_ASM) $(SRC_ASM)
	cargo +nightly build -Z build-std=core $(CFLAGS)

link:
	$(LD) $(LDFLAGS) -o  $(OBJ_ELF) $(OBJ_ASM) $(OBJ_RUST)

bin:
	$(OBJCOPY) $(OJCYFLAGS) $(OBJ_ELF) $(OBJ_BIN)

clean:
	rm -f $(OBJ_ASM) $(OBJ_ELF) $(OBJ_BIN)
	cargo clean

.PHONY: all clean build link bin