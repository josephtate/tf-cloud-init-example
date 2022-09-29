#!/bin/bash -ex

# A simple script to remove keys left behind by image builder tools

USER_HOME=$(awk -F: '$3==1000 {print $6}' /etc/passwd)

sed -i.bak '/ami-builder/d; /packer_/d' $USER_HOME/.ssh/authorized_keys