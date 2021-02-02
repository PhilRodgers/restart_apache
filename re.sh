#!/bin/bash

CONFIG="$1"
COMMAND="$2"

if [ $CONFIG  <> "000-default.conf" ]
then
    if [ $CONFIG  <> "default-ssl.conf" ]
    then
        exit 1
    fi
fi

if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
then
    # Move the current execution state to the proper directory
    cd /etc/apache2/sites-available

    # Disable a vhost configuration
    sudo a2dissite "$CONFIG"
    sudo service apache2 "$COMMAND"

    # Enable a vhost configuration
    sudo a2ensite "$CONFIG"
    sudo service apache2 "$COMMAND"
else
    echo "ERROR: $COMMAND is an invalid service command {restart|reload}"
    
    # List all of the configuration files in the _/etc/apache2/sites-available/_ directory
    VHOSTS_PATH=/etc/apache2/sites-available/*.conf

    for FILENAME in $VHOSTS_PATH
    do
        echo $FILENAME
    done   
    
    exit 1
fi
