# AlmaLinux 9 aarch64 kickstart file for Vagrant boxes

url --url https://mirrors.jxust.edu.cn/almalinux/9/BaseOS/aarch64/kickstart/
repo --name=BaseOS --baseurl=https://mirrors.jxust.edu.cn/almalinux/9/BaseOS/aarch64/os/
repo --name=AppStream --baseurl=https://mirrors.jxust.edu.cn/almalinux/9/AppStream/aarch64/os/

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
selinux --disabled

bootloader --location=mbr
zerombr
clearpart --all --initlabel
autopart --type=plain --nohome --noboot --noswap

rootpw sugar
user --name=sugar --plaintext --password sugar
user --name=vagrant --plaintext --password vagrant
reboot --eject


%packages --inst-langs=en
@core
bzip2
dracut-config-generic
git 
vim
tar
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


%post
# allow vagrant user to run everything without a password
echo "sugar     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers.d/sugar
echo "vagrant     ALL=(ALL)     NOPASSWD: ALL" >> /etc/sudoers.d/vagrant

# see Vagrant documentation (https://docs.vagrantup.com/v2/boxes/base.html)
# for details about the requiretty.
sed -i "s/^.*requiretty/# Defaults requiretty/" /etc/sudoers
yum clean all

# permit root login via SSH with password authetication
echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/01-permitrootlogin.conf


%end