#!/bin/bash
if [ ! -f "./bin/BeamMP-Launcher" ]; then
    echo "Please build BeamMP first"
    exit 1
fi

echo "Setting up"
cp ./bin/BeamMP-Launcher ./data
cd data
cp installer.sh ./BeamMP-Installer

# Check for libraries automagically
if command -v ldd > /dev/null; then
    echo "Adding checks for libraries"
    export LIBS="$(ldd ./BeamMP-Launcher | awk '{print $1}' | grep -v "linux-vdso.so" | grep -v "ld-linux")"
    export LIBREQUEST="export LIBREQUEST=\"\""
    while IFS= read -r LIB; do
        export LIBREQUEST="$LIBREQUEST\nif [ ! -n \"\$(ldconfig -p | grep \"$LIB\")\" ]; then\nexport LIBREQUEST=\"$LIB \$LIBREQUEST\"\nfi"
    done <<< "$LIBS"
    sed -i "s/SETUPLIBREQUEST/$LIBREQUEST/g" ./BeamMP-Installer
else
    echo "Skipping library checks due to lack of ldd (What system are you running?)"
    sed -i "s/SETUPLIBREQUEST/export LIBREQUEST=\"\"/g" ./BeamMP-Installer
fi

# Minify
echo "Cleaning up file"
# sed -i -e '/^\s*#.*$/d' -e '/^\s*$/d' ./BeamMP-Installer
sed -i '/^[[:blank:]]*#/d;s/#.*//' ./BeamMP-Installer # Remove comments
sed -i 's/^[[:space:]]*//g' ./BeamMP-Installer # Remove whitespace
sed -i '/^[[:blank:]]*$/d' ./BeamMP-Installer # Remove empty lines (ALWAYS USE \n!!)

# Add binaries
echo "Adding and linking files to script"
echo -e "\nexit" >> ./BeamMP-Installer
export LINES0="$(wc -l < ./BeamMP-Installer)"
export LINES1="$(wc -l < ./BeamMP-Launcher)"
sed -i "s/+FILELINELENGTH0/+$((LINES0+1))/g" ./BeamMP-Installer
sed -i "s/OUTFILELINELENGTH0/$((LINES1+1))/g" ./BeamMP-Installer
cat "./BeamMP-Launcher" >> ./BeamMP-Installer
echo >> ./BeamMP-Installer
export LINES0="$(wc -l < ./BeamMP-Installer)"
export LINES1="$(wc -l < ./BeamMP.ico)"
sed -i "s/+FILELINELENGTH1/+$((LINES0+1))/g" ./BeamMP-Installer
sed -i "s/OUTFILELINELENGTH1/$((LINES1+1))/g" ./BeamMP-Installer
cat "./BeamMP.ico" >> ./BeamMP-Installer
echo >> ./BeamMP-Installer
export LINES0="$(wc -l < ./BeamMP-Installer)"
export LINES1="$(wc -l < ./BeamMP.desktop)"
sed -i "s/+FILELINELENGTH2/+$((LINES0+1))/g" ./BeamMP-Installer
sed -i "s/OUTFILELINELENGTH2/$((LINES1+1))/g" ./BeamMP-Installer
cat "./BeamMP.desktop" >> ./BeamMP-Installer

# Finish up
echo "Finishing up"
chmod u+x ./BeamMP-Installer
mkdir ../bin &>/dev/null
mv ./BeamMP-Installer ../bin
