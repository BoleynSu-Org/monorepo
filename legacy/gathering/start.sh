#!/bin/bash
root=`dirname \`realpath $0\``

nohup $root/main.py >> $root/.log &
echo $! > $root/.pid

