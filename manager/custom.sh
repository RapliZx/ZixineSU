#!/bin/bash

# 1. IDENTITAS & LOGO ZIXINESU
word1="com"
word2="zixine"
word3="su"

# URL LOGO YANG SUDAH DIPERBAIKI (Link Raw Langsung)
LOGO_URL="https://raw.githubusercontent.com/zixine/ZixineSu/master/Branding/20260219_135939.png"

export word1 word2 word3

echo "--- Memulai Branding ZixineSu & Penggantian Logo ---"

# 2. PENGGANTIAN LOGO (ICON)
if [ ! -z "$LOGO_URL" ]; then
    echo "Mencoba mendownload logo dari: $LOGO_URL"
    curl -L -o new_logo.png "$LOGO_URL"
    
    # Cek apakah file benar-benar gambar PNG/JPEG
    if file new_logo.png | grep -qE 'image|bitmap|PNG|JPEG'; then
        echo "Gambar valid ditemukan. Mengganti semua ikon mipmap..."
        RES_PATH="app/src/main/res"
        
        # Hapus ikon XML bawaan (Adaptive Icons) agar ikon PNG kita yang diutamakan
        find $RES_PATH -name "ic_launcher.xml" -delete
        find $RES_PATH -name "ic_launcher_round.xml" -delete

        # Ganti semua ikon PNG di semua resolusi
        for dir in $RES_PATH/mipmap-*; do
            if [ -d "$dir" ]; then
                cp -f new_logo.png "$dir/ic_launcher.png"
                cp -f new_logo.png "$dir/ic_launcher_round.png"
                echo "Updated icons in $dir"
            fi
        done
    else
        echo "ERROR: File yang didownload bukan gambar (Mungkin link salah/404)!"
        echo "Pastikan link mengarah ke file mentah (raw)."
    fi
fi

# 3. PERBAIKAN ERROR STRING (Task: mergeReleaseResources)
echo "Fixing string positional markers..."
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%1$d/1' {} +
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%2$d/2' {} +

# 4. MEMBERSIHKAN SISA MAMBOSU
echo "Cleaning up MamboSU residues..."
find . -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.java" \) -exec sed -i 's/app_name_mambo/app_name/g' {} +

# 5. MENGUBAH STRUKTUR DIREKTORI (Package Name)
echo "Renaming folders to $word1/$word2/$word3..."
find . -depth -type d -name 'me' -execdir mv {} "$word1" \;
find . -depth -type d -name 'weishu' -execdir mv {} "$word2" \;
find . -depth -type d -name 'kernelsu' -execdir mv {} "$word3" \;

# 6. MENGGANTI TEXT DI SELURUH KODE
echo "Final text replacement..."
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/me\.weishu\.kernelsu/$word1.$word2.$word3/g" \
    -e "s/me\/weishu\/kernelsu/$word1\/$word2\/$word3/g" \
    -e "s/me_weishu_kernelsu/${word1}_${word2}_${word3}/g" \
    -e "s/KernelSU/ZixineSu/g" \
    -e "s/MamboSU/ZixineSu/g" {} +

echo "--- Selesai! ZixineSu siap di-build ---"
