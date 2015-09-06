[![Alt text](http://wiki.pac-rom.com/images/3/39/Pac.png)](http://www.pac-rom.com)

[![Alt text](http://www.pac-rom.com/images/linksbar/pac.png "PAC Homepage ")](http://www.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/19.png "Vendor Repositories ")](https://github.com/Pinky-Inky-and-Clyde)
[![Alt text](http://www.pac-rom.com/images/linksbar/17.png "ROM Source ")](https://github.com/PAC-ROM)
[![Alt text](http://www.pac-rom.com/images/linksbar/18.png "Device and Kernel Repositories ")](https://github.com/Split-Screen)
[![Alt text](http://www.pac-rom.com/images/linksbar/6.png "Gerrit Review ")](http://review.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/9.png "Jenkins Build System ")](http://jenkins.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/10.png "Jenkins Builds and Stats ")](http://build.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/2.png "Crowdin Translations ")](https://crowdin.com/project/pac-rom)
[![Alt text](http://www.pac-rom.com/images/linksbar/1.png "Changelogs ")](http://changelog.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/11.png "JIRA Bugs and Issues Reporting ")](http://jira.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/16.png "Wiki - Tutorials and Info ")](http://wiki.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/5.png "Discussion and Support Forum ")](http://forum.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/3.png "Downloads ")](http://download.pac-rom.com)
[![Alt text](http://www.pac-rom.com/images/linksbar/13.png "Sharing Policy ")](http://pac-rom.com/#SharingPolicy)
[![Alt text](http://www.pac-rom.com/images/linksbar/12.png "Become a Maintainer ")](http://pac-rom.com/#BecomeAMaintainer)
[![Alt text](http://www.pac-rom.com/images/linksbar/14.png "PAC-ROM Stats ")](http://pac-rom.com/#Stats)
[![Alt text](http://www.pac-rom.com/images/linksbar/7.png "Google Plus ")](https://plus.google.com/102557242936341392082)
[![Alt text](http://www.pac-rom.com/images/linksbar/8.png "Google Plus Community ")](https://plus.google.com/communities/103029729817409918322)
[![Alt text](http://www.pac-rom.com/images/linksbar/15.png "Twitter ")](https://twitter.com/PACROMS)
[![Alt text](http://www.pac-rom.com/images/linksbar/4.png "Facebook ")](https://www.facebook.com/PACmanROMS)

To initialize on Linux:
```shell
repo init -u https://github.com/Arc-Team/android.git -b pac-5.0 -g all,-notdefault,-darwin
```
To initialize on MacOS:
```shell
repo init -u https://github.com/Arc-Team/android.git -b pac-5.0 -g all,-notdefault,-linux
```
Use our local manifests:

    Copy the file roomservice.xml located in "android/roomservice.xml"
    to ".repo/local_manifests/roomservice.xml"
    if if the directory "local_manifests" not exist, create it!

Then to sync up:
```shell
repo sync -f && repo sync -f
```
Then to build:
```shell
./build-pac.sh <device_code_name>
```
Example for HTC One XL:
```shell
./build-pac.sh evita
```
