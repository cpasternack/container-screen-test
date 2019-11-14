#!/usr/bin/env bash

###########################################################################################
#
# CPasternack 11/2019
#
# License MIT
# Structure taken from Docker best practice guide:
# https://success.docker.com/article/use-a-script-to-initialize-stateful-container-data
# 
##########################################################################################

# flags help with debugging
# -e sets exit on error*
# -x sets extented execution tracing printing
set -e
set -x

# set PATH for root user
# SHELL is set in the Dockerfile, but export bash anyway
# set SCREENRC with our awesome screenrc config
export PATH=/usr/local/bin:/usr/bin/:/bin/:/usr/sbin:/sbin
export SHELL=/bin/bash
export SCREENRC=/etc/screenrc

if [ "${1}" == "--help" ]
then
  # below is going to appear in our "docker run -it ..." output
  echo "Start container with '-it' or '-d' flag"
  echo "Enter container with: docker exec -it <name> screen -r"
  echo "CTRL+\ to quit 'tail -f...', CTRL+A, D to detach screen session, CTRL+PQ to detach docker"
else
  # if we passed another command, exec it instead
  exec "$@"
fi

# some debug to show that this script is PID 1, and that the commands below exited with code 0
# /var/log/messages isn't created by default!
touch /var/log/messages

# commands to execute
# the '-X stuff "...^M" ' command says: enter stuff <the command> then hit enter <^M>
# the '-p <N>' directive says "do -X .. on that screen tab" 
# the 'screen -t <name>' creates a tab (C-A, C in screen) with name, and then executes a command
screen -d -m -S screentest && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages
screen -S screentest -p 0 -X stuff "tail -f /var/log/apt/history.log^M" && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages
screen -S screentest -X screen -t messages bash -l && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages
screen -S screentest -X screen -t rootpw bash -l && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages
screen -S screentest -p 1 -X stuff "tail -f /var/log/messages^M" && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages 
screen -S screentest -p 2 -X stuff "tail -f /tmp/ROOTPW.txt^M" && echo "`date +'%b %d %H:%M:%S'` $HOSTNAME entrypoint.sh[$$] $?" >> /var/log/messages 

# finally, start sshd and hold container open on output "-D"
/usr/sbin/sshd -D

exit $?
