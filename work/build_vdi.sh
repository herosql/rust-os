# 删除名为"HelloOS"的虚拟机（如果存在）并删除所有相关文件
VBoxManage unregistervm "HelloOS" --delete 2>/dev/null
# 创建一个名为"HelloOS"的新虚拟机，操作系统设置为Other/Unknown (64-bit)
VBoxManage createvm --name "HelloOS" --ostype "Other_64" --register
# 设置虚拟机的内存配置为1024MB
VBoxManage modifyvm "HelloOS" --memory 1024
VBoxManage convertfromraw ./hd.img --format VDI ./hd.vdi
VBoxManage storagectl HelloOS --name "SATA" --add sata --controller IntelAhci --portcount 1
VBoxManage closemedium disk ./hd.vdi
VBoxManage storageattach HelloOS --storagectl "SATA" --port 1 --device 0 --type hdd --medium ./hd.vdi
VBoxManage startvm HelloOS
