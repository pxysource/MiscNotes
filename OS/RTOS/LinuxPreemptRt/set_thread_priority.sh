#!/bin/sh

PROCESS_NAME="irq/16-xdma"
PROGRAM_CHRT=/mnt/rtfiles/chrt

PID=$(pidof $PROCESS_NAME)
if [ -z "$PID" ]; then
  echo "[ERR ] Progress is not exist!"
  exit 1
fi

# SCHED_FIFO, priority=98
$PROGRAM_CHRT -f -p 98 "$PID"
$PROGRAM_CHRT -p "$PID"