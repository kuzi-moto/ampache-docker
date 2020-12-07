#!/bin/bash

# Start Supervisor to manage all the processes
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
