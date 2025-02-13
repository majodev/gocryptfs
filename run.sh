#!/bin/bash
set -e

function sigterm_handler {
  echo "sending SIGTERM to child pid"
  kill -SIGTERM $pid
  fuse_unmount
  echo "exiting container now"
  exit $?
}

function sighup_handler {
  echo "sending SIGHUP to child pid"
  kill -SIGHUP $pid
  wait $pid
}

function fuse_unmount {
  echo "Unmounting: 'fusermount $UNMOUNT_OPTIONS $DEC_PATH' at: $(date +%Y.%m.%d-%T)"
  fusermount $UNMOUNT_OPTIONS $DEC_PATH
}

trap sigterm_handler SIGINT SIGTERM
trap sighup_handler SIGHUP

# Create decryption directory if it doesn't exist
mkdir -p $DEC_PATH

# Mount the encrypted folder
if [ ! -z "$PASSWD" ]; then
  gocryptfs $MOUNT_OPTIONS -fg -extpass 'printenv PASSWD' $ENC_PATH $DEC_PATH & pid=$!
else
  gocryptfs $MOUNT_OPTIONS -fg $ENC_PATH $DEC_PATH & pid=$!
fi

wait $pid

echo "gocryptfs crashed at: $(date +%Y.%m.%d-%T)"
fuse_unmount

exit $?