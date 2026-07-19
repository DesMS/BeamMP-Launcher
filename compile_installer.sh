#!/bin/bash
if [ ! -f "./bin/BeamMP-Launcher" ]; then
    echo "Please build BeamMP first"
    exit 1
fi

echo "Setting up"
cp ./bin/BeamMP-Launcher ./data
cd data
cp installer.sh ./BeamMP_Installer.sh

# Check for libraries automagically
if command -v ldd > /dev/null; then
    echo "Adding checks for libraries"
    LIBS="$(ldd ./BeamMP-Launcher | awk '{print $1}' | grep -v "linux-vdso.so" | grep -v "ld-linux")"
    LIBREQUEST="LIBREQUEST=\"\""
    while IFS= read -r LIB; do
        LIBREQUEST="$LIBREQUEST\nif [ ! -n \"\$(ldconfig -p | grep \"$LIB\")\" ]; then\nLIBREQUEST=\"$LIB \$LIBREQUEST\"\nfi"
    done <<< "$LIBS"
    sed -i "s/SETUPLIBREQUEST/$LIBREQUEST/g" ./BeamMP_Installer.sh
else
    echo "Skipping library checks due to lack of ldd (What system are you running???)"
    sed -i "s/SETUPLIBREQUEST/LIBREQUEST=\"\"/g" ./BeamMP_Installer.sh
fi

# Minify
echo "Cleaning up file"
sed -i '/^[[:blank:]]*#/d;s/#.*//' ./BeamMP_Installer.sh # Remove comments
sed -i 's/^[[:space:]]*//g' ./BeamMP_Installer.sh # Remove whitespace
sed -i '/^[[:blank:]]*$/d' ./BeamMP_Installer.sh # Remove empty lines (ALWAYS USE \n!!)

# Add binaries
echo "Adding and linking files to script"
echo -e "\nexit" >> ./BeamMP_Installer.sh
LINES0="$(wc -l < ./BeamMP_Installer.sh)"
LINES1="$(wc -l < ./BeamMP-Launcher)"
sed -i "s/+FILELINELENGTH0/+$((LINES0+1))/g" ./BeamMP_Installer.sh
sed -i "s/OUTFILELINELENGTH0/$((LINES1+1))/g" ./BeamMP_Installer.sh
cat "./BeamMP-Launcher" >> ./BeamMP_Installer.sh
echo >> ./BeamMP_Installer.sh
LINES0="$(wc -l < ./BeamMP_Installer.sh)"
LINES1="$(wc -l < ./BeamMP.ico)"
sed -i "s/+FILELINELENGTH1/+$((LINES0+1))/g" ./BeamMP_Installer.sh
sed -i "s/OUTFILELINELENGTH1/$((LINES1+1))/g" ./BeamMP_Installer.sh
cat "./BeamMP.ico" >> ./BeamMP_Installer.sh
echo >> ./BeamMP_Installer.sh
LINES0="$(wc -l < ./BeamMP_Installer.sh)"
LINES1="$(wc -l < ./BeamMP.desktop)"
sed -i "s/+FILELINELENGTH2/+$((LINES0+1))/g" ./BeamMP_Installer.sh
sed -i "s/OUTFILELINELENGTH2/$((LINES1+1))/g" ./BeamMP_Installer.sh
cat "./BeamMP.desktop" >> ./BeamMP_Installer.sh

# Finish up
echo "Finishing up"
chmod u+x ./BeamMP_Installer.sh
mkdir ../bin &>/dev/null
mv ./BeamMP_Installer.sh ../bin
