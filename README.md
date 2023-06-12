# rust-os
基于rust实现操作系统

## 简单的os
编译汇编文件
```shell
nasm -f elf64 boot.asm -o boot.o
rustup install nightly
cargo +nightly build -Z build-std=core --target i686-unknown-none-elf.json
ld -T linker.ld -o Hello.bin boot.o target/i686-unknown-none-elf/debug/librust_os.rlib
# 将所有命令组合起来,使用 make


```
### 注意
cargo 自定义的 target 必须用到+nightly,我们绕过了官方提供的工具,从而要使用自由度比较高的形式
boot.asm中的定义系统的位数和我们定义的程序编译的二进制规格要一致
32位系统对应i686的系统
## 引导系统
在work文件夹下
```shell
#手动创建虚拟硬盘
dd bs=512 if=/dev/zero of=hd.img count=204800
#挂载回环设备
sudo losetup /dev/loop0 hd.img
#挂载不上查看回环设备
sudo losetup -f
#延后序号
sudo losetup /dev/loop20 hd.img
#设置文件格式
sudo mkfs.ext4 -q /dev/loop20
sudo mkfs.fat -F32 /dev/loop20
#挂载硬盘文件
sudo mount -o loop ./hd.img ./hdisk/
#建立boot目录
sudo mkdir ./hdisk/boot/
#建立efi目录
sudo mkdir ./hdisk/boot/efi
#安装GRUB
sudo grub-install --boot-directory=./hdisk/boot/ --target i386-pc --force --allow-floppy /dev/loop20
#转换为虚拟硬盘
VBoxManage convertfromraw ./hd.img --format VDI ./hd.vdi
VBoxManage storagectl HelloOS --name "SATA" --add sata --controller IntelAhci --portcount 1
VBoxManage closemedium disk ./hd.vdi
VBoxManage storageattach HelloOS --storagectl "SATA" --port 1 --device 0 --type hdd --medium ./hd.vdi
VBoxManage startvm HelloOS
```