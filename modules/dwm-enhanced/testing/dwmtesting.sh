rm -rf dwm-6.5
tar -xvf dwm-6.5.tar.gz
cd dwm-6.5

clear
echo "# Patching dwm-borderrule-20231226-e7f651b.diff"
patch < ../../dwm-patches/dwm-borderrule-20231226-e7f651b.diff
echo 
cp config.def.h config.def.h.post-border-rule

echo " Patching dwm-center-6.2.diff"
patch < ../../dwm-patches/dwm-center-6.2.diff
echo 

#../dwm-patches/dwm-config.diff

#cp config.def.h config.def.h.old

# echo Patching config
# patch < ../../patch.dwm.12.config.def.h.diff
# echo 
