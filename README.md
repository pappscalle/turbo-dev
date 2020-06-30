# turbo-dev
A "quick" tutorial on how to setup Turbo Pascal for retro-inspired development in Ubuntu


##### Requisites

* Turbo Pascal 7 (or other version)
* 7-Zip for extractinng Turbo Pascal installation files (Optional)
* DOSBox or preferrably DOSBox-X. DOSBox-X has much better support for demos (ie Goldplay works as intended)
* DOSEMU
* Somewhere to place DOS programs e.g. `~/msdos`
* Somewhere to place your own source code e.g. `~/code/pascal`


##### Install DOSBox-X (https://www.dosbox-x.com/)

```
~$ sudo snap install dosbox-x
```

##### Install Turbo Pascal 7 (https://winworldpc.com/product/turbo-pascal/7x)

Download  _Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z_ to a temporary dirctory e.g `~/msdos/tmp`
Extract the file using 7-Zip. If 7-Zip isn't available, install it first.

```
~$ sudo apt install p7zip-full
~$ cd ~/msdos/tmp
~/tmp/$ 7za x 'Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z'
```
Mount each file image  (right-click and run them with the _Disk Image Mounter_ program)
Exatract each image `Disk001.img`, `Disk002.img`, `Disk003.img`, `Disk004.img` into a directory e.g `~/msdos/tmp`
Run DOSBox

```
~$ cd ~/msdos
~$ dosbox
```

in DOSBox, mount the temporary directory where the Turbo Pascal files a extrected, and the run the Turbo Pascal installer

```
Z:\>mount c: .
Z:\>cd tmp
Z:\TMP\> install.exe
```
Install turbo pascal in a directory e.g `~/msdos/apps/tp7` (and with the `*.exe` files in `/msdos/apps/tp7/bin`)
Exit DOSBox

#####  Install DOSEMU (http://www.dosemu.org/)

```
~$ sudo apt install dosemu
```

#####  Go to the DOSEMU home folder:

```
~$ cd ~/.dosemu/drive_c
```

#####  Create a soft link to the Turbo Pascal installation

```
~$ ln -s ~/msdos/apps/tp7 tp7
```

```
~$ ls -la
autoexec.bat
config.sys
tmp
tp7 -> /home/youruser/msdos/apps/tp7
```
#####  Edit the autoexec.bat and include TP7 to the path

```
~$ nano autoexec.bat
```
Add `c:\tp7\bin` at the end of the _path_

```
path z:\bin;z:\gnu;z:\dosemu;c:\tp7\bin
```


##### Create the source folder

Check out the example code in any folder e.g `~/code/pascal/turbo-dev`


#####  Go to the source folder and compile a Pascal file from the command line:
```
~$ cd /code/pascal/turbo-dev/src
~$ dosemu build.bat pixels.pas -dumb
```
will hopefully result in something like

```
D:\code\pascal\turbo-dev\src>TPC pixels.pas -B -Ooutput
Turbo Pascal  Version 7.0  Copyright (c) 1983,92 Borland International
PIXELS.PAS(170)
567 lines, 6624 bytes code, 5192 bytes data.
```

#####  Run the pixels.exe file with DOSBox
```
~$ dosbox-x pixels.exe
```
