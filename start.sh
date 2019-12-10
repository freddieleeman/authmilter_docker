#!/bin/sh

# Exit if the authentication milter configuration is not found
[ ! -f "/config/authentication_milter.json" ] && exit

# Create a symlink in the /etc folder when a Mail::DMARC configuration file is found in the shared volume
[ -f "/config/mail-dmarc.ini" ] && ln -s /config/mail-dmarc.ini /etc/mail-dmarc.ini

# Start the authentication milter
authentication_milter --prefix=/config
