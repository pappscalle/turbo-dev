# turbo-dev
Turbo Pascal 7 on Ubuntu using DOSEMU2.

#### Prerequisites

* Ubuntu 20.04+
* Turbo Pascal 7 archive from https://winworldpc.com/product/turbo-pascal/7x

#### 1. Install dependencies

```
sudo add-apt-repository ppa:dosemu2/ppa
sudo apt update
sudo apt install p7zip-full dosbox-x dosemu2 dj64 wget
```

#### 3. Fix libdj64 (if needed)

If you see this error when running `dosemu`:
```
cannot dlopen .../COMMAND.COM: libdj64.so.0.2: cannot open shared object file: No such file or directory
```
The `dj64` package installs its library in a non-standard path. Fix it with:

```
sudo ln -sf /usr/lib/x86_64-linux-gnu/i386-pc-dj64/lib64/libdj64.so.0.2 /usr/lib/x86_64-linux-gnu/libdj64.so.0.2
sudo ln -sf /usr/lib/x86_64-linux-gnu/i386-pc-dj64/lib64/libdj64.so.0 /usr/lib/x86_64-linux-gnu/libdj64.so.0
sudo ldconfig
```

#### 4. Extract Turbo Pascal

Download _Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z_ to `~/msdos/tmp`, then:

```
mkdir -p ~/msdos/tmp ~/msdos/apps/tp7/bin ~/msdos/apps/tp7/units
cd ~/msdos/tmp
7z e 'Borland Turbo Pascal 7.0 (1992) (3.5-720k).7z' -aoa
mkdir extracted
for img in *.img; do 7z x "$img" -aoa -oextracted; done
7z e extracted/TPC.ZIP   -aoa -o../apps/tp7/bin
7z e extracted/TURBO.ZIP -aoa -o../apps/tp7/bin
7z e extracted/TPL.ZIP   -aoa -o../apps/tp7/bin
7z e extracted/UNITS.ZIP -aoa -o../apps/tp7/units
```

#### 5. Configure DOSEMU2

Run `dosemu` once to initialize `~/.dosemu/drive_c`, then exit by typing `exitemu`.

```
dosemu
```

Create a symlink and configure the PATH:

```
ln -s ~/msdos/apps/tp7 ~/.dosemu/drive_c/tp7
echo 'set PATH=%PATH%;C:\tp7\bin' >> ~/.dosemu/drive_c/userhook.bat
```

#### 6. Compile

```
cd ~/code/pascal/turbo-dev
dosemu -K src/build.bat -dumb
```

or simply run `ant`.

#### 7. Run

```
cd build
dosbox-x pixels.exe
```
