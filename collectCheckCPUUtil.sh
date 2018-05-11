#!/bin/bash

SERVERS_IDS=('4' '5' '6' '7')
SERVER_COUNT=${#SERVERS_IDS[@]}
BREACH_COUNT=0
MIN_BREACH=$3
THRESHOLD=$2
LOG_FILE="/home/ahmad/feedback/daemonLog/collectCheckCPUUtil.log"
COLLECT_SCRIPT="/home/ahmad/feedback/extract_cpu_idle.sh"
OUTPUT_FILE="/home/ahmad/feedback/serverLog/last_interval_cpu_idle.log"
SERVER_LOG_DIR="/home/ahmad/feedback/serverLog";

log(){
    echo $(date +"%Y-%m-%d-%T") $@ >> $LOG_FILE
}


collectData(){
    log collectData from ${SERVER_COUNT} servers
    for (( i=0; i<${SERVER_COUNT}; i++ ))
    do
       ssh ahmad@compute${SERVERS_IDS[$i]} "${COLLECT_SCRIPT} ${start_time} ${end_time} ${OUTPUT_FILE}"
       scp -q ahmad@compute${SERVERS_IDS[$i]}:${OUTPUT_FILE}    ${SERVER_LOG_DIR}/server${i}_cpu_idle.log
    
    done
}

check()
{
    collectData
    log inside check $BREACH_COUNT
    result=$(python checkCPUUtil.py ${SERVER_COUNT})
     
    #echo $result $THRESHOLD
    compare_result=$(echo "$result<$THRESHOLD" | bc)
    #echo $compare_result
    if [ $compare_result -gt 0 ]; then
        BREACH_COUNT=0
    else
        BREACH_COUNT=$((BREACH_COUNT + 1))
        if [ $BREACH_COUNT -ge $MIN_BREACH ]
        then
            BREACH_COUNT=0
            log "CPU usage is above Threshold value $THRESHOLD, from last $MIN_BREACH times; recalculating parameter values"
            python calculateCurveParameters.py
        fi
    fi
}

start_time=$(date +%s)
step_size=$1
start_time=$((start_time-step_size))
end_time=$(date +%s)
log "starting at " $start_time " with interval of " $step_size
while [ 1 ]
do
           end_time=$(date +%s)
           check
           start_time=$((end_time+1))
           sleep $step_size

done
