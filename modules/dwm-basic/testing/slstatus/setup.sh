rm -rf slstatus-1.1
tar -xvf slstatus-1.1.tar.gz
cd slstatus-1.1

cp config.def.h config.def.h.old
#patch < ../../../patch.slstatus.diff
