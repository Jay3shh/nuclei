#!/bin/bash

for urls in $( cat $1); do
url=$urls
done;


output=""
echo $url
while read line; do
  output="$output$line\n"
  if echo "$line" | grep -q "Payload:"; then
   pkill -f "xsstrike"
   echo $line
    # Do something
  fi
    sleep 1  # wait for 1 second
    xsstrike_pid=$(pgrep -a "python" | grep "xsstrike.py" | grep -v "timeout" | awk '{print $1}')
    if kill -0 $xsstrike_pid > /dev/null 2>&1; then
        mem_usage=$(ps -o rss= -p $xsstrike_pid)
        if [[ $mem_usage -ge 200000 ]]; then
            echo "Memory usage exceeded 200 MB. Killing XSStrike process."
            kill $xsstrike_pid  # kill the XSStrike process
            break
        fi
    fi
done < <(timeout --preserve-status -k 5s 5m python XSStrike/xsstrike.py -u "$url" --skip 2>&1)
