#!/bin/bash
regex='^nvme[1-5]n1$'
while read -a words; do
  if [[ "${words[0]}" =~ $regex ]]
  then
    mp=""
    case "${words[3]}" in
    10G)
      mp="u02"
      ;;
    # 16G)
    #   mp="swapfile"
    #   ;;
    # 20G)
    #   mp="var"
    #   ;;
    # 22G)
    #   mp="home"
    #   ;;
    # 24G)
    #   mp="chroot"
    #   ;;
    # 10F)
    #   mp="u02"
    #   ;;
    esac
    
    if [[ $mp == "var" ]] || [[ $mp == "tmp" ]]
    then 
      mkfs -t xfs "/dev/${words[0]}"
      mkdir "/mnt/$mp"
      mount "/dev/${words[0]}" "/mnt/$mp"
      init 1
      cd "/$mp"
      cp -ax * "/mnt/$mp"
      cd /
      mv "$mp" "$mp.old"
      mkdir "$mp"
      umount "/dev/${words[0]}"
      mount "/dev/${words[0]}" "/$mp"
      echo  "/dev/${words[0]}" "/$mp" xfs defaults,nofail 0 1 >> /etc/fstab
      init 5
    else
      mkfs -t xfs "/dev/${words[0]}"
      mkdir "/$mp"
      mount "/dev/${words[0]}" "/$mp"
      echo  "/dev/${words[0]}" "/$mp" xfs defaults,nofail 0 1 >> /etc/fstab
    fi
  fi
done < <(lsblk)
reboot -h now

# dd if=/dev/zero of=/u02/swapfile bs=128M count=8
# chmod 0600 /u02/swapfile
# mkswap /u02/swapfile
# echo /u02/swapfile swap swap defaults  0 2 >> /etc/fstab
# swapon -a

