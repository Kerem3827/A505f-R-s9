#!/bin/bash

clear

export CROSS_COMPILE=/home/grahame/toolchains/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CC=/home/grahame/toolchains/4639204/toolchain/clang/host/linux-x86/clang-4639204/bin/clang
export ARCH=arm64
export PLATFORM_VERSION=11
export ANDROID_MAJOR_VERSION=r
export defconfig=physwizz_defconfig
work_dir=$(pwd)
out_dir=$work_dir/out

mkdir -p "$out_dir"

clean_build() {
    make O="$out_dir" clean && make O="$out_dir" mrproper
    make O="$out_dir" ARCH=arm64 $defconfig
    make O="$out_dir" -j"$(nproc)"
    echo "✅ Clean build finished!"
    ls -lh "$out_dir/arch/arm64/boot/Image"
}

dirty_build() {
    make O="$out_dir" ARCH=arm64 $defconfig
    make O="$out_dir" -j"$(nproc)"
    echo "✅ Dirty build finished!"
    ls -lh "$out_dir/arch/arm64/boot/Image"
}

dirty_slow() {
    make O="$out_dir" ARCH=arm64 $defconfig
    make O="$out_dir"
    echo "⚠️ Dirty slow build finished (check errors)!"
    ls -lh "$out_dir/arch/arm64/boot/Image"
}

# parametre kontrol
if [ -n "$1" ]; then
    value="$1"
else
    echo -e "Choose : (1, 2, 3)\n
1. Clean build
2. Dirty build
3. Dirty slow
"
    read -r value
fi

case "$value" in
    "1") clean_build ;;
    "2") dirty_build ;;
    "3") dirty_slow ;;
    *) echo "Invalid input" ;;
esac
