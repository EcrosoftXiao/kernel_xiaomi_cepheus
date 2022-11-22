# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Evasi0nKernel
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=cepheus
device.name2=Cepheus
device.name3=cepheus-user
device.name4=Mi 9
device.name5=Mi9
supported.versions=13
supported.patchlevels=
'; } # end properties

# shell variables
block=auto;
is_slot_device=auto;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel install
split_boot;

## Screen OC
patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=6"
fr=$(cat /sdcard/framerate_override | tr -cd "[0-9]");
[ $fr -eq 66 ] && ui_print "   Setting 66 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=1"
[ $fr -eq 69 ] && ui_print "   Setting 69 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=2"
[ $fr -eq 72 ] && ui_print "   Setting 72 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=3"
[ $fr -eq 75 ] && ui_print "   Setting 75 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=4"
[ $fr -eq 81 ] && ui_print "   Setting 81 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=5"
[ $fr -eq 84 ] && ui_print "   Setting 84 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=6"
[ $fr -eq 90 ] && ui_print "   Setting 90 Hz refresh rate" && patch_cmdline "msm_drm.framerate_override" "msm_drm.framerate_override=7"
rm /sdcard/framerate_override

mv $home/rd-new.cpio $home/ramdisk-new.cpio

flash_boot;
## end install

