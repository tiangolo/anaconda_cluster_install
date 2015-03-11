#!/bin/bash
sshUser=$1
dstUser=$2
dstGroup=$3
anacondafile=$4
hostsString=$5

# Install Anaconda in many connected computers as the default Python for a user in that computer
# This is what is added by Anaconda to the .bashrc of the user with the Anaconda installation
# added by Anaconda 2.1.0 installer
# export PATH="/home/yarn/anaconda/bin:$PATH"

if [[ $# < 4 ]]
then
  echo "Usage: anaconda_install.sh <ssh user> <destiny user> <destiny group owner> <anaconda bash install file> <list of host addresses accessible by the current user, separated by ','>"
  echo "Example: bash anaconda_install.sh root yarn hadoop /home/user/Installers/Python/Anaconda-2.1.0-Linux-x86_64.sh 192.168.232.110,192.168.232.111,192.168.232.112"
  exit 1
fi

if [ ! -f $anacondafile ]
then
  echo "Your didn't provide an anaconda installation file"
  exit 1
fi

listOfHosts=${hostsString//,/ }

hostScriptInstall='cd ~; bash Anaconda*.sh -b;'

hostScriptPathComment='echo "# Add Anaconda to PATH" >> ~/.bashrc;'
toSuC='echo "export PATH=\"$HOME/anaconda/bin:\$PATH\"" >> ~/.bashrc;'

for host in $listOfHosts
do
  echo "rsync-ing file to $host"
  rsync $anacondafile $sshUser@$host:/home/$dstUser/
  echo "changing ownership of file in $host"
  ssh $sshUser@$host "chown $dstUser:$dstGroup /home/$dstUser/Anaconda*.sh"
  echo "changing permissions of file in $host"
  ssh $sshUser@$host "chmod 775 /home/$dstUser/Anaconda*.sh"
  echo "Installing Anaconda in $host"
  ssh $sshUser@$host "su $dstUser -c \"$hostScriptInstall\""
  echo "Adding Anaconda PATH comment to .bashrc of user $dstUser in host $host"
  ssh $sshUser@$host "su $dstUser -c '$hostScriptPathComment'"
  echo "Adding Anaconda PATH to .bashrc of user $dstUser in host $host"
  ssh $sshUser@$host "su $dstUser -c '$toSuC'"
done