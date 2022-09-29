#!/bin/bash -xe
LOGFILE=/tmp/disk-resize.log

# Due to poor ordering control, run the udev restart here and wait a bit.
udevadm control --reload-rules && udevadm trigger

DEVICE=$(pvs | grep vgpool | awk '{print $1}')

wait_seconds=300
interval=30
until test $((wait_seconds-=$interval)) -le 0 -o -L "$DEVICE" -o -b "$DEVICE"
do
    sleep $interval
    echo "Waiting for udev to reload to create $DEVICE symlink" | tee -a $LOGFILE
done

{
    #This is set up for the Golden CentOS 7 AMI. Other AMIs will need adjusting.
    echo Running disk-resize.sh

    #Resize the physical volume to fill the allocated space
    pvresize /dev/sdb | tee -a $LOGFILE

    lvextend -L 10G --resizefs /dev/vgpool/home
    lvextend -L 12G --resizefs /dev/vgpool/opt
    lvextend -L 4G --resizefs /dev/vgpool/tmp
    swapoff -v /dev/vgpool/swap
    lvextend -L $(free -g | grep Mem: | awk '{print $2}')G /dev/vgpool/swap
    mkswap /dev/vgpool/swap
    swapon -va
    lvextend -l +100%FREE --resize /dev/vgpool/var
} 2>&1 | tee -a $LOGFILE