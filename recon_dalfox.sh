#!/bin/bash

dalfox_command="/go/bin/dalfox file $1"

$dalfox_command &
dalfox_pid=$!

while kill -0 $dalfox_pid > /dev/null 2>&1; do
    sleep 1  # wait for 1 second

    if kill -0 $dalfox_pid > /dev/null 2>&1; then
        mem_usage=$(ps -o rss= -p $dalfox_pid)
        if [[ $mem_usage -ge 400000 ]]; then
            echo "Memory usage exceeded 400 MB. Killing dalfox process."
            kill $dalfox_pid  # kill the dalfox process
            break
        fi
    fi
done
