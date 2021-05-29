#!/usr/bin/env bash
ip=`ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
mkdir -p keys
cntFile=".showcnt.txt"
if [ ! -f $cntFile ]; then
echo "未运行step1！"
exit
fi

tCnt=`cat $cntFile`
for ((i=1; i<=tCnt; i ++))
do
echo "对第$i个节点添加自动提取。"
cp /var/lib/bee/node${i}/keys/swarm.key ./keys
mv ./keys/swarm.key ./keys/${ip}-${i}.key
echo "00 02 * * * root /cashout${i}.sh cashout-all" >> /etc/crontab
nohup bee start --config node${i}.yaml &
echo "第$i个节点已启动。"
screen -ls
done
