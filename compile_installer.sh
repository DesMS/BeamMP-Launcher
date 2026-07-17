#!/bin/bash
cp ./bin/BeamMP-Launcher ./data
cd data
cp installer.sh ./BeamMP-Installer
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
chmod u+x ./BeamMP-Installer
mkdir ../bin &>/dev/null
mv ./BeamMP-Installer ../bin
