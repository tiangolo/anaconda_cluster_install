Anaconda Cluster Install
========================

Tool to automate the installation of Anaconda Python in a cluster of linux computers.


What it does
------------

* It takes a local Anaconda installation file and copies it to each of your selected machines, using a user of your choice (a "ssh user") to copy and execute the commands on each machine (e.g. root) 

* It enters each machine, as that "ssh user" (e.g. root) and there, it changes to another user of your choice, a "destiny user", and installs Anaconda for that "destiny user".

* It makes Anaconda the default Python installation, only for your "destiny user".


Why Anaconda
------------

* It's open source

* It's Python 2.7, the latest 2.* version

* It includes Numpy, IPython and lots of other cool things, pre-configured and pre-compiled for your architecture 


A use case
----------

Imagine you have a Hadoop cluster, with CentOS 6.* machines. 
(Because CentOS 6.* is the version supported by most Hadoop Distributions). 
The default Python version is 2.6.

You want to use [Spark](https://spark.apache.org/) in that cluster to read from HDFS and execute in YARN, using PySpark.
For that you would probably need Python 2.7 and Numpy, IPython, etc. 
But you should not override the default system's Python installation, many system components may depend on it.

So, this script will allow you to: 

* download Anaconda once (instead of once for each machine to be installed)
* copy the installer to each of your machines using the `root` user, which probably already has passwordless SSH keys configured in all your machines
* connect to each of your machines using again your `root` user, and install Anaconda only for the `yarn` user, which is the one that runs Spark

So, if you have passwordless keys configured for your "ssh user", you can run the script and go for a coffee while you wait for it to finish.


How to use
----------

* Go to the Anaconda Python website: https://store.continuum.io/cshop/anaconda/
 
* Go to the downloads link.

* Select the Linux installer.

* Download the installer for your version of linux (x86 or x64), it's a .sh file.

* Run this script with:

        anaconda_install.sh <ssh user> <destiny user> <destiny group owner> <anaconda bash install file> <list of host addresses accessible by the current user, separated by ','>`
        
So, for example:

        bash anaconda_install.sh root yarn hadoop /home/user/Installers/Python/Anaconda-2.1.0-Linux-x86_64.sh 192.168.232.110,192.168.232.111,192.168.232.112"
        
Or:

        cd ~/Downloads
        bash anaconda_install.sh root yarn hadoop Anaconda*.sh node01,node02,node03,node04,node05"
        
After the installation is complete, you may need to reboot the machines, so that the services running under your "destiny user" user recognize the new environment with the new Python binaries.