#!/bin/bash

# 1. Identitas Baru ZixineSu
word1="com"
word2="zixine"
word3="su"

# URL Logo Baru - PASTIKAN INI LINK LANGSUNG (DIRECT LINK) KE GAMBAR PNG
# Jika ragu, biarkan kosong dulu atau gunakan link yang valid.
LOGO_URL="https://github.com/zixine/ZixineSu/blob/master/Branding/20260219_135939.png" 

export word1 word2 word3

# 2. Perbaikan Error "Multiple substitutions" (PENTING!)
echo "Fixing string substitution errors..."
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/version %d is too low/version %1$d is too low/g' {} +
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/version %d or higher/version %2$d or higher/g' {} +

# 3. Mengunduh dan Mengganti Logo (Hanya jika URL tidak kosong)
if [ ! -z "$LOGO_URL" ]; then
    echo "Downloading new logo..."
    curl -L -o new_logo.png "$LOGO_URL"
    
    # Cek apakah yang didownload benar-benar gambar
    if file new_logo.png | grep -qE 'image|bitmap'; then
        RES_PATH="app/src/main/res"
        for dir in $RES_PATH/mipmap-*; do
            if [ -d "$dir" ]; then
                cp -f new_logo.png "$dir/ic_launcher.png"
                cp -f new_logo.png "$dir/ic_launcher_round.png"
            fi
        done
        echo "Logo updated successfully."
    else
        echo "WARNING: Downloaded file is not a valid image. Skipping logo update to prevent build failure."
    fi
fi

# 4. Mengubah Struktur Direktori
echo "Renaming directories..."
find . -depth -type d -name 'me' -execdir mv {} "$word1" \;
find . -depth -type d -name 'weishu' -execdir mv {} "$word2" \;
find . -depth -type d -name 'kernelsu' -execdir mv {} "$word3" \;

# 5. Mengganti String di Dalam File
echo "Replacing package references..."
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/me\.weishu\.kernelsu/$word1.$word2.$word3/g" \
    -e "s/me\/weishu\/kernelsu/$word1\/$word2\/$word3/g" \
    -e "s/me_weishu_kernelsu/${word1}_${word2}_${word3}/g" \
    -e "s/KernelSU/ZixineSu/g" \
    -e "s/MamboSU/ZixineSu/g" {} +

# 6. Mengatur Nama Output APK di Gradle
if [ -f "./app/build.gradle.kts" ]; then
    sed -i 's/outputFileName = "KernelSU/outputFileName = "ZixineSu/g' ./app/build.gradle.kts
    sed -i 's/outputFileName = "MamboSU/outputFileName = "ZixineSu/g' ./app/build.gradle.kts
fi

echo "ZixineSu Branding & Fixes Done."
