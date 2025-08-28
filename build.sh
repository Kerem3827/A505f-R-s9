#!/usr/bin/env bash
set -e

DEVICE="gta4xlwifi"

KERNEL_DIR=$(pwd)
DEFCONFIG="physwizz_defconfig"
TOOLCHAIN_DIR="$KERNEL_DIR/toolchain"
OUT_DIR="$KERNEL_DIR/out"   # artık device eklenmiyor

# Önceki çıktıları temizle
rm -rf "$OUT_DIR" 
mkdir -p  "$OUT_DIR"



# Ortam değişkenleri
CLANG_PATH="$TOOLCHAIN_DIR/weebx"
export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE="$CLANG_PATH/bin/aarch64-linux-gnu-"
export CLANG_TRIPLE="$CLANG_PATH/bin/aarch64-linux-gnu-"
export PATH="$CLANG_PATH/bin:$PATH"

# Temizleme
echo "[INFO] Temiz build başlatılıyor..."
make O="$OUT_DIR" mrproper

# Defconfig
echo "[INFO] Defconfig uygulanıyor: $DEFCONFIG"
make O="$OUT_DIR" "$DEFCONFIG"

# Derleme (sadece Image)
echo "[INFO] Kernel derleniyor (yalnızca Image)..."
make -j$(nproc --all) O="$OUT_DIR" \
    LLVM=1 LLVM_IAS=1 \
    CC=clang \
    LD=ld.lld \
    AR=llvm-ar \
    NM=llvm-nm \
    OBJCOPY=llvm-objcopy \
    OBJDUMP=llvm-objdump \
    STRIP=llvm-strip \
    Image

# Başarı kontrolü
IMAGE_PATH="$OUT_DIR/arch/arm64/boot/Image"
if [ -f "$IMAGE_PATH" ]; then
    echo "[SUCCESS] $DEVICE için kernel başarıyla derlendi!"
    echo "[OUTPUT] Image dosyası yolu: $IMAGE_PATH"
    echo "::notice title=Kernel Build::$IMAGE_PATH"
else
    echo "[ERROR] Kernel derlemesi başarısız oldu."
    exit 1
fi