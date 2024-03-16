## packer vm

#### packer rocky
```shell
cd rockylinux
packer  build -only=vmware-iso.rockylinux-9-aarch64 .
```

#### packer alma
```shell
cd almalinux
packer  build -only=vmware-iso.almalinux-9-aarch64 . 
```

#### packer cloud alma
```shell
cd cloud-images

packer.io build -var qemu_binary="/usr/libexec/qemu-kvm"  -only=qemu.almalinux-8-gencloud-x86_64 .
```
