#!/bin/sh

echo "Creating admin user."

sudo groupadd -g 1001 admin
sudo useradd -u 1001 -g admin admin
sudo usermod -a -G wheel admin
sudo sed -i -e 's/^# %wheel/%wheel/' /etc/sudoers
sudo mkdir ~admin/.ssh
sudo chown admin:admin ~admin/.ssh
sudo chmod 700 ~admin/.ssh
sudo cp ~/.ssh/authorized_keys ~admin/.ssh/authorized_keys
sudo chmod 600 ~admin/.ssh/authorized_keys
sudo chown admin:admin ~admin/.ssh/authorized_keys

echo "Setup DNS and Host Name."
which nmcli >/dev/null 2>&1
if [ $? -ne 0 ]; then
  sudo yum install -y NetworkManager
  sudo systemctl enable NetworkManager
  sudo systemctl start NetworkManager
fi

ifName=$(nmcli -t -f NAME c show --active)
sudo nmcli c m "$ifName" ipv4.ignore-auto-dns yes
sudo nmcli c m "$ifName" ipv4.dns "10.18.1.208,10.18.1.176"
sudo nmcli c m "$ifName" ipv4.dns-search "perflab.local"
sudo nmcli connection up "$ifName"

sudo bash -c 'cat <<EOF > /etc/resolv.conf
search perflab.local
nameserver 10.18.1.208
nameserver 10.18.1.176
EOF'

sudo hostnamectl set-hostname $HOSTNAME

IP_ADDRESS=$(nmcli c s System\ eth0 | grep "IP4.ADDRESS" | awk '{print $2}' | sed -e 's/\/.*$//')

sudo sh -c "echo \"$IP_ADDRESS $HOSTNAME\" >> /etc/hosts"

echo "Disabling THP."

sudo bash -c 'cat <<EOF > /etc/init.d/disable-thp
#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-thp
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    couchbase-server
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable THP
# Description:       disables Transparent Huge Pages (THP) on boot
### END INIT INFO

case $1 in
start)
  if [ -d /sys/kernel/mm/transparent_hugepage ]; then
    echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled
    echo 'never' > /sys/kernel/mm/transparent_hugepage/defrag
  elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
    echo 'never' > /sys/kernel/mm/redhat_transparent_hugepage/enabled
    echo 'never' > /sys/kernel/mm/redhat_transparent_hugepage/defrag
  else
    return 0
  fi
;;
esac
EOF'

sudo chmod 755 /etc/init.d/disable-thp

sudo chkconfig --add disable-thp

sudo mkdir /etc/tuned/no-thp

sudo bash -c 'cat <<EOF > /etc/tuned/no-thp/tuned.conf
[main]
include=virtual-guest

[vm]
transparent_hugepages=never
EOF'

sudo tuned-adm profile no-thp

echo "Configuring swappiness."

sudo sh -c 'echo "vm.swappiness = 0" >> /etc/sysctl.conf'

echo "Installng software."

sudo yum install -y epel-release
sudo yum install -y bzip2 jq git python-pip wget vim-enhanced xmlstarlet java-1.8.0-openjdk maven nc sysstat

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo usermod -a -G docker admin

sudo systemctl start docker
sudo systemctl enable docker

sudo mkdir /home/admin/bin
sudo git clone https://github.com/mminichino/perf-lab-bin /home/admin/bin
sudo chown -R admin:admin /home/admin/bin

echo "Process Complete."
exit 0
