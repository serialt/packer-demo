/*
 * Ubuntu OS Packer template for building Vagrant boxes.
 */

source "vmware-iso" "ubuntu-2404-aarch64" {
  iso_url          = local.iso_url_2404_aarch64
  iso_checksum     = local.iso_2404_checksum_aarch64
  boot_command     = local.vagrant_boot_command
  boot_wait        = var.boot_wait
  cpus             = var.cpus
  memory           = var.memory
  disk_size        = var.vagrant_disk_size
  headless         = var.headless
  http_directory   = var.http_directory
  guest_os_type    = "arm-ubuntu-64"
  shutdown_command = var.vagrant_shutdown_command
  ssh_username     = var.vagrant_ssh_username
  ssh_password     = var.vagrant_ssh_password
  ssh_timeout      = var.ssh_timeout
  vmx_data = {
    ".encoding"            = "UTF-8",
    "config.version"       = "8",
    "virtualHW.version"    = "20",
    "usb_xhci.present"     = "true",
    "ethernet0.virtualdev" = "e1000e",
    "firmware"             = "efi"
  }
  vmx_remove_ethernet_interfaces = true
  vm_name                        = "ubuntu"
  usb                            = true
  disk_adapter_type              = "nvme"
}

build {
  sources = [
    // "sources.virtualbox-iso.rockylinux-9",
    // "sources.virtualbox-iso.rockylinux-9-aarch64",
    // "sources.vmware-iso.rockylinux-9",
    "sources.vmware-iso.ubuntu-2404-aarch64",
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
      "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -oServerAliveInterval=120s -oTCPKeepAlive=yes -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa'"
    ]
    # ansible_ssh_extra_args = [ "-oHostKeyAlgorithms=+ssh-rsa","-oPubkeyAcceptedKeyTypes=+ssh-rsa" ]
    extra_arguments = [
      "--extra-vars",
      "packer_provider=${source.type}"
    ]
    // except = [
    //   "hyperv-iso.rockylinux-9"
    // ]
  }




  post-processors {

    post-processor "vagrant" {
      compression_level = "9"
      output            = "Ubuntu-2404-Vagrant-{{.Provider}}-${var.os_ver_2404}-${formatdate("YYYYMMDD", timestamp())}.aarch64.box"
      except = [
        "sources.vmware-iso.ubuntu-2404-aarch64",
      ]
    }

    // post-processor "vagrant" {
    //   compression_level = "9"
    //   output            = "RockyLinux-9-Vagrant-${var.os_ver}-${formatdate("YYYYMMDD", timestamp())}.x86_64.{{.Provider}}.box"
    //   except = [
    //     "qemu.rockylinux-9",
    //     "vmware-iso.rockylinux-9-aarch64",
    //   ]
    // }

    // post-processor "vagrant" {
    //   compression_level = "9"
    //   output            = "RockyLinux-9-Vagrant-${var.os_ver}-${formatdate("YYYYMMDD", timestamp())}.aarch64.{{.Provider}}.box"
    //   only = [
    //     "vmware-iso.rockylinux-9-aarch64",
    //   ]
    // }

    // post-processor "vagrant" {
    //   compression_level    = "9"
    //   vagrantfile_template = "tpl/vagrant/vagrantfile-libvirt.tpl"
    //   output               = "RockyLinux-9-Vagrant-${var.os_ver}-${formatdate("YYYYMMDD", timestamp())}.x86_64.{{.Provider}}.box"
    //   only = [
    //     "qemu.rockylinux-9"
    //   ]
    // }
  }
}
