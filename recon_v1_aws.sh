#!/bin/bash
if [ -z $1 ]
then
  echo "\No Arguments Passed"
else    
    for sub in $( cat $1); do
        #echo "Initiating for $sub at $now" 
        #echo "[+] Starting SubFinder" &
        /go/bin/subfinder -t 30 -d $sub -silent &
        /go/bin/assetfinder --subs-only $sub &
        findomain --quiet -t $sub &
        wait;
    done
fi

