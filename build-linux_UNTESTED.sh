echo Compiling for Linux...
rm -rf export/release/linux/bin/assets/
rm -rf export/release/linux/bin/addons/
lime update linux
lime test linux -D_OFFICIAL_BUILD