#!/bin/bash

# 1. IDENTITAS & LOGO ZIXINESU
word1="com"
word2="zixine"
word3="su"

# MASUKKAN LINK LOGO KAMU DI SINI (Harus Direct Link ke .png)
LOGO_URL="https://raw.githubusercontent.com/zixine/ZixineSu/refs/heads/master/Branding/20260219_135939.png"

export word1 word2 word3

echo "--- Memulai Branding ZixineSu & Perbaikan Error ---"

# 2. PENGGANTIAN LOGO OTOMATIS
if [ ! -z "$LOGO_URL" ]; then
    echo "Downloading logo from: $LOGO_URL"
    curl -L -o new_logo.png "$LOGO_URL"
    
    # Cek apakah file benar-benar gambar agar build tidak error lagi
    if file new_logo.png | grep -qE 'image|bitmap'; then
        RES_PATH="app/src/main/res"
        for dir in $RES_PATH/mipmap-*; do
            if [ -d "$dir" ]; then
                cp -f new_logo.png "$dir/ic_launcher.png"
                cp -f new_logo.png "$dir/ic_launcher_round.png"
            fi
        done
        echo "Logo ZixineSu berhasil diterapkan."
    else
        echo "WARNING: File yang didownload bukan gambar! Melewati ganti logo."
    fi
fi

# 3. PERBAIKAN ERROR "Multiple substitutions" (Task: mergeReleaseResources)
# Mengubah %d %d menjadi %1$d %2$d di semua strings.xml [cite: 54, 75]
echo "Fixing string positional markers..."
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%1$d/1' {} +
find app/src/main/res -type f -name "strings.xml" -exec sed -i 's/%d/%2$d/2' {} +

# 4. MEMBERSIHKAN SISA MAMBOSU (Task: compileReleaseKotlin)
# Mengarahkan referensi 'app_name_mambo' yang hilang ke 'app_name' 
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

# 7. PERBAIKAN NAMA OUTPUT APK (Baris 13 di build-manager.yml)
if [ -f "./app/build.gradle.kts" ]; then
    sed -i 's/outputFileName = ".*.apk"/outputFileName = "ZixineSu_${managerVersionName}_${managerVersionCode}-\$name.apk"/' ./app/build.gradle.kts
fi

echo "--- Selesai! ZixineSu siap di-build ---"
