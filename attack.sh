
TOOLS="$HOME/bounty/tools";
source $HOME/.profile;


if [ "$1" == "" ];then
        echo "USAGE : bash attack.sh [URI]"
        exit 0
fi


python3 "$TOOLS"/XSStrike/xsstrike.py -t 8 --seeds "$HOME"/bounty/result/"$1"/final_"$1".txt
