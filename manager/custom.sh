#!/bin/bash

# 1. IDENTITAS & LOGO ZIXINESU
word1="com"
word2="zixine"
word3="su"

# URL LOGO (Wajib Raw Link Direct)
LOGO_URL="https://raw.githubusercontent.com/zixine/ZixineSu/master/Branding/20260219_135939.png"

export word1 word2 word3

echo "--- Memulai Branding ZixineSu & Logo Fix ---"

# 2. PENGGANTIAN LOGO (FORCE PNG)
if [ ! -z "$LOGO_URL" ]; then
    echo "Downloading logo from: $LOGO_URL"
    curl -L -o new_logo.png "$LOGO_URL"
    
    if file new_logo.png | grep -qE 'image|bitmap|PNG|JPEG'; then
        echo "Gambar valid. Menghapus ikon adaptif XML dan mengganti PNG..."
        RES_PATH="app/src/main/res"
        
        # WAJIB: Hapus semua file XML icon yang menutupi PNG kita di Android modern
        find $RES_PATH -name "ic_launcher.xml" -delete
        find $RES_PATH -name "ic_launcher_round.xml" -delete
        find $RES_PATH -name "ic_launcher_foreground.xml" -delete
        find $RES_PATH -name "ic_launcher_background.xml" -delete

        # Ganti semua ikon PNG di folder mipmap
        for dir in $RES_PATH/mipmap-*; do
            if [ -d "$dir" ]; then
                cp -f new_logo.png "$dir/ic_launcher.png"
                cp -f new_logo.png "$dir/ic_launcher_round.png"
                echo "Updated icons in $dir"
            fi
        done
        echo "Logo ZixineSu berhasil diterapkan."
    else
        echo "ERROR: File yang didownload bukan gambar valid!"
    fi
fi

# 3. PERBAIKAN FORMAT STRING
echo "Memperbaiki variabel string..."
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%1$d/1' {} +
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%2$d/2' {} +

# 4. MEMBERSIHKAN SISA MAMBOSU
echo "Pembersihan sisa MamboSU..."
find . -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.java" \) -exec sed -i 's/app_name_mambo/app_name/g' {} +

# 5. RENAME FOLDER PACKAGE
echo "Mengubah folder package ke $word1/$word2/$word3..."
find . -depth -type d -name 'me' -execdir mv {} "$word1" \;
find . -depth -type d -name 'weishu' -execdir mv {} "$word2" \;
find . -depth -type d -name 'kernelsu' -execdir mv {} "$word3" \;

# 6. REPLACE TEXT BRANDING
echo "Final replacement..."
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/me\.weishu\.kernelsu/$word1.$word2.$word3/g" \
    -e "s/me\/weishu\/kernelsu/$word1\/$word2\/$word3/g" \
    -e "s/me_weishu_kernelsu/${word1}_${word2}_${word3}/g" \
    -e "s/KernelSU/ZixineSu/g" \
    -e "s/MamboSU/ZixineSu/g" {} +

echo "--- Selesai ---"
