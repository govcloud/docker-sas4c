# Installation of SAS

## Launch Virtual Machine

```sh
cd packer-linux
./bin/ssh-box _output/box/virtualbox/centos7-desktop-desktop-0.0.1.box virtualbox
```

## Create SAS user

```sh
sudo useradd -m sas
sudo groupadd -g 1002 sasstaff
sudo usermod -a -G sasstaff sas
sudo echo -e "sas" | /usr/bin/passwd --stdin sas
sudo echo ' sas ALL=(ALL)   ALL' >> /etc/sudoers
```

## Adjust Limits.conf

Edit the following file `/etc/security/limits.conf`:

```sh
sas          soft    nofile     65336
sas          hard    nofile     65336
```

## Increase ulimits

```sh
ulimit -n 653336
ulimit -u 12080
```

## Prepare SASHome

```sh
sudo mkdir /usr/local/SASHome
sudo chown -R sas:sasstaff /usr/local/SASHome
cp -r ~/Downloads/SAS/download/SASDepot /private/tmp/boxtest/
```

## Install SAS

```sh
./setup.sh -console -deploy -record
```
