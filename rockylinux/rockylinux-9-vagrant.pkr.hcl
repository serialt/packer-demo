/*
 * RockyLinux OS 9 Packer template for building Vagrant boxes.
 */

source "virtualbox-iso" "rockylinux-9" {
  iso_url              = local.iso_url_9_x86_64
  iso_checksum         = local.iso_checksum_9_x86_64
  boot_command         = local.vagrant_boot_command_9_x86_64
  boot_wait            = var.boot_wait
  cpus                 = var.cpus
  memory               = var.memory
  disk_size            = var.vagrant_disk_size
  headless             = var.headless
  http_directory       = var.http_directory
  guest_os_type        = "RedHat_64"
  shutdown_command     = var.vagrant_shutdown_command
  ssh_username         = var.vagrant_ssh_username
  ssh_password         = var.vagrant_ssh_password
  ssh_timeout          = var.ssh_timeout
  hard_drive_interface = "sata"
  iso_interface        = "sata"
  firmware             = "efi"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--memory", var.post_memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.post_cpus]
  ]
}

source "virtualbox-iso" "rockylinux-9-aarch64" {
  iso_url              = local.iso_url_9_aarch64
  iso_checksum         = local.iso_checksum_9_aarch64
  boot_command         = var.vagrant_boot_command_9_aarch64
  boot_wait            = var.boot_wait
  cpus                 = var.cpus
  memory               = var.memory
  disk_size            = var.vagrant_disk_size
  headless             = var.headless
  http_directory       = var.http_directory
  guest_os_type        = "RedHat_64"
  shutdown_command     = var.vagrant_shutdown_command
  ssh_username         = var.vagrant_ssh_username
  ssh_password         = var.vagrant_ssh_password
  ssh_timeout          = var.ssh_timeout
  hard_drive_interface = "sata"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]
  vboxmanage_post = [
    ["modifyvm", "{{.Name}}", "--memory", var.post_memory],
    ["modifyvm", "{{.Name}}", "--cpus", var.post_cpus]
  ]
}

source "vmware-iso" "rockylinux-9" {
  iso_url          = local.iso_url_9_x86_64
  iso_checksum     = local.iso_checksum_9_x86_64
  boot_command     = var.vagrant_boot_command_9_x86_64_bios
  boot_wait        = var.boot_wait
  cpus             = var.cpus
  memory           = var.memory
  disk_size        = var.vagrant_disk_size
  headless         = var.headless
  http_directory   = var.http_directory
  guest_os_type    = "centos-64"
  shutdown_command = var.vagrant_shutdown_command
  ssh_username     = var.vagrant_ssh_username
  ssh_password     = var.vagrant_ssh_password
  ssh_timeout      = var.ssh_timeout
  vmx_data = {
    "cpuid.coresPerSocket" : "1"
  }
  vmx_data_post = {
    "memsize" : var.post_memory
    "numvcpus" : var.post_cpus
  }

  vmx_remove_ethernet_interfaces = true
}

source "qemu" "rockylinux-9" {
  iso_checksum       = local.iso_checksum_9_x86_64
  iso_url            = local.iso_url_9_x86_64
  shutdown_command   = var.vagrant_shutdown_command
  accelerator        = "kvm"
  http_directory     = var.http_directory
  ssh_username       = var.vagrant_ssh_username
  ssh_password       = var.vagrant_ssh_password
  ssh_timeout        = var.ssh_timeout
  cpus               = var.cpus
  efi_firmware_code  = var.ovmf_code
  efi_firmware_vars  = var.ovmf_vars
  disk_interface     = "virtio-scsi"
  disk_size          = var.vagrant_disk_size
  disk_cache         = "unsafe"
  disk_discard       = "unmap"
  disk_detect_zeroes = "unmap"
  disk_compression   = true
  format             = "qcow2"
  headless           = var.headless
  machine_type       = "q35"
  memory             = var.memory
  net_device         = "virtio-net"
  qemu_binary        = var.qemu_binary
  vm_name            = "rockylinux-9"
  boot_wait          = var.boot_wait
  boot_command       = local.vagrant_boot_command_9_x86_64
  qemuargs = [
    ["-cpu", "host"]
  ]
}

source "vmware-iso" "rockylinux-9-aarch64" {
  iso_url          = local.iso_url_9_aarch64
  iso_checksum     = local.iso_checksum_9_aarch64
  boot_command     = var.vagrant_boot_command_9_aarch64
  boot_wait        = var.boot_wait
  cpus             = var.cpus
  memory           = var.memory
  disk_size        = var.vagrant_disk_size
  headless         = var.headless
  http_directory   = var.http_directory
  guest_os_type    = "arm-rhel9-64"
  shutdown_command = var.vagrant_shutdown_command
  ssh_username     = var.vagrant_ssh_username
  ssh_password     = var.vagrant_ssh_password
  ssh_timeout      = var.ssh_timeout
  vmx_data = {
    ".encoding"      = "UTF-8",
    "config.version" = "8",
    "virtualHW.version"    = "20",
    "usb_xhci.present"     = "true",
    "ethernet0.virtualdev" = "e1000e",
    "firmware"             = "efi"
  }
  vmx_remove_ethernet_interfaces = true
  vm_name                        = "rockylinux-9"
  usb                            = true
  disk_adapter_type              = "nvme"
}

build {
  sources = [
    // "sources.virtualbox-iso.rockylinux-9",
    // "sources.virtualbox-iso.rockylinux-9-aarch64",
    // "sources.vmware-iso.rockylinux-9",
    "sources.vmware-iso.rockylinux-9-aarch64",
    // "sources.qemu.rockylinux-9"
  ]

  provisioner "ansible" {
    playbook_file = "./ansible/vagrant-box.yml"
    // galaxy_file      = "./ansible/requirements.yml"
    roles_path = "./ansible/roles"
    // collections_path = "./ansible/collections"
    ansible_env_vars = [
      "ANSIBLE_PIPELINING=True",
      "ANSIBLE_REMOTE_TEMP=/tmp",
      "ANSIBLE_SCP_EXTRA_ARGS=-O",
    ]
    # ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa","-oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    extra_arguments = [
      "--extra-vars",
      "packer_provider=${source.type}",
    ]
    // except = [
    //   "hyperv-iso.rockylinux-9"
    // ]
  }




  post-processors {

    post-processor "vagrant" {
      compression_level = "9"
      output            = "RockyLinux-9-Vagrant-{{.Provider}}-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.x86_64.box"
      only = [
        "qemu.rockylinux-9",
        "vmware-iso.rockylinux-9-x86_64",
      ]
    }

    post-processor "vagrant" {
      compression_level = "9"
      output            = "RockyLinux-9-Vagrant-{{.Provider}}-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.aarch64.box"
      only = [
        "vmware-iso.rockylinux-9-aarch64",
      ]
    }

    post-processor "vagrant" {
      compression_level    = "9"
      vagrantfile_template = "tpl/vagrant/vagrantfile-libvirt.tpl"
      output               = "RockyLinux-9-Vagrant-{{.Provider}}-${var.os_ver_9}-${formatdate("YYYYMMDD", timestamp())}.x86_64.box"
      only = [
        "qemu.rockylinux-9"
      ]
    }
  }
}
