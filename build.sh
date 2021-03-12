DATE=$(date +"%Y%m%d")
VERSION=$(git rev-parse --short HEAD)
KERNEL_NAME=Evasi0nKernel-cepheus-"$DATE"

KERNEL_PATH=$PWD
CLANG_PATH=~/clang-proton
ANYKERNEL_PATH=~/Anykernel3

echo "===================Setup Environment==================="
git clone --depth=1 https://github.com/kdrag0n/proton-clang $CLANG_PATH
git clone https://github.com/osm0sis/AnyKernel3 $ANYKERNEL_PATH
sh -c "$(curl -sSL https://github.com/akhilnarang/scripts/raw/master/setup/android_build_env.sh/)"

echo "=========================Clean========================="
rm -rf $KERNEL_PATH/out/ *.zip
make mrproper

echo "=========================Build========================="
export ARCH=arm64
export SUBARCH=arm64
make O=out cepheus_defconfig
make -j4 O=out CC=$CLANG_PATH/bin/clang CROSS_COMPILE=$CLANG_PATH/bin/aarch64-linux-gnu- CROSS_COMPILE_ARM32=$CLANG_PATH/bin/arm-linux-gnueabi-

if [ ! -e $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb ]; then
    echo "=======================FAILED!!!======================="
    rm -rf $ANYKERNEL_PATH $CLANG_PATH $KERNEL_PATH/out/
    make mrproper>/dev/null 2>&1
    exit -1>/dev/null 2>&1
fi

echo "=========================Patch========================="
rm -r $ANYKERNEL_PATH/modules $ANYKERNEL_PATH/patch $ANYKERNEL_PATH/ramdisk
cp $KERNEL_PATH/anykernel.sh $ANYKERNEL_PATH/
cp $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_PATH/
cd $ANYKERNEL_PATH
zip -r $KERNEL_NAME *
mv $KERNEL_NAME.zip $KERNEL_PATH/out/
cd $KERNEL_PATH
rm -rf $CLANG_PATH
rm -rf $ANYKERNEL_PATH
echo $KERNEL_NAME.zip
