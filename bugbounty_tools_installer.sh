#!/usr/bin/env bash

TOOLS="$HOME/bounty/tools";

#기본환경 구성
sudo apt-get update;
sudo apt-get install unzip git gcc libpcap-dev wget curl nmap masscan nikto whatweb wafw00f chromium-browser python-pip python3-pip p7zip-full python-requests python-dnspython python-argparse apktool ruby-full build-essential zlib1g-dev openjdk-8-jre xfce4 xfce4-goodies tightvncserver firefox graphviz libgraphviz-dev -y;

mkdir -pv "$HOME"/bounty/tools;

# go 언어설치
wget -nv https://dl.google.com/go/go1.13.6.linux-amd64.tar.gz;
sudo tar -C /usr/local -xzf go1.13.6.linux-amd64.tar.gz;
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:" >> "$HOME"/.profile;
echo "export GOPATH=$HOME/go" >> "$HOME"/.profile;
source "$HOME"/.profile;
# 수정된 값을 바로 적용
rm -rf go1.13.6.linux-amd64.tar.gz;

# amass 설치 - 서브도메인 식별도구 
wget -nv https://github.com/OWASP/Amass/releases/download/v3.4.2/amass_v3.4.2_linux_amd64.zip -O "$TOOLS"/amass.zip;
unzip -j  "$TOOLS"/amass.zip -d "$TOOLS"/amass;
rm "$TOOLS"/amass.zip;

# subfinder 설치 - 서브도메인 식별도구 
mkdir -pv "$HOME"/bounty/tools/subfinder;
wget -nv https://github.com/projectdiscovery/subfinder/releases/download/v2.3.0/subfinder-linux-amd64.tar -O "$TOOLS"/subfinder.tar;
sudo tar -C "$TOOLS"/subfinder -xzf "$TOOLS"/subfinder.tar;
mv "$TOOLS"/subfinder/subfinder-linux-amd64 "$TOOLS"/subfinder/subfinder
rm "$TOOLS"/subfinder.tar;

# findomain  설치 - 서브도메인 식별도구
wget -nv https://github.com/Edu4rdSHL/findomain/releases/download/1.4.1/findomain-linux -O "$TOOLS"/findomain;
chmod 777 "$TOOLS"/findomain;

# Sublist3r 설치 - 서브도메인 식별도구
git clone https://github.com/aboul3la/Sublist3r.git "$TOOLS"/Sublist3r;
cd "$TOOLS"/Sublist3r;
sudo pip install -r requirements.txt;

#dnsgen 설치 - 있을거같은? 도메인 제작 도구
pip3 install dnsgen;

#Syborg 설치 - 요것도 도메인 제작 도구
git clone https://github.com/MilindPurswani/Syborg.git  "$TOOLS"/Syborg;
cd "$TOOLS"/Syborg;
pip3 install -r requirements.txt;
cd -;

# goalt 도 도메인제작 도구, ffuf 디렉토리 리스팅 도구
# tok 도메인 구조에서 맨앞에 단어 리스트 추출 도구
# httprobe 생존 서버 찾아주는거
# meg 요것도 생존서버 응답값에 따라 찾아줌
# unfurl 깔끔하게 도메인 뽑아주는 도구 http , 파라미터 문자열 제거
# zdns dns 서버 스캔도구
# goaltdns + gowitness + ffuf +  assetfinder + tok + httprobe + meg + unfurl 설치
source $HOME/.profile;
go get -u github.com/subfinder/goaltdns;
go get -u github.com/sensepost/gowitness;
go get -u github.com/ffuf/ffuf;
go get -u github.com/tomnomnom/assetfinder;
go get -u github.com/tomnomnom/hacks/tok;
go get -u github.com/tomnomnom/httprobe;
go get -u github.com/tomnomnom/meg;
go get -u github.com/tomnomnom/unfurl;
go get -u github.com/tomnomnom/zdns;


# massdns 설치 - 서브도메인 브루트포싱도구
git clone https://github.com/blechschmidt/massdns.git "$TOOLS"/massdns;
cd "$TOOLS"/massdns;
make && make install;
cd -;

# knock 설치 - 기본적인 도메인에 대한 정보, 서버 정보 등출력
git clone https://github.com/guelfoweb/knock "$TOOLS"/knock;
cd "$TOOLS"/knock;
sudo python setup.py install;
cd -;

# LinkFinder 설치 - 자바스크립트 안에 링크들 찾아주는것.
git clone https://github.com/GerbenJavado/LinkFinder.git  "$TOOLS"/LinkFinder;
cd "$TOOLS"/LinkFinder;
python setup.py install;
cd -;

# Arjun 설치 - 파라미터 브루트포싱
git clone https://github.com/s0md3v/Arjun "$TOOLS"/Arjun;

# XSStrike + xsscrapy 설치
git clone https://github.com/s0md3v/XSStrike "$TOOLS"/XSStrike;
git clone https://github.com/DanMcInerney/xsscrapy "$TOOLS"/xsscrapy;
gem install XSpear;
pip install -r "$TOOLS"/xsscrapy/requirements.txt;
pip install -r "$TOOLS"/XSStrike/requirements.txt;
  
#wordlist 다운로드
wget https://gist.github.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt;
wget https://github.com/assetnote/commonspeak2-wordlists/raw/master/subdomains/subdomains.txt;
cat all.txt subdomains.txt | sort | uniq > all_commonspeak2.txt;

#데이터 다운로드 

mkdir -pv "$HOME"/bounty/tools/datafile;
cd "$TOOLS"/datafile;
wget https://raw.githubusercontent.com/BBerastegui/fresh-dns-servers/master/resolvers.txt;
cp "$TOOLS"/Sublist3r/all_commonspeak2.txt "$TOOLS"/datafile/subdomains.txt