#!/bin/env bash
###################################################################
# This is shell script to handle that unable to write data into
# external removable disk device, such as usb device, etc. In Macbook
# there is a limitation that not allow to copy internal data into 
# external device. The script can be unlimit the restriction.
# The solution came from https://www.xiaorongmao.com/blog/49
###################################################################

opt=${1}

mount_device() {
  # Step 1. recognize what's the device id
  device_id=$(diskutil list | grep SanDisk128G | awk '{print $NF}')

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
  device_id=$(diskutil list | grep SanDisk128G | awk '{print $NF}')
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

case $opt in
mount)
  mount_device
  ;;

unmount)
  unmount_device
  ;;
*)
  echo "Use usb mount|unmount"
  ;;
esac


