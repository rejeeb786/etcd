#!/bin/bash
echo "######################################################"
echo -e "########### \033[1;94mInitiating ETCD Backup Process\033[0m ###########"
echo "######################################################"
echo -e "# \033[1;91mTASK 1\033[0m: Create backup directory: /tmp/etcd-backup"
mkdir /tmp/etcd-backup 2> /dev/null
cd /tmp/etcd-backup  2> /dev/null
echo -e "# \033[1mTASK 1\033[0m: \033[1;92mCompleted\033[0m"
echo "###################"
echo -e "# \033[1;91mTASK 2\033[0m: Set master node hostname for debug"
node=$(oc get nodes -l node-role.kubernetes.io/master= -o jsonpath='{ .items[0].metadata.name }')
echo -e "# \033[1mTASK 2\033[0m: \033[1;92mCompleted\033[0m"
echo "###################"
echo -e "# \033[1;91mTASK 3\033[0m: Starting ETCD Backup"
oc debug node/${node} -- chroot /host sudo -E /usr/local/bin/cluster-backup.sh /tmp/assets/backup 2> /dev/null
oc debug node/${node} -- chroot /host sudo -E tar czf - /tmp/assets/backup > /tmp/etcd-backup/backup-$(date +\%d_%m_%Y-%H_%M_%S-%Z).tgz 2> /dev/null
oc debug node/${node} -- chroot /host sudo -E rm -rf /tmp/assets/backup/* 2> /dev/null
echo -e "# \033[1mTASK 3\033[0m: \033[1;92mCompleted\033[0m"
echo "####################################################"
echo -e "########### \033[1;94mETCD Backup Process Complete\033[0m ###########"
echo "####################################################"
