#!/bin/bash

TOOLS="$HOME/bounty/tools";
source $HOME/.profile;

if [ "$1" == "" ];then
        echo "File name not found. script exited."
        exit 0
fi

for line in `cat $1`
do
    cd ~/bounty/tools/
    echo "~~~~" $line "~~~~"
    mkdir -pv "$line"_results;
    cd "$line"_results;
    
    #서브도메인 식별 도구 
    ../amass/amass enum -norecursive -noalts -d $line > 1_$line.txt;
    ../subfinder/subfinder -d $line -o 2_$line.txt;
    assetfinder --subs-only $line | tee -a 3_$line.txt;
    ../findomain -t $line -o;
    mv $line.txt 4_$line.txt;

    # 식별된 url 합침
    cat *_$line.txt | sort | uniq > target1_$line.txt;

    # 서브도메인 브루트포싱
    cat target1_$line.txt | dnsgen - > 5_o_$line.txt;
    goaltdns -l target1_$line.txt -w ~/go/src/github.com/subfinder/goaltdns/words.txt -o 6_o_$line.txt;
    python ../massdns/scripts/subbrute.py ../datafile/subdomains.txt $line > 7_o_$line.txt;

    # 식별된 url 합침
    cat *_o_* | sort | uniq > target2_$line.txt;

    # massdns 
    cat target2_$line.txt | massdns -r ../datafile/resolvers.txt -t A -o S -w 8_$line.txt;
    sed 's/A.*//' 8_$line.txt | sed 's/CN.*//' | sed 's/\..$//' > target3_$line.txt;
    cat target3_$line.txt | httprobe -c 40 -t 3000 -p http:8443 -p https:8443 -p http:8080 -p https:8 080 -p http:8008 -p https:8008 -p http:591 -p https:591 -p http:593 -p https:593 -p http:981 -p https:981 -p http:2480 -p https:2480 -p http:4567 -p https:4567 -p http:5000 -p https:5000 -p http:5800 -p https:5800 -p http:7001 -p https:7001 -p http:7002 -p https:7002 -p http:9080 -p https:9080 -p http:9090 -p https:9090 -p https:9443 -p https:18091 -p https:18092 | tee final_$line.txt;
    wc -l final_$line.txt;

    mkdir -pv "$line"/Screenshots;
    gowitness file --source=./final_"$line".txt --threads=4 --resolution="1200,750" --log-format=json --log-level=warn --timeout=60 --destination="./Screenshots";

done

