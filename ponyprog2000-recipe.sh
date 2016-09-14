#!/bin/bash

# Install build deps if needed
#sudo apt install build-essential libxmu-dev libxaw7-dev libxt-dev

PROJDIR=$PWD

rm -rf ~/PonyProg2000-2.08c || true
rm -rf ponyprog2000.AppDir || true

if [ ! -f PonyProg2000-2.08c.tar.gz  ]; then
	echo "Downloading Ponyprog sources"
	wget -c http://goo.gl/rcfLqr -O PonyProg2000-2.08c.tar.gz
fi

# These ugly build scripts should be run from home
cd ~/
tar -xf $PROJDIR/PonyProg2000-2.08c.tar.gz
sed -i '145d' ~/Pony*/v/srcx/Makefile 
cd ~/PonyProg* 
./config.sh $HOME 
make clean 
make

cd $PROJDIR

cp ~/PonyProg2000-2.08c/bin/ponyprog2000 .

rm -rf ~/PonyProg2000-2.08c || true

mkdir ponyprog2000.AppDir && cd ponyprog2000.AppDir
cp ../ponyprog2000 .
cp ../ponyprog2000.png .
cat >ponyprog2000.desktop <<EOF
[Desktop Entry]
Name=ponyprog2000
Exec=AppRun
Icon=ponyprog2000
Categories=Electronics
Type=Application
EOF

cat >AppRun <<EOF
#!/bin/sh
PAR=\$(dirname "\$(readlink -f "\$0")")
echo \$PAR
exec "\$PAR/ponyprog2000" "\$@"
EOF
chmod +x AppRun

cd $PROJDIR
rm ponyprog2000.AppImage || true
./AppImageAssistant* ponyprog2000.AppDir ponyprog2000.AppImage
