#!/bin/sh
read -p "Input the IP of host:" HOST1
read -p "Input the PORT of host:" PORT1
read -p "Input the USER of host:" USER1
#FILE1='/d/SmartAuto/project/cloud/core-service/target/core.war /d/SmartAuto/project/cloud/ui/target/ui.war /d/SmartAuto/project/cloud/ws/target/ws.war'
scp -P$PORT1 centosjiagu.sh $USER1@$HOST1:/tmp
ssh -p$PORT1 $USER1@$HOST1 'chmod a+x /tmp/centosjiagu.sh'
ssh -p$PORT1 $USER1@$HOST1 '/tmp/centosjiagu.sh'
