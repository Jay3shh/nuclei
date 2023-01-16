if [ -z $1 ]
then
  echo "\No Arguments Passed"
else    
    for sub in $( cat $1); do
        #echo "Initiating for $sub at $now" 
        #echo "[+] Starting SubFinder" &
        subfinder -d $sub -t 100 -silent &
        assetfinder --subs-only $sub &
        findomain --quiet -t $sub &
        wait;
    done
fi
