#!/bin/bash
root=`dirname \`realpath $0\``

kill `cat $root/.pid`
rm $root/.pid

