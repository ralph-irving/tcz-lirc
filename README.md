piCorePlayer 3.0+ releases includes native lirc support.


See this YouTube video on changing lircd.conf to fix multiple key presses when you press the remote button once.

https://www.youtube.com/watch?v=ENCXM16NGE4




LIRC IR Jivelite Setup

To create a lircd.conf for a different remote, see jivekeys.csv for the key symbols, that work with jivelite, during your irrecord session.

lircd v0.9.0 does not support keyboard modifiers, like SHIFT, CONTROL, ALT so you cannot use any of the shifted keys. ie Upper case letters! Key symbols postfixed with (NEW) require latest jivelite.tcz build, available now for piCorePlayer.
