#!/bin/bash

# 1. IDENTITAS BRANDING
# Mengikuti pola RapliVx: Ganti semua referensi teks
OLD_PKG="me.weishu.kernelsu"
NEW_PKG="com.zixine.su"
OLD_NAME="KernelSU"
NEW_NAME="ZixineSu"

# URL LOGO (Wajib link raw agar sinkron)
LOGO_URL="https://raw.githubusercontent.com/zixine/ZixineSu/master/Branding/20260219_135939.png"

echo "--- [ZIXINESU] Memulai Proses Branding Ala MamboSU ---"

# 2. DOWNLOAD & REPLACE LOGO (Metode Sinkron)
if [ ! -z "$LOGO_URL" ]; then
    echo "Downloading Branding Assets..."
    curl -L -o zixine_logo.png "$LOGO_URL"
    
    if file zixine_logo.png | grep -qE 'image|PNG|JPEG'; then
        RES_PATH="app/src/main/res"
        
        # Hapus file XML Ikon Adaptif (Metode RapliVx untuk force PNG)
        # Android modern akan mengabaikan PNG jika XML ini masih ada
        find $RES_PATH -name "ic_launcher.xml" -delete
        find $RES_PATH -name "ic_launcher_round.xml" -delete
        find $RES_PATH -name "ic_launcher_foreground.xml" -delete
        find $RES_PATH -name "ic_launcher_background.xml" -delete

        # Menimpa semua folder mipmap & drawable (Semua Resolusi)
        # RapliVx menggunakan pola loop untuk memastikan semua density kena
        for folder in $(find $RES_PATH -type d -name "mipmap-*" -o -name "drawable-*"); do
            cp -f zixine_logo.png "$folder/ic_launcher.png"
            cp -f zixine_logo.png "$folder/ic_launcher_round.png"
            # MamboSU kadang menimpa logo di drawable juga
            [ -f "$folder/logo.png" ] && cp -f zixine_logo.png "$folder/logo.png"
            echo "Menimpa aset di: $folder"
        done
    else
        echo "FAIL: Link logo salah atau bukan gambar!"
    fi
fi

# 3. FIX STRING POSITIONALS (Fix Error mergeReleaseResources)
find $RES_PATH -type f -name "strings.xml" -exec sed -i 's/%d/%1$d/1' {} +
find $RES_PATH -type f -name "strings.xml" -exec sed -i 's/%d/%2$d/2' {} +

# 4. FIX RESIDU MAMBO/KERNELSU
# Mengikuti cara RapliVx membersihkan resource yang tidak ditemukan
find . -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.java" \) -exec sed -i 's/app_name_mambo/app_name/g' {} +

# 5. RENAME PACKAGE DIRECTORY
# com/zixine/su
mkdir -p "app/src/main/java/com/zixine/su"
# (Proses pindah file biasanya ditangani oleh sed, tapi folder harus ada)

# 6. GLOBAL TEXT REPLACEMENT (Branding Total)
echo "Replacing strings: $OLD_NAME -> $NEW_NAME"
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/$OLD_PKG/$NEW_PKG/g" \
    -e "s/me\/weishu\/kernelsu/com\/zixine\/su/g" \
    -e "s/KernelSU/$NEW_NAME/g" \
    -e "s/MamboSU/$NEW_NAME/g" {} +

echo "--- [ZIXINESU] Branding Selesai! ---"
