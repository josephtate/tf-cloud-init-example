#!/bin/bash

# Another cloud-init script to pre-configure SSH

CONFIG=/etc/ssh/sshd_config

# Turn on UseDNS and set to no in sshd_config
echo 'UseDNS no' >> $CONFIG

# Limit SSH connections to 30s
sed -i 's/^ClientAliveCountMax.*0$/ClientAliveCountMax 10/' $CONFIG

# Disable (broken) GSS API auth.
sed -i 's/^GSSAPIAuthentication\s*yes/GSSAPIAuthentication no/' $CONFIG

systemctl restart sshd.service