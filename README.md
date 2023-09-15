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
