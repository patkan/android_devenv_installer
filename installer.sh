#!/bin/bash
#
# This is a fork of https://gist.github.com/tahl/1026610
#
#This script is designed to install the Android SDK, NDK, and Eclipse in Debian Jessie and make it easier for people that want to develop for Android using Linux.
#Script written by @ArchDukeDoug with special thanks to @BoneyNicole, @tabbwabb, and @animedbz16 for putting up with me and proofreading and/or testing the script.
#
# edited by Patrick Kanzler <patrick.kanzler@fablab.fau.de>
#Script version: 1.1
#
i=$(cat /proc/$PPID/cmdline)
if [[ $UID != 0 ]]; then
    echo "Please type sudo $0 $*to use this."
    exit 1
fi

apt-get update

#Download and install the Android SDK
if [ ! -d "/usr/local/android-sdk" ]; then
	for a in $( wget -qO- http://developer.android.com/sdk/index.html | egrep -o "http://dl.google.com[^\"']*linux.tgz" ); do 
		wget $a && tar --wildcards --no-anchored -xvzf android-sdk_*-linux.tgz; mv android-sdk-linux /usr/local/android-sdk; chmod 777 -R /usr/local/android-sdk; rm android-sdk_*-linux.tgz;
	done
else
     echo "Android SDK already installed to /usr/local/android-sdk.  Skipping."
fi

#Download and install the Android NDK
if [ ! -d "/usr/local/android-ndk" ]; then 
	for b in $(  wget -qO- http://developer.android.com/sdk/ndk/index.html | egrep -o "http://dl.google.com[^\"']*linux-x86.tar.bz2"
 ); do wget $b && tar --wildcards --no-anchored -xjvf android-ndk-*-linux-x86.tar.bz2; mv android-ndk-*/ /usr/local/android-ndk; chmod 777 -R /usr/local/android-ndk; rm android-ndk-*-linux-x86.tar.bz2;
	done
else
    echo "Android NDK already installed to /usr/local/android-ndk.  Skipping."
fi

d=ia32-libs

#Determine if there is a 32 or 64-bit operating system installed and then install ia32-libs if necessary.
# TODO necessary?

if [[ `getconf LONG_BIT` = "64" ]]; 

then
    echo "64-bit operating system detected.  Checking to see if $d is installed."

    if [[ $(dpkg-query -f'${Status}' --show $d 2>/dev/null) = *\ installed ]]; then
    	echo "$d already installed."
    else
        echo "Installing now..."
    	apt-get --force-yes -y install $d
    fi
else
	echo "32-bit operating system detected.  Skipping."
fi

#Check if Eclipse is installed
# TODO download Eclipse and plugin from website, because Debian is too old :-P
c=eclipse
	echo "checking if $c is installed" 2>&1
if [[ $(dpkg-query -f'${Status}' --show $c 2>/dev/null) = *\ installed ]]; 
then
	echo "$c already installed.  Skipping."
else 
	echo "$c was not found, installing..." 2>&1
	apt-get --force-yes -y install $c 2>/dev/null
fi

#Check if the ADB environment is set up.

if grep -q /usr/local/android-sdk/platform-tools /etc/bash.bashrc; 
then
    echo "ADB environment already set up"
else
    echo "export PATH=$PATH:/usr/local/android-sdk/platform-tools" >> /etc/bash.bashrc
fi

#Check if the ddms symlink is set up.

if [ -f /bin/ddms ] 
then
    rm /bin/ddms; ln -s /usr/local/android-sdk/tools/ddms /bin/ddms
else
    ln -s /usr/local/android-sdk/tools/ddms /bin/ddms
fi

#Create etc/udev/rules.d/51-android.rules file

touch -f 51-android.rules
echo "#Acer" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0502\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#ASUS" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0b05\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Dell" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"413c\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Foxconn" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0489\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Garmin-Asus" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"091E\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Google" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"18d1\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#HTC" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0bb4\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Huawei" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"12d1\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#K-Touch" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"24e3\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#KT Tech" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"2116\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Kyocera" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0482\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Lenevo" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"17EF\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#LG" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"1004\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Motorola" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"22b8\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#NEC" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0409\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Nook" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"2080\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Nvidia" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0955\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#OTGV" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"2257\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Pantech" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"10A9\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Philips" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0471\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#PMC-Sierra" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"04da\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Qualcomm" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"05c6\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#SK Telesys" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"1f53\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Samsung" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"04e8\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Sharp" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"04dd\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Sony Ericsson" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0fce\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#Toshiba" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"0930\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
echo "#ZTE" >> 51-android.rules
echo "SUBSYSTEM==\"usb\", SYSFS{idVendor}==\"19D2\", MODE=\"0666\", GROUP=\"plugdev\"" >> 51-android.rules
mv -f 51-android.rules /etc/udev/rules.d/
chmod a+r /etc/udev/rules.d/51-android.rules

#Check if ADB is already installed TODO still buggy
if [ ! -f "/usr/local/android-sdk/platform-tools/adb" ];
then
nohup /usr/local/android-sdk/tools/android update sdk > /dev/null 2>&1 &
zenity --info --text="Please accept the licensing agreement for Android SDK Platform-tools to install the Android Debug Bridge."
else
echo "Android Debug Bridge already detected."
fi
exit 0