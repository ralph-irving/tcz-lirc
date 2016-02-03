lirc gpio IR support for picoreplayer 2.0 squeezelite ONLY.  See the bottom of README.md for Jivelite setup details.

Supported actions are

Power

Play

Pause

Next Track

Previous Track

Volume Up

Volume Down

To have the Pause action work reliably, you need to be running squeezelite v1.8.1-704 or higher.

The latest build for picoreplayer can be downloaded using the picoreplayer web gui.


A slimdevices/logitech remote is the default and already configured.

If you are using a squeezebox remote, create an empty .lircrc file


touch /home/tc/.lircrc


and skip to the Add lirc-rpi module section.


If you want to use a different remote you need to replace /usr/local/etc/lirc/lircd.conf with the config for your remote.  There are many lirc remote configurations available from http://lirc.sourceforge.net/remotes/ and I've included configuration files in git for a Sony RMT-116A DVD remote I created with the irrecord command as an example. (lircd-RMTD116A/lircrc-RMTD116A)

Add usr/local/etc/lirc/lircd.conf to the end of the file /opt/.filetool.lst

Create the mapping file for your remote.

See /usr/local/share/lirc/files/lircrc-squeezebox for an example.

You'll need to copy this file to /home/tc/.lircrc and update the remote and button values for your remote.

A big shout out to JackOfAll for the squeezebox remote lirc configuration files and Steen for the rpi irda kernel modules tcz files.  Thank you!


Add the lirc-rpi module to /mnt/mmcblk0p1/config.txt


sudo mount /mnt/mmcblk0p1

dtoverlay=lirc-rpi,gpio_in_pin=25

sudo umount /mnt/mmcblk0p1


I'm using the IR header on the IQaudIODAC which is gpio pin 25

Change the "25" to the gpio in pin you have your IR receiver diode connected.


Copy these files to /mnt/mmcblk0p2/tce/optional

irda-4.1.13-piCore+.tcz

irda-4.1.13-piCore+.tcz.md5.txt

irda-4.1.13-piCore_v7+.tcz

irda-4.1.13-piCore_v7+.tcz.md5.txt

lirc.tcz

lirc.tcz.dep

lirc.tcz.md5.txt


If you don't have shairport-sync enabled you also need to install 

http://ralph_irving.users.sourceforge.net/pico/libcofi.tcz

http://ralph_irving.users.sourceforge.net/pico/libcofi.tcz.md5.txt


Add lirc.tcz to the end of /mnt/mmcblk0p2/tce/onboot.lst


Add to one of the User commands fields on the tweaks page in the web gui.


/usr/local/sbin/lircd --device=/dev/lirc0


Add -i to the Various input field on the Squeezelite settings page.


Save your configuration and reboot.


See this YouTube video on changing lircd.conf to fix multiple key presses when you press the remote button once.

https://www.youtube.com/watch?v=ENCXM16NGE4


LIRC IR Jivelite Setup

Only works with a squeezebox3, classic, or touch slimdevices/logitech remote right now.  

Copy lircd-jivelite from git to /usr/local/etc/lirc/lircd.conf on picoreplayer

Add usr/local/etc/lirc/lircd.conf to the end of the file /opt/.filetool.lst

Add to one of the User commands fields on the tweaks page in the web gui.

/usr/local/sbin/lircd --device=/dev/lirc0 --uinput

Save your configuration and reboot.
