#!/bin/bash

# 1. Identitas Baru ZixineSu
word1="com"
word2="zixine"
word3="su"

# URL Logo Baru (Pastikan ini link langsung ke gambar PNG)
LOGO_URL="https://github.com/zixine/ZixineSu/blob/master/Branding/20260219_135939.png" # Ganti dengan link logo ZixineSu Anda

# Export variabel agar bisa digunakan oleh perintah find
export word1 word2 word3

# 2. Mengunduh dan Mengganti Logo (Icon)
echo "Downloading new logo for ZixineSu..."
curl -L -o new_logo.png "$LOGO_URL"

# Menimpa icon di semua folder mipmap
RES_PATH="app/src/main/res"
for dir in $RES_PATH/mipmap-*; do
    if [ -d "$dir" ]; then
        cp -f new_logo.png "$dir/ic_launcher.png"
        cp -f new_logo.png "$dir/ic_launcher_round.png"
    fi
done

# 3. Mengubah Struktur Direktori
echo "Renaming directories to $word1/$word2/$word3..."
find . -depth -type d -name 'me' -execdir mv {} "$word1" \;
find . -depth -type d -name 'weishu' -execdir mv {} "$word2" \;
find . -depth -type d -name 'kernelsu' -execdir mv {} "$word3" \;

# 4. Mengganti String di Dalam File
echo "Replacing package references in files..."
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/me\.weishu\.kernelsu/$word1.$word2.$word3/g" \
    -e "s/me\/weishu\/kernelsu/$word1\/$word2\/$word3/g" \
    -e "s/me_weishu_kernelsu/${word1}_${word2}_${word3}/g" \
    -e "s/KernelSU/ZixineSu/g" \
    -e "s/MamboSU/ZixineSu/g" {} +

# 5. Mengatur Nama Output APK di Gradle
if [ -f "./app/build.gradle.kts" ]; then
    sed -i 's/outputFileName = "KernelSU/outputFileName = "ZixineSu/g' ./app/build.gradle.kts
    sed -i 's/outputFileName = "MamboSU/outputFileName = "ZixineSu/g' ./app/build.gradle.kts
fi

echo "ZixineSu Branding Done."
