#!/bin/bash

    # ack-grep
    #
    # Install ack-rep directory from the version hosted at beyondgrep.com as the
    # PPAs for Ubuntu Precise are not available yet.
    if [ -f /usr/bin/ack ]
    then
        echo "ack-grep already installed"
    else
        echo "Installing ack-grep as ack"
        curl -s http://beyondgrep.com/ack-2.04-single-file > /usr/bin/ack && chmod +x /usr/bin/ack
    fi