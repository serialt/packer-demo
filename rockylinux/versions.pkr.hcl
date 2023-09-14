packer {
  required_version = ">= 1.7.0"
  required_plugins {
    qemu = {
      version = ">= 1.0.7"
      source  = "github.com/hashicorp/qemu"
    }
    // virtualbox = {
    //   version = ">= 1.0.3"
    //   source  = "github.com/hashicorp/virtualbox"
    // }
    vmware = {
      version = ">= 1.0.6"
      source  = "github.com/hashicorp/vmware"
    }
    ansible = {
      version = ">= 1.1.0  "
      source  = "github.com/hashicorp/ansible"
    }
  }
}