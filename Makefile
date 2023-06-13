# Makefile

# 定义编译器和链接器
ASM = nasm
CC = rustc
LD = ld
OBJCOPY = objcopy

# 定义编译选项
ASMBFLAGS = -f elf -w-orphan-labels
LDFLAGS = -T linker.lds
OJCYFLAGS = -S -O binary

# 定义源文件和目标文件
SRC_ASM = entry.asm
OBJ_ASM = entry.o
OBJ_RUST = target/i386-unknown-none-elf/release/librust_os.a
OBJ_ELF = HelloOS.elf
OBJ_BIN = HelloOS.bin

# 定义编译规则
all: clean build link bin

build:
	$(ASM) $(ASMBFLAGS) -o $(OBJ_ASM) $(SRC_ASM)
	cargo +nightly build --release -Z build-std=core --target i386-unknown-none-elf.json
link:
	$(LD) $(LDFLAGS) -o  $(OBJ_ELF) $(OBJ_ASM) $(OBJ_RUST)

bin:
	$(OBJCOPY) $(OJCYFLAGS) $(OBJ_ELF) $(OBJ_BIN)

clean:
	rm -f $(OBJ_ASM) $(OBJ_ELF) $(OBJ_BIN)
	cargo clean

.PHONY: all clean build link bin