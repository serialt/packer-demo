# AlmaLinux 9 kickstart file for Vagrant boxes

url --url https://mirror.sjtu.edu.cn/almalinux/9/BaseOS/x86_64/kickstart/
repo --name=BaseOS --baseurl=https://mirror.sjtu.edu.cn/almalinux/9/BaseOS/x86_64/os/
repo --name=AppStream --baseurl=https://mirror.sjtu.edu.cn/almalinux/9/AppStream/x86_64/os/

text
skipx
eula --agreed
firstboot --disabled

lang C.UTF-8
keyboard us
timezone Asia/Shanghai

network --bootproto=dhcp
firewall --disabled
services --enabled=sshd
selinux --enforcing

bootloader --location=mbr

%pre --erroronfail

parted -s -a optimal /dev/sda -- mklabel gpt
parted -s -a optimal /dev/sda -- mkpart biosboot 1MiB 2MiB set 1 bios_grub on
parted -s -a optimal /dev/sda -- mkpart '"EFI System Partition"' fat32 2MiB 202MiB set 2 esp on
parted -s -a optimal /dev/sda -- mkpart boot xfs 202MiB 714MiB
parted -s -a optimal /dev/sda -- mkpart root xfs 714MiB 100%

%end

part biosboot --fstype=biosboot --onpart=sda1
part /boot/efi --fstype=efi --onpart=sda2
part /boot --fstype=xfs --onpart=sda3
part / --fstype=xfs --onpart=sda4


rootpw sugar
user --name=sugar --plaintext --password sugar

reboot --eject


%packages --inst-langs=en
@core
bzip2
dracut-config-generic
grub2-pc
tar
git 
vim
usermode
-biosdevname
-dnf-plugin-spacewalk
-dracut-config-rescue
-iprutils
-iwl*-firmware
-langpacks-*
-mdadm
-open-vm-tools
-plymouth
-rhn*
%end


# disable kdump service
%addon com_redhat_kdump --disable
%end

%post --erroronfail

grub2-install --target=i386-pc /dev/sda

# allow vagrant user to run everything without a password
echo "vagrant     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers.d/vagrant

# see Vagrant documentation (https://docs.vagrantup.com/v2/boxes/base.html)
# for details about the requiretty.
sed -i "s/^.*requiretty/# Defaults requiretty/" /etc/sudoers
yum clean all

# permit root login via SSH with password authetication
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitrootlogin.conf

yum -y install epel-release

sed -e 's|^metalink=|#metalink=|g' \
         -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
         -e 's|^#baseurl=https\?://download.example/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
         -i.bak \
         /etc/yum.repos.d/epel.repo
%end
