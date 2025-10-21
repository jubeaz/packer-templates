https://wiki.archlinux.org/title/QEMU#Preparing_an_Arch_Linux_guest


* user: jubeaz:jubeaz
* keymap fr
* hostname: packer (packerlocal)
* ufw enable default inbound allow 
* timezone: UTC (param)
* locale: en_US.UTF-8 UTF-8 and fr_FR.UTF-8 UTF-8
* swap: 4G
* packages: 
    * base: gptfdisk rng-tools reflector lsof bash-completion openssh rsync ufw libpwquality mlocate pacman-contrib ansible git vim python python-cryptography
    * additional: none
* reflector: 