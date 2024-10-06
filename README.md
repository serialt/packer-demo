## packer vm

使用 task 构建
* [task](https://github.com/go-task/task)


#### packer rocky
```shell
task rocky9-vmware
```

#### packer alma
```shell
task alma9-vmwar
```

#### packer cloud alma
```shell
cd cloud-images

packer.io build -var qemu_binary="/usr/libexec/qemu-kvm"  -only=qemu.almalinux-8-gencloud-x86_64 .
```
