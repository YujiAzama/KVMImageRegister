# KVMImageRegister

## Overview

KVMImageRegister is the tool for create and define VM that is environment for testing.
You can create KVM image very easy and fastly if you use KVMImageRegister.

## Usage

You can clone KVMImageRegister as follows:

```bash
$ git clone https://github.com/YujiAzama/KVMImageRegister.git
$ cd KVMImageRegister/
```
Just execute create.sh as superuser to create new VM.

```bash
$ sudo ./create.sh
[Step1] Select base image number from below images.
  0: ubuntu-16.04.02-server-amd64
Base Image: 0

[Step2] Input new VM name.
  Used names: []
Image name: myvm

[Step3] Input memory size of new VM.
Memory size [GB]: 4

[Step4]Input VNC port number of new VM.
  Used Ports: []
VPC Port: 5900

Creating VM...
Domain myvm defined from myvm.xml

Domain myvm started


Image creating is Successful. New VM Info is below:

  Create Date : 2017-05-17 17:16:03
  MAC Address : 52:54:00:0d:b5:3b
  IP Address  : 192.168.122.190/24
  Host Name   : ubuntu

$
$ ssh ubuntu@192.168.122.190
The authenticity of host '192.168.122.190 (192.168.122.190)' can't be established.
ECDSA key fingerprint is SHA256:D59TTXIWlXdVPsNPPR2jnN9pMUrt4Vbn4FtF8oXSHhU.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.122.190' (ECDSA) to the list of known hosts.
ubuntu@192.168.122.190's password:   # Default password is "password".
Welcome to Ubuntu 16.04.2 LTS (GNU/Linux 4.4.0-62-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

76 packages can be updated.
32 updates are security updates.


Last login: Mon May 15 09:18:01 2017
ubuntu@ubuntu:~$
```

### Login to the VM using SSH

You can login to the VM. Default user name is "ubuntu", and default password is "password".
