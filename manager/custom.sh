#!/bin/bash

# 1. IDENTITAS BRANDING
OLD_PKG="me\.weishu\.kernelsu" 
NEW_PKG="com.zixine.su"
OLD_JNI="me_weishu_kernelsu"   
NEW_JNI="com_zixine_su"        
OLD_NAME="KernelSU"
NEW_NAME="ZixineSu"

# URL LOGO
LOGO_URL="https://raw.githubusercontent.com/zixine/ZixineSu/master/Branding/20260219_135939.png"

echo "--- [ZIXINESU] Memulai Proses Branding ---"

# 2. DOWNLOAD & REPLACE LOGO
if [ ! -z "$LOGO_URL" ]; then
    echo "Downloading Branding Assets..."
    curl -L -o zixine_logo.png "$LOGO_URL"
    
    if file zixine_logo.png | grep -qE 'image|PNG|JPEG'; then
        RES_PATH="app/src/main/res"
        
        # JANGAN hapus ic_launcher_foreground.xml karena di-referensi oleh kode Kotlin.
        # Kita hanya menimpa file PNG-nya saja di semua resolusi.
        for folder in $(find $RES_PATH -type d -name "mipmap-*" -o -name "drawable-*"); do
            cp -f zixine_logo.png "$folder/ic_launcher.png"
            cp -f zixine_logo.png "$folder/ic_launcher_round.png"
            [ -f "$folder/logo.png" ] && cp -f zixine_logo.png "$folder/logo.png"
            # Pastikan foreground juga ada dalam bentuk PNG agar tidak error
            cp -f zixine_logo.png "$folder/ic_launcher_foreground.png" 2>/dev/null || true
            echo "Menimpa aset di: $folder"
        done
    fi
fi

# 3. FIX STRING POSITIONALS (Perbaikan error require_kernel_version)
# Kita mengubah %d menjadi %1$d secara otomatis di semua strings.xml
echo "Fixing string formats..."
find app/src/main/res -name "strings.xml" -exec sed -i 's/%d/%1$d/g' {} +
# Jika ada dua %d dalam satu baris, baris di atas mungkin butuh penyesuaian manual, 
# tapi untuk require_kernel_version ini biasanya sudah cukup.

# 4. FIX RESIDU
find . -type f \( -name "*.kt" -o -name "*.xml" -o -name "*.java" \) -exec sed -i 's/app_name_mambo/app_name/g' {} +

# 5. RENAME & MOVE DIRECTORY (Sesuai perbaikan sebelumnya)
echo "Memindahkan struktur direktori..."
mkdir -p app/src/main/java/com/zixine/su
cp -r app/src/main/java/me/weishu/kernelsu/* app/src/main/java/com/zixine/su/ 2>/dev/null || true
rm -rf app/src/main/java/me

mkdir -p app/src/main/aidl/com/zixine/su
cp -r app/src/main/aidl/me/weishu/kernelsu/* app/src/main/aidl/com/zixine/su/ 2>/dev/null || true
rm -rf app/src/main/aidl/me

# 6. GLOBAL TEXT REPLACEMENT
echo "Replacing strings: $OLD_NAME -> $NEW_NAME"
find . -type f -not -path '*/.git/*' -exec sed -i \
    -e "s/$OLD_PKG/$NEW_PKG/g" \
    -e "s/me\/weishu\/kernelsu/com\/zixine\/su/g" \
    -e "s/$OLD_JNI/$NEW_JNI/g" \
    -e "s/KernelSU/$NEW_NAME/g" \
    -e "s/MamboSU/$NEW_NAME/g" {} +

echo "--- [ZIXINESU] Branding Selesai! ---"
