# **Setup of QEMU**

#clone the github repo of riscv arc
$ git clone https://github.com/ve3wwg/riscv.git -b master ~/riscv/repo
#copy the file
$ cp ~/riscv/repo/boot.sh ~/riscv/boot.sh
#install qemu system
$ sudo apt-get install qemu-system
#to check wether the riscv version has  been installed or not 
$ qemu-system-riscv64 --version

-----------------------------qemu package search------------------------------------------------
$ sudo apt search qemu
# after this command if the result does not contain qemu-system-riscv64 then execute the building instructions otherwise skip to setup line 95
----------------------------building instructions-----------------------------------------
#create a working directory
$ mkdir ~/work
$ cd work 
# clone from gitlab
$ git clone https://gitlab.com/qemu-project/qemu.git
$ cd ~/work/qemu
#check this specific version
$ git checkout v6.0.0-rc5
#configuration: make a directory for build
$ mkdir -p ~/work/qemu/build
$ cd ~/work/qemu/build
$ ../configure --target-list=riscv64-softmmu
# if you get some error in the above command execution then your system might not have ninja installed or some required files, so install the required files
$ sudo apt install ninja-build
$ sudo apt install pkg-build
$ sudo apt install libglib2.0-dev
$ sudo apt install libpixman-1-dev

#building qemu
$ cd ~/work/qemu/build
$ make 

#install qemu
$ cd ~/work/qemu/build
$ sudo make install
#congrats you have installed qemu
#verify the version
$ qemu-system-riscv64 --version
# if you get the required result then you can go in the work directory and remove qemu source code
$ cd ~/work
$ rm -rf ./qemu




------------------------------------------------Setup for Linux--------------------------

$ cd ~/riscv
#download the disc image, download the .elf file
$ wget 'https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/Fedora-Developer-Rawhide-20200108.n.0-fw_payload-uboot-qemu-virt-smode.elf'
#download the checksum file for verification that the file has not been tampered with
$ wget 'https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/Fedora-Developer-Rawhide-20200108.n.0-fw_payload-uboot-qemu-virt-smode.elf.CHECKSUM'
#verify the downloaded files with sha256sum
$ sha256sum 'Fedora-Developer-Rawhide-20200108.n.0-fw_payload-uboot-qemu-virt-smode.elf'
$ cat 'Fedora-Developer-Rawhide-20200108.n.0-fw_payload-uboot-qemu-virt-smode.elf'
#if the checksum mathc then the files are not tampered with, you can remvoe the checksum file
#now, download the fedora disk image
$ wget 'https://fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/Fedora-Developer-Rawhide-20200108.n.0-sda.raw.xz'
$ unxz Fedora-Developer-Rawhide-20200108.n.0-sda.raw.xz
$ ls -l Fedora-Developer-Rawhide-20200108.n.0-sda.raw
#give the required permissions to the boot.sh file in riscv folder which was copied earlier
$ chmod ug+rx ~/riscv/boot.sh

#if your system fails to find the qemu-system-riscv64 command then its directory needs to be added to your path
$ PATH="/usr/local/bin:$PATH"

-----------------------------------Boot Test on Linux-------------------------------------
$ cd ~/riscv 
$ ./boot.sh
# ssh is enabled so you can ssh into VM through port 10000 using the following command
$ ssh -p 10000 UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no riscv@locahost
#or you can use 
$ ssh -p 10000 riscv@localhost

------------------------------To access root-----------------------------
$ sudo -i
------------------------Fedora Shutdown-------------------------------
$ sudo /sbin/shutdown -h now
