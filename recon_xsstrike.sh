#!/bin/bash

for urls in $( cat $1); do
url=$urls
done;

timeout --preserve-status -k 5s 13m python3 xsstrike.py -u "$url" --skip >> output.txt &
xsstrike_pid=$(pgrep -a "python" | grep "xsstrike.py" | grep -v "timeout" | awk '{print $1}')

echo $xsstrike_pid

while kill -0 $xsstrike_pid > /dev/null 2>&1; do
    if grep -q "Payload:" output.txt; then
        pkill -f "xsstrike"
        pkill -f "timeout"
        kill $xsstrike_pid 
        break
    fi

    sleep 1  # wait for 1 second

    if kill -0 $xsstrike_pid > /dev/null 2>&1; then
        mem_usage=$(ps -o rss= -p $xsstrike_pid)
        if [[ $mem_usage -ge 200000 ]]; then
            echo "Memory usage exceeded 200 MB. Killing XSStrike process."
            kill $xsstrike_pid  # kill the XSStrike process
            break
        fi
    fi
done


#echo "KILLING AS ITS ENDING"
#kill $xsstrike_pid

#echo $xsstrike_pid

echo "=====================================================================" >> output1.txt
echo $urls >> output1.txt
cat output.txt | grep "Payload:" >> output1.txt
echo "=====================================================================" >> output1.txt

cat output1.txt
