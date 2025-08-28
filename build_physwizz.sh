#!/bin/bash


clear

export CROSS_COMPILE=/home/grahame/toolchains/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export 
CC=/home/grahame/toolchains/4639204/toolchain/clang/host/linux-x86/clang-4639204/bin/clang
export ARCH=arm64
export PLATFORM_VERSION=11
export ANDROID_MAJOR_VERSION=r
export defconfig=physwizz_defconfig
work_dir=$(pwd)


clean_build() {
    make clean && make mrproper
    make ARCH=arm64 $defconfig
    make -j64
    cp $work_dir/arch/arm64/boot/Image $work_dir/out
    echo "Done!"    
}

dirty_build() {
    make ARCH=arm64 $defconfig
    make -j64
    cp $work_dir/arch/arm64/boot/Image $work_dir/out
    echo "Done !"       
}


dirty_slow() {
    make ARCH=arm64 $defconfig
    make 
    cp $work_dir/arch/arm64/boot/Image $work_dir/out
    echo "Check for errors"       
}


echo -e "Choose : (1, 2, 3)

1. Clean build
2. Dirty build
3. Dirty slow

Your choice : "

read -r value
if [ "$value" == "1" ]; then
    clean_build
elif [ "$value" == "2" ]; then
    dirty_build     
elif [ "$value" == "3" ]; then
    dirty_slow    
else
    echo "Invalid input"
fi
