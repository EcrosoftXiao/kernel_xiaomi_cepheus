# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Evasi0nKernel
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=cepheus
device.name2=Cepheus
device.name3=cepheus-user
device.name4=Mi 9
device.name5=Mi9
supported.versions=11
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel install
dump_boot;

## Screen OC
patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=4"
fr=$(cat /sdcard/framerate_override | tr -cd "[0-9]");
[ $fr -eq 66 ] && ui_print "   Setting 66 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=1"
[ $fr -eq 69 ] && ui_print "   Setting 69 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=2"
[ $fr -eq 72 ] && ui_print "   Setting 72 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=3"
[ $fr -eq 75 ] && ui_print "   Setting 75 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=4"
rm /sdcard/framerate_override

write_boot;
## end install

