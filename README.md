[PAC-man - The AIO ROM](https://github.com/PAC-man/pacman/tree/pac-4.4)
=======================

[Getting Started - Setup build environment](https://github.com/Arc-Team/android_vendor_arc/blob/pac-4.4/PrepareForBuild.md)
-------------------------------------------

To initialize on Linux:

    repo init -u git://github.com/Arc-Team/android.git -b pac-4.4 -g all,-notdefault,-darwin

To initialize on MacOS:

    repo init -u git://github.com/Arc-Team/android.git -b pac-4.4 -g all,-notdefault,-linux

Use our local manifests:

    Copy the file roomservice.xml located in "android/roomservice.xml"
    to ".repo/local_manifests/roomservice.xml"
    if if the directory "local_manifests" not exist, create it!

Then to sync up:

    repo sync -f && repo sync -f

Then to build:

    ./build-pac.sh <device_code_name>

Example for HTC One XL:

    ./build-pac.sh evita
