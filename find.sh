#!/bin/bash

TOOLS="$HOME/bounty/tools";
source $HOME/.profile;

if [ "$1" == "" ];then
        echo "File name not found. script exited."
        exit 0
fi

for URI in `cat $1`
do
    cd "$HOME"/bounty/result;
    echo "**************" "$URI" "**************"
    mkdir "$URI";
    cd "$URI";
    
    #서브도메인 식별 도구 
    "$TOOLS"/amass/amass enum -norecursive -noalts -d "$URI" > amass_"$URI".txt;
    "$TOOLS"/subfinder/subfinder -d "$URI" -o subfinder_"$URI".txt;
    assetfinder --subs-only "$URI" | tee -a assetfinder_"$URI".txt;
    "$TOOLS"/findomain -t "$URI" -o;
    mv "$URI".txt findomain_"$URI".txt;

    # 식별된 url 합침
    cat *_"$URI".txt | sort | uniq > subdomain_"$URI".txt;

    # 서브도메인 브루트포싱
    cat subdomain_"$URI".txt | dnsgen - > dnsgen_o_"$URI".txt;
    goaltdns -l subdomain_"$URI".txt -w ~/go/src/github.com/subfinder/goaltdns/words.txt -o goaltdns_o_"$URI".txt;
    python "$TOOLS"/massdns/scripts/subbrute.py "$TOOLS"/datafile/subdomains.txt "$URI" > massdns_o_"$URI".txt;

    # 식별된 url 합침
    cat *_o_"$URI".txt | sort | uniq > subdomainAll_"$URI".txt;

    # massdns 
    cat subdomainAll_"$URI".txt | massdns -r "$TOOLS"/datafile/resolvers.txt -t A -o S -w massdns_"$URI".txt;
    sed 's/A.*//' massdns_"$URI".txt | sed 's/CN.*//' | sed 's/\..$//' > sed_"$URI".txt;
    cat sed_"$URI".txt | httprobe -c 40 -t 3000 -p http:8443 -p https:8443 -p http:8080 -p https:8 080 -p http:8008 -p https:8008 -p http:591 -p https:591 -p http:593 -p https:593 -p http:981 -p https:981 -p http:2480 -p https:2480 -p http:4567 -p https:4567 -p http:5000 -p https:5000 -p http:5800 -p https:5800 -p http:7001 -p https:7001 -p http:7002 -p https:7002 -p http:9080 -p https:9080 -p http:9090 -p https:9090 -p https:9443 -p https:18091 -p https:18092 | tee final_"$URI".txt;
    wc -l final_"$URI".txt;

    mkdir -pv /Screenshots;
    gowitness file --source=./final_"$URI".txt --threads=8 --resolution="1200,750" --log-format=json --log-level=warn --timeout=3 --destination="./Screenshots";

done

