#!/usr/bin/env bash

#for i in utun2 en{0..4}; do
#  _ip_a=$(LC_ALL=C ifconfig $i | grep -Eo '[[:digit:]]{1,3}\.' | tr -d . | head -n 1)
#  [ ! -z $_ip_a ] && break 
#done
_ip_a=$(ifconfig | grep "inet " | grep broadcast | awk '{print $2}' | awk -F. '{print $1}')
_internal=False
if [ $_ip_a -ne 9 ]; then
  echo "The ip address $_ip_a is not from office, remove the file .bso.lock directly."
  rm -f ~/.bso.lock
  _internal=True
else
  find ~ -name '.bso.lock' -maxdepth 1 -mtime +8h -exec rm -f {} \;
fi

if [ -f ~/.bso.lock ]
then
  echo "BSO was passed, exit."
  exit 0
fi

bso() {
  local _dir=$(dirname $0)
  local _pre_dir="$_dir"
  
  if [ "${dir:0:1}" != "/" ]; then 
    _pre_dir="$_dir"
  fi

  local _filename="${_pre_dir}/${1}"
  local _email="${2}"
  local _passwd="${3}"
  local _site=${4}
  expect $_filename $_email $_passwd $_site
}

_cnt=0
_bso_site='bso.exp'
_email=""
_password=""
_vm_site=('hostA' 'hostB' '192.168.1.1')
while [ $_cnt -lt ${#_vm_site[@]} ]; do
  bso ${_bso_site} ${_email} ${_password} ${_vm_site[$_cnt]}
  let _cnt=$(( _cnt + 1 ))
done

if [ $? -eq 0 ] && [ $_internal == False ]
then
  touch ~/.bso.lock
  chmod 100 ~/.bso.lock
else
  exit -1
fi

