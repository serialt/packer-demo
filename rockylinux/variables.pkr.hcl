variable "os_ver_8" {
  description = "RockyLinux OS 8 version"

  type    = string
  default = "8.8"

  validation {
    condition     = can(regex("8.[3-9]$|8.[1-9][0-9]$", var.os_ver_8))
    error_message = "The os_ver_8 value must be one of released or prereleased versions of RockyLinux OS 8."
  }
}

variable "os_ver_9" {
  description = "RockyLinux OS 9 version"

  type    = string
  default = "9.2"

  validation {
    condition     = can(regex("9.[0-9]$|9.[1-9][0-9]$", var.os_ver_9))
    error_message = "The os_ver_9 value must be one of released or prereleased versions of RockyLinux OS 9."
  }
}

locals {
  os_ver_minor_8 = split(".", var.os_ver_8)[1]
  os_ver_minor_9 = split(".", var.os_ver_9)[1]
}

locals {
  iso_url_8_x86_64       = "https://mirror.sjtu.edu.cn/rocky/${var.os_ver_8}/isos/x86_64/Rocky-${var.os_ver_8}-x86_64-boot.iso"
  iso_checksum_8_x86_64  = "file:https://mirror.sjtu.edu.cn/rocky/${var.os_ver_8}/isos/x86_64/CHECKSUM"
  iso_url_8_aarch64      = "https://mirror.sjtu.edu.cn/rocky/${var.os_ver_8}/isos/aarch64/Rocky-${var.os_ver_8}-aarch64-boot.iso"
  iso_checksum_8_aarch64 = "file:https://mirror.sjtu.edu.cn/rocky/${var.os_ver_8}/isos/aarch64/CHECKSUM"
  iso_url_9_x86_64       = "https://mirror.sjtu.edu.cn/rocky/${var.os_ver_9}/isos/x86_64/Rocky-${var.os_ver_9}-x86_64-boot.iso"
  iso_checksum_9_x86_64  = "file:https://mirror.sjtu.edu.cn/rocky/${var.os_ver_9}/isos/x86_64/CHECKSUM"
  iso_url_9_aarch64      = "https://mirror.sjtu.edu.cn/rocky/${var.os_ver_9}/isos/aarch64/Rocky-${var.os_ver_9}-aarch64-boot.iso"
  iso_checksum_9_aarch64 = "file:https://mirror.sjtu.edu.cn/rocky/${var.os_ver_9}/isos/aarch64/CHECKSUM"

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

# Generic Cloud (Cloud-init)

variable "gencloud_disk_size" {
  description = "The size in GB of hard disk of VM"

  type    = string
  default = "40G"
}

variable "gencloud_ssh_username" {
  description = "The username to connect to SSH with"

  type    = string
  default = "root"
}

variable "gencloud_ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type    = string
  default = "sugar"
}

variable "gencloud_boot_command_8_x86_64" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    "inst.text net.ifnames=0 inst.gpt",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-x86_64.ks",
    "<enter><wait>"
  ]
}

local "gencloud_boot_command_8_x86_64_uefi" {
  expression = [
    "c<wait>",
    "linuxefi",
    " /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-8-${local.os_ver_minor_8}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
  ]
}

local "gencloud_boot_command_8_aarch64" {
  expression = [
    "c<wait>",
    "linux /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-8-${local.os_ver_minor_8}-aarch64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.gencloud-aarch64.ks",
    "<enter>",
    "initrd /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
  ]
}


variable "gencloud_boot_command_9_x86_64_bios" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    "inst.text biosdevname=0 net.ifnames=0 inst.gpt",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.gencloud-x86_64-bios.ks",
    "<enter><wait>"
  ]
}

local "gencloud_boot_command_9_x86_64" {
  expression = [
    "c<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-9-${local.os_ver_minor_9}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.gencloud-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
  ]
}

local "gencloud_boot_command_9_aarch64" {
  expression = [
    "c<wait>",
    "linux /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-9-${local.os_ver_minor_9}-aarch64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.gencloud-aarch64.ks",
    "<enter>",
    "initrd /images/pxeboot/initrd.img<enter>",
    "boot<enter><wait>"
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
  default = "vagrant"
}

variable "vagrant_ssh_password" {
  description = "A plaintext password to use to authenticate with SSH"

  type    = string
  default = "vagrant"
}

variable "vagrant_boot_command_8_x86_64" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.vagrant.ks",
    "<enter><wait>"
  ]
}

local "vagrant_boot_command_8_x86_64_uefi" {
  expression = [
    "c<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-8-${local.os_ver_minor_8}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-8.vagrant.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img<enter>",
    "boot<enter><wait>"
  ]
}

local "vagrant_boot_command_9_x86_64" {
  expression = [
    "c",
    "<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=RockyLinux-9-${local.os_ver_minor_9}-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.vagrant-x86_64.ks",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
  ]
}

variable "vagrant_boot_command_9_x86_64_bios" {
  description = "Boot command for x86_64 BIOS"

  type = list(string)
  default = [
    "<tab>",
    "inst.text inst.gpt inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.vagrant-x86_64.ks",
    "<enter><wait>"
  ]
}

variable "vagrant_boot_command_9_aarch64" {
  description = "Boot command for AArch64"

  type = list(string)
  default = [
    "e",
    "<down><down><end><bs><bs><bs><bs><bs>",
    "inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rockylinux-9.vagrant-aarch64.ks",
    "<leftCtrlOn>x<leftCtrlOff>"
  ]
}