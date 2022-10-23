DATE=$(date +"%Y%m%d")
VERSION=$(git rev-parse --short HEAD)
KERNEL_NAME=Evasi0nKernel-cepheus-"$DATE"

export KERNEL_PATH=$PWD
export ANYKERNEL_PATH=~/Anykernel3
export CLANG_PATH=~/prelude-clang
export PATH=${CLANG_PATH}/bin:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=aarch64-linux-gnu-
export CROSS_COMPILE_ARM32=arm-linux-gnueabi-
export CLANG_PREBUILT_BIN=${CLANG_PATH}/bin
export CC="ccache clang"
export CXX="ccache clang++"
export LD=ld.lld
export LLVM=1
export LLVM_IAS=1
export ARCH=arm64
export SUBARCH=arm64

echo "===================Setup Environment==================="
git clone --depth=1 https://gitlab.com/jjpprrrr/prelude-clang.git $CLANG_PATH
git clone https://github.com/osm0sis/AnyKernel3 $ANYKERNEL_PATH
sh -c "$(curl -sSL https://github.com/akhilnarang/scripts/raw/master/setup/android_build_env.sh/)"

echo "=========================Clean========================="
rm -rf $KERNEL_PATH/out/ *.zip
make mrproper && git reset --hard HEAD

echo "=========================Build========================="
make O=out cepheus_defconfig
make O=out | tee out/kernel.log

if [ ! -e $KERNEL_PATH/out/arch/arm64/boot/Image.gz-dtb ]; then
    echo "=======================FAILED!!!======================="
    rm -rf $ANYKERNEL_PATH
    make mrproper>/dev/null 2>&1
    git reset --hard HEAD 2>&1
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
#rm -rf $CLANG_PATH
rm -rf $ANYKERNEL_PATH
echo $KERNEL_NAME.zip
