#!/usr/bin/python

import sys

from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Modify this list to add items to your cloud-init multi-part file
includes = [
    ('disk-resize.sh', 'text/x-shellscript-per-instance'),
    ('remove-builder-keys.sh', 'text/x-shellscript-per-instance'),
    ('ssh-tweaks.sh', 'text/x-shellscript-per-once'),
    ('cloud-config.yaml', 'text/cloud-config'),
]

combined_message = MIMEMultipart()
for i in includes:
    (filename, format_type) = i
    with open(filename) as fh:
        contents = fh.read()
    sub_message = MIMEText(contents, format_type, sys.getdefaultencoding())
    sub_message.add_header('Content-Disposition', 'attachment; filename="%s"' % (filename))
    combined_message.attach(sub_message)

print(combined_message)