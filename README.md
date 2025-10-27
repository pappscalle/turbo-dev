# turbo-dev
A "quick" tutorial on how to setup Turbo Pascal in Ubuntu so you can code like it's '93.


#### Requisites

* Turbo Pascal 7 (or other version)
* 7-Zip for extractinng Turbo Pascal installation files (Optional)
* DOSBox or preferrably DOSBox-X. DOSBox-X has much better support for demos (ie Goldplay works as intended)
* DOSEMU2
* Somewhere to place DOS programs e.g. `~/msdos`
* Somewhere to place your own source code e.g. `~/code/pascal`


#### Install DOSBox-X (https://www.dosbox-x.com/)

```
~$ sudo snap install dosbox-x
```

#### Install Turbo Pascal 7 (https://winworldpc.com/product/turbo-pascal/7x)

Download  _Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z_ to a temporary dirctory e.g `~/msdos/tmp`
Extract the file using 7-Zip. If 7-Zip isn't available, install it first.

```
~$ sudo apt install p7zip-full
~$ cd ~/msdos/tmp
~/tmp$ 7za x 'Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z'
```
Mount each file image  (right-click and run them with the _Disk Image Mounter_ program)
Exatract each image `Disk001.img`, `Disk002.img`, `Disk003.img`, `Disk004.img` into a directory e.g `~/msdos/tmp`
Run DOSBox

```
~$ cd ~/msdos
~$ dosbox-x
```

in DOSBox, mount the temporary directory where the Turbo Pascal files a extrected, and the run the Turbo Pascal installer

```
Z:\>mount c: .
Z:\>c:
Z:\>cd tmp
Z:\TMP\> install.exe
```
Install turbo pascal in a directory e.g `c:\apps\tp7` (`~/msdos/apps/tp7`) (and with the `*.exe` files in `c:\apps\tp7\bin`)
Exit DOSBox

####  Install DOSEMU2 (https://code.launchpad.net/~dosemu2/+archive/ubuntu/ppa)

On eg Ubuntu 20.04+ run the following to install DOSEMU2
```
sudo add-apt-repository ppa:dosemu2/ppa
sudo apt update
sudo apt install dosemu2
```
####  Go to the DOSEMU home folder:

```
~$ cd ~/.dosemu/drive_c
```
If the folder doesn't exist, run DOSEMU once to create the DOSEMU home folder, and the exit DOSEMU by typing "exitemu"
```
~$ dosemu
```


####  Create a soft link to the Turbo Pascal installation

```
~/.dosemu/drive_c$ ln -s ~/msdos/apps/tp7 tp7
```

```
~/.dosemu/drive_c$ ls -la
autoexec.bat
config.sys
tmp
tp7 -> /home/youruser/msdos/apps/tp7
```
#####  For DOSEMU2, creata a file called userhook.bat and include TP7 to the path

```
~/.dosemu/drive_c$ nano userhook.bat
```
Add `c:\tp7\bin` at the end of the _path_

```
set PATH=%PATH%;C:\tp7\bin

```

#### Create the source folder

Check out the example code in any folder e.g `~/code/pascal/turbo-dev`


####  Go to the source folder and compile a Pascal file from the command line:
```
~$ cd /code/pascal/turbo-dev/
~$ dosemu src/build.bat -dumb
```
or simply run 
```
~$ ant
```

will hopefully result in something like

```
D:\code\pascal\turbo-dev\src>TPC pixels.pas -B
Turbo Pascal  Version 7.0  Copyright (c) 1983,92 Borland International
PIXELS.PAS(170)
567 lines, 6624 bytes code, 5192 bytes data.
```

####  Run the pixels.exe file with DOSBox
```
~$ cd build
~/build$ dosbox-x -fastlaunch -exit pixels.exe
```
