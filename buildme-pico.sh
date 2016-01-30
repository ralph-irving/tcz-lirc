#!/bin/sh

LIRC=lirc
LIRCVERSION=0.9.0
SRC=${LIRC}-$LIRCVERSION
STARTDIR=`pwd`
LOG=$STARTDIR/config.log
OUTPUT=$STARTDIR/${LIRC}-build  
TCZ=${LIRC}.tcz

# Build requires these extra packages in addition to the raspbian 7.6 build tools
# sudo apt-get install squashfs-tools bsdtar

## Start
echo "Most log mesages sent to $LOG... only 'errors' displayed here"
date > $LOG

# Clean up
if [ -d $OUTPUT ]; then
        sudo rm -rf $OUTPUT >> $LOG
fi

if [ -d $SRC ]; then
        rm -rf $SRC >> $LOG
fi

## Build
echo "Untarring..."
bsdtar -xf $SRC.tar.bz2 >> $LOG 

echo "Configuring..."
cd $SRC >> $LOG

CC="gcc -march=armv6 -mfloat-abi=hard -mfpu=vfp -Os -pipe" \
CXX="g++ -march=armv6 -mfloat-abi=hard -mfpu=vfp -Os -pipe -fno-exceptions -fno-rtti" \
LDFLAGS="-s -Wl,-rpath,/usr/local/lib" \
./configure \
--prefix=/usr/local \
--sysconfdir=/usr/local/etc \
--with-driver=userspace \
--enable-sandboxed \
--with-transmitter \
--enable-static=yes \
--enable-shared=yes \
--without-x

# --with-moduledir=/usr/local/lib/modules/4.1.13-piCore+/kernel/drivers/misc
# --with-kerneldir=$STARTDIR/$SRC/usr/src/linux-headers-$KERNVER/

find . -name Makefile -type f -exec sed -i 's/-O2 -g/-s/g' {} \;

echo "Running make"
make >> $LOG

if [ -d pkg ]; then
        rm -rf pkg
fi

make install DESTDIR=`pwd`/pkg >> $LOG

echo "Building tcz"
cd $STARTDIR >> $LOG

if [ -f $TCZ ]; then
        rm $TCZ >> $LOG
fi

mkdir -p $OUTPUT/usr/local/etc/lirc >> $LOG
mkdir -p $OUTPUT/usr/local/share/lirc/files >> $LOG
mkdir -p $OUTPUT/usr/local/tce.installed >> $LOG

cd $STARTDIR/$SRC/pkg/usr/local >> $LOG

bsdtar -cf - bin sbin lib | (cd $OUTPUT/usr/local; bsdtar -xf -)

cd $OUTPUT >> $LOG

cp -p $STARTDIR/tce.lirc $OUTPUT/usr/local/tce.installed/lirc
cp -p $STARTDIR/lircrc-squeezebox $OUTPUT/usr/local/share/lirc/files
cp -p $STARTDIR/lircd.conf $OUTPUT/usr/local/share/lirc/files

rm $OUTPUT/usr/local/lib/liblirc_client.la
mv $OUTPUT/usr/local/lib/liblirc_client.a $STARTDIR/

sudo chown -Rh root:root usr >> $LOG
sudo chown tc:staff usr/local/etc/lirc >> $LOG
sudo chown tc:staff usr/local/tce.installed/lirc >> $LOG
sudo chown tc:staff usr/local/share/lirc/files/* >> $LOG

sudo chown root:root $OUTPUT

cd $STARTDIR
mksquashfs $OUTPUT $TCZ >> $LOG
md5sum $TCZ > ${TCZ}.md5.txt
