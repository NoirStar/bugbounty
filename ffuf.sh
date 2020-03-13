TOOLS="$HOME/bounty/tools";
RESULT="$HOME/bounty/result";
source $HOME/.profile;


if [ "$1" == "" ];then
        echo "USAGE : bash ffuf.sh [URI]"
        exit 0
fi

touch "$RESULT"/"$1"/ffuf_"$1".txt;

for URI in `cat $1`
do
    ffuf -w "$HOME"/bounty/tools/datafile/big.txt -u "$URI"/FUZZ -a "$RESULT"/"$1"/ffuf_"$1".txt -t 200
done


