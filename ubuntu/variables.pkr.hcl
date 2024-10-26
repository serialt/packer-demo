variable "mirrors" {
  description = "os mirrors url"
  type        = string
  default     = "https://mirror.sjtu.edu.cn"
}

variable "os_ver_2204" {
  description = "Ubuntu 2204"

  type    = string
  default = "22.04.5"

}

variable "os_ver_2404" {
  description = "Ubuntu 2404"

  type    = string
  default = "24.04.1"

}

// variable "os_name" {
//   description = "Ubuntu os name"
//   type        = string
//   default     = "jammy"
// }



locals {
  iso_url_2204_x86_64       = "${var.mirrors}/ubuntu-releases/${var.os_ver_2204}/ubuntu-${var.os_ver_2204}-live-server-amd64.iso"
  iso_2204_checksum_x86_64  = "file:${var.mirrors}/ubuntu-releases/${var.os_ver_2204}/SHA256SUMS"
  iso_url_aarch64      = "${var.mirrors}/ubuntu-cdimage/ubuntu/releases/${var.os_ver_2204}/release/ubuntu-${var.os_ver_2204}-live-server-arm64.iso"
  iso_checksum_aarch64 = "file:${var.mirrors}/ubuntu-cdimage/ubuntu/releases/${var.os_ver_2204}/release/SHA256SUMS"

  iso_url_2404_aarch64      = "${var.mirrors}/ubuntu-cdimage/ubuntu/releases/${var.os_ver_2404}/release/ubuntu-${var.os_ver_2404}-live-server-arm64.iso"
  iso_2404_checksum_aarch64 = "file:${var.mirrors}/ubuntu-cdimage/ubuntu/releases/${var.os_ver_2404}/release/SHA256SUMS"

}

# Common

variable "headless" {
  description = "Disable GUI"

  type    = bool
  default = true
}

variable "boot_wait" {
  description = "Time to wait before typing boot command"

  type    = string
  default = "10s"
}

variable "cpus" {
  description = "The number of virtual cpus"

  type    = number
  default = 2
}

variable "memory" {
  description = "The amount of memory"

  type    = number
  default = 4096
}

variable "post_cpus" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 1
}

variable "post_memory" {
  description = "The number of virtual cpus after the build"

  type    = number
  default = 1024
}

variable "http_directory" {
  description = "Path to a directory to serve kickstart files"

  type    = string
  default = "http"
}

variable "ssh_timeout" {
  description = "The time to wait for SSH to become available"

  type    = string
  default = "3600s"
}

variable "root_shutdown_command" {
  description = "The command to use to gracefully shut down the machine"

  type    = string
  default = "/sbin/shutdown -hP now"
}

variable "qemu_binary" {
  description = "Path of QEMU binary"

  type    = string
  default = null
}

variable "ovmf_code" {
  description = "Path of OVMF code file"

  type    = string
  default = "/usr/share/OVMF/OVMF_CODE.secboot.fd"
}

variable "ovmf_vars" {
  description = "Path of OVMF variables file"

  type    = string
  default = "/usr/share/OVMF/OVMF_VARS.secboot.fd"
}

variable "aavmf_code" {
  description = "Path of AAVMF code file"

  type    = string
  default = "/usr/share/AAVMF/AAVMF_CODE.fd"
}

// # Generic Cloud (Cloud-init)

// variable "gencloud_disk_size" {
//   description = "The size in GB of hard disk of VM"

//   type    = string
//   default = "40G"
// }

// variable "gencloud_ssh_username" {
//   description = "The username to connect to SSH with"

//   type    = string
//   default = "root"
// }

// variable "gencloud_ssh_password" {
//   description = "A plaintext password to use to authenticate with SSH"

//   type    = string
//   default = "sugar"
// }

// variable "gencloud_boot_command_8_x86_64" {
//   description = "Boot command for x86_64 BIOS"

//   type = list(string)
//   default = [
//     "<tab>",
//     "inst.text net.ifnames=0 inst.gpt",
//     " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-x86_64.ks",
//     "<enter><wait>"
//   ]
// }

// local "gencloud_boot_command_8_x86_64_uefi" {
//   expression = [
//     "c<wait>",
//     "linuxefi",
//     " /images/pxeboot/vmlinuz",
//     " inst.stage2=hd:LABEL=RockyLinux-8-${local.os_ver_minor_8}-x86_64-dvd ro",
//     " inst.text biosdevname=0 net.ifnames=0",
//     " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-x86_64.ks",
//     "<enter>",
//     "initrdefi /images/pxeboot/initrd.img",
//     "<enter>",
//     "boot<enter><wait>"
//   ]
// }

// local "gencloud_boot_command_8_aarch64" {
//   expression = [
//     "c<wait>",
//     "linux /images/pxeboot/vmlinuz",
//     " inst.stage2=hd:LABEL=RockyLinux-8-${local.os_ver_minor_8}-aarch64-dvd ro",
//     " inst.text biosdevname=0 net.ifnames=0",
//     " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-aarch64.ks",
//     "<enter>",
//     "initrd /images/pxeboot/initrd.img",
//     "<enter>",
//     "boot<enter><wait>"
//   ]
// }


// variable "gencloud_boot_command_9_x86_64_bios" {
//   description = "Boot command for x86_64 BIOS"

//   type = list(string)
//   default = [
//     "<tab>",
//     "inst.text biosdevname=0 net.ifnames=0 inst.gpt",
//     " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.gencloud-x86_64-bios.ks",
//     "<enter><wait>"
//   ]
// }

// local "gencloud_boot_command_9_x86_64" {
//   expression = [
//     "c<wait>",
//     "linuxefi /images/pxeboot/vmlinuz",
//     " inst.stage2=hd:LABEL=RockyLinux-9-${local.os_ver_minor_9}-x86_64-dvd ro",
//     " inst.text biosdevname=0 net.ifnames=0",
//     " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.gencloud-x86_64.ks",
//     "<enter>",
//     "initrdefi /images/pxeboot/initrd.img",
//     "<enter>",
//     "boot<enter><wait>"
//   ]
// }

local "vagrant_boot_command" {
  expression = [
      "c",
      "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ",
      "<enter><wait>",
      "initrd /casper/initrd<enter><wait>",
      "boot<enter>"
    ]
}



# Vagrant

variable "vagrant_disk_size" {
  description = "The size in MiB of hard disk of VM"

  type    = number
  default = 40000
}

variable "vagrant_shutdown_command" {
  description = "The command to use to gracefully shut down the machine"

  type    = string
  default = "echo vagrant | sudo -S /sbin/shutdown -hP now"
}

variable "vagrant_ssh_username" {
  description = "The username to connect to SSH with"

  type    = string
  default = "sugar"
}

variable "vagrant_ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type    = string
  default = "sugar"
}



