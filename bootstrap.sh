#!/bin/bash
#set -x
TIMEZONE=${1:-"Europe/Berlin"}

print_head(){
  echo " "
  echo " * ** ***  $1  *** ** *"
  echo " "
}
disable_selinux(){
  setenforce 0
  sed -i 's/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/g' /etc/selinux/config
}
base_install(){
  print_head "Base Installation"
  timedatectl set-timezone $TIMEZONE
  localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"
  yum -y install epel-release
  yum -y update
  yum -y upgrade
  yum -y install net-tools htop checkpolicy
}
disable_selinux
base_install
