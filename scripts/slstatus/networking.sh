
# ping -c 1 www.google.com > /dev/null; if [ $? -ne 0 ]; then 'echo 󱛅 |' ;fi
ping -c 1 www.google.com; [[ "$?" == "0" ]] && echo '󱛅 |'


# # --- Internet Status --- #
# ping -c 1 www.google.com > /dev/null
# if [ $? -eq 0 ]; then 
#   # Internet Connected
#   if [[ "$(mullvad status | head -n1)" == "Connected" ]]; then
#     WIRELESS_BAR="󰖩   |"
#   else
#     WIRELESS_BAR="󰖩   |"
#   fi
# else
#   # Internet Unavailable
#   WIRELESS_BAR="󱛅 |"
# fi
# 
# # --- Date Bar --- #
# DATE_BAR="$(date '+%A %B %d %r')"
# 
# # --- Encrypted Disk --- #
# ls -l / | grep persist-enc > /dev/null
# if [ $? -eq 0 ]; then
#   ENCRYPT_BAR="󰢬 |"
# else
#   ENCRYPT_BAR=""
# fi
# 
# # --- Battery Capacity --- #
# BAT_BAR="BAT $(cat /sys/class/power_supply/BAT0/capacity)% |"
# 
# echo " $BAT_BAR $ENCRYPT_BAR $WIRELESS_BAR $DATE_BAR "
