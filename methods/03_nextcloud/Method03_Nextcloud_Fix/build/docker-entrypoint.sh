#!/bin/bash
set -e

# Start haveged daemon
/usr/local/bin/entropy-gatherer.sh

# Execute the main container command
exec "$@" 