{ config, pkgs }:

let 
  localLuks = config.consts.localLuks;
in

pkgs.writeShellScriptBin "unlock" '' 
   doas cryptsetup open ${localLuks.device} ${localLuks.mapperName}
   doas mkdir ${localLuks.mountPoint}
   doas mount /dev/mapper/${localLuks.mapperName} ${localLuks.mountPoint}

   doas mkdir /var/lib/audiobookshelf
   doas mount --bind ${localLuks.mountPoint}/audiobookshelf/dataDir /var/lib/audiobookshelf

   doas systemctl start mnt-localLuks.service

   doas mkdir /home/andrew/luks
   doas chown -R andrew:users /home/andrew/luks
   doas mount --bind ${localLuks.mountPoint} /home/andrew/luks

''
