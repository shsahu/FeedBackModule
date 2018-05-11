#!/bin/bash

st=$1
et=$2
output_file=$3

hostname=$(cat /etc/hostname )
path=~/collectd_csv/$hostname/cpu


file=$(ls -rt $path/percent-idle* |tail -n 1)

el=$(cat $file  | grep -n $et | cut -f1 -d ':')
sl=$(cat $file  | grep -n $st | cut -f1 -d ':')

if [ -z "$el" ]
then
    el=$(wc -l < $file)
fi

cat $file |awk "NR >= $sl && NR <= $el" | cut -f2 -d ',' > $output_file
