#!/bin/bash

timeout --preserve-status -k 5s 14m /go/bin/dalfox file $1 &
dalfox_pid=$!

while kill -0 $dalfox_pid > /dev/null 2>&1; do
    sleep 1  # wait for 1 second

    if kill -0 $dalfox_pid > /dev/null 2>&1; then
        mem_usage=$(ps -o rss= -p $dalfox_pid)
        if [[ $mem_usage -ge 300000 ]]; then
            echo "Memory usage exceeded 400 MB. Killing dalfox process."
            kill $dalfox_pid  # kill the dalfox process
            break
        fi
    fi
done
