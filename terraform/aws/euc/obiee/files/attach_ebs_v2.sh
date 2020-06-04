
#!/bin/bash

regex='^nvme[1-2]n1$'
while read -a words; do
  if [[ "${words[0]}" =~ $regex ]]
  then
    mp=""
    case "${words[3]}" in
    20G)
      mp="u01"
      ;;
    200G)
      mp="u02"
      ;;
    esac
    
    mkfs -t xfs "/dev/${words[0]}"
    mkdir "/$mp"
    mount "/dev/${words[0]}" "/$mp"
    echo  "/dev/${words[0]}" "/$mp" xfs defaults,nofail 0 1 >> /etc/fstab
  fi
done < <(lsblk)

dd if=/dev/zero of=/u02/swapfile bs=128M count=8
chmod 0600 /u02/swapfile
mkswap /u02/swapfile
echo /u02/swapfile swap swap defaults  0 2 >> /etc/fstab
swapon -a

