#!/bin/env bash
###################################################################
# This is shell script to handle that unable to write data into
# external removable disk device, such as usb device, etc. In Macbook
# there is a limitation that not allow to copy internal data into 
# external device. The script can be unlimit the restriction.
# The solution came from https://www.xiaorongmao.com/blog/49
###################################################################

opt=${1}
disk_name=${2:-"SanDisk128G"}

mount_device() {
  # Step 2. make empty directory under /Volumes director
  mkdir -p /Volumes/${device_id}

  # Step 3. unmount the device
  mount_point=$(diskutil info ${device_id} | grep 'Mount Point:' | awk '{print $NF}')
  if [ ! -z $mount_point ]; then
    diskutil unmount ${mount_point}
    mkdir -p /Volumes/${device_id}
  fi

  # Step 4. mount the device with read&write permission
  mount_exfat -o rw,nobrowse /dev/${device_id} /Volumes/${device_id}

  mount_point=$(diskutil info ${device_id} | grep 'Mount Point:' | awk '{print $NF}')
  if [ ! -z $mount_point ]; then
    echo "Successful mount device ${device_id}"
  fi
}

unmount_device() {
  mount_point=$(diskutil info ${device_id} | grep 'Mount Point:' | awk '{print $NF}')
  if [ ! -z $mount_point ]; then
    diskutil unmount ${mount_point}
  fi
  if [ -d /Volumes/${device_id} ]; then
     rm -rf /Volumes/${device_id}
  fi
  if [ ! -d /Volumes/${device_id} ]; then
    echo "Successful unmount device ${device_id}"
  fi 
}

eject_device() {
  count=$(diskutil list | grep ${device_id} | wc -l)
  if [ $count -eq 1 ]; then
    hdiutil eject ${device_id}
  else
    echo "There is no device ${device_id} to be ejected in the system."
  fi
}

# Step 1. obtain the device id
device_id=$(diskutil list | grep ${disk_name} | awk '{print $NF}')
if [ -z ${device_id} ]; then
  echo "There is no device ${device_id} to be here in the system."
  exit -1
fi

case $opt in
mount)
  mount_device
  ;;

unmount)
  unmount_device
  ;;
eject)
  eject_device
  ;;
*)
  echo "Use usb mount|unmount|eject"
  ;;
esac

