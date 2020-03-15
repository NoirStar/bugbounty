TOOLS="$HOME/bounty/tools";
RESULT="$HOME/bounty/result";
source $HOME/.profile;


if [ "$1" == "" ];then
        echo "USAGE : bash ffuf.sh [URI]"
        exit 0
fi


for URI in `cat "$RESULT"/"$1"/final_"$1".txt | sed 's/^.*:\/\///'`
do
    ffuf -w "$HOME"/bounty/tools/datafile/big.txt -u "$URI"/FUZZ -mc 200 -o "$RESULT"/"$1"/ffuf_"$URI".json -t 200;
    touch "$RESULT"/"$1"/ffuf_"$URI".txt;
    for SUB in `jq -r ".results[].input[]" "$RESULT"/"$1"/ffuf_"$URI".json;`
    do
        "$URI"/"$SUB" >> "$RESULT"/"$1"/ffuf_"$URI".txt;
    done
done


jq -r ".results[].input[]"
cat "$RESULT"/"$1"/ffuf_*.txt | sort | uniq > ffuf_"$1".txt;


