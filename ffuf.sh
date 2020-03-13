TOOLS="$HOME/bounty/tools";
RESULT="$HOME/bounty/result";
source $HOME/.profile;


if [ "$1" == "" ];then
        echo "USAGE : bash ffuf.sh [URI]"
        exit 0
fi

touch "$RESULT"/"$1"/ffuf_"$1".txt;

for URI in `cat "$RESULT"/"$1"/final_"$1".txt`
do
    ffuf -w "$HOME"/bounty/tools/datafile/big.txt -u "$URI"/FUZZ -o "$RESULT"/"$1"/ffuf_"$URI".txt -t 200
done

cat "$RESULT"/"$1"/ffuf_*.txt | sort | uniq > ffuf_"$1".txt;


