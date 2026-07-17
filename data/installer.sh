#!/bin/bash

if command -v whiptail &>/dev/null; then
    export WHIPTAILF=""
else
    export WHIPTAILF="true"
    clear
fi

if [ -n "$WHIPTAILF" ]; then
    while true; do
        echo -e "Please enter the number associated with what language you would like use during the installation:\n\n1. English\n"
        read -p "> " LANG
        case $LANG in
            "1") break;;
            * ) clear; echo "Please provide a valid answer."; echo "";;
        esac
    done
else
    export LANG=$(whiptail --title "BeamMP Installer" --nocancel --notags --menu "Select the language to use during the installation." 0 0 0 "1" "English" 3>&1 1>&2 2>&3)
fi

if [[ "$LANG" == "1" ]]; then
    export TITLE="BeamMP Installer"
    export CHECKING="Checking"
    export CONTINUEBUTTON="Continue"
    export ACCEPTBUTTON="Accept"
    export REJECTBUTTON="Reject"
    export YESBUTTON="Yes"
    export NOBUTTON="No"
    export CANCELBUTTON="Cancel"
    export MENU0="Please read the following License Agreement. You must accept the terms of this agreement before continuing with the installation.\n\nCopyright (C) 2026 BeamMP Ltd., BeamMP team and contributors.\nThis program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.\nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.\nYou should have received a copy of the GNU Affero General Public License along with this program. If not, see https://www.gnu.org/licenses/agpl-3.0.html."
    export REJECT0="Goodbye!"
    export MENU1="What additional tasks should be performed?"
    export OPTION11="Create a start menu shortcut"
    export OPTION12="Please choose a .desktop location for your start menu."
    export OPTION21="Create a desktop shortcut"
    export OPTION22="Please choose a .desktop location for your desktop."
    export OPTION31="Create a local bin link"
    export OPTION32="Please choose a bin location."
    export OPTION41="Where should BeamMP be installed?"
    export OPTION51="Run BeamMP Launcher"
    export MENU2="Unfortunately, your distribution is not supported\nWe can still install a binary.\nIf your system is based on gcc, then there is a 99% chance this package will work.\nHowever, we cannot guarantee it will work if you choose to install."
    export MENU3="Checking for packages"
    export MENU41="For security purposes, we cannot install packages for you.\nIt appears you do not have packages:\n\n"
    export MENU42="\n\nIf you would like to continue, please select continue.\nHowever, we cannot guarantee that BeamMP will work."
    export MENU5="Installing BeamMP"
    export MENU6="Successfully installed BeamMP! Setup is finished."
    export MENU7="Last chance, would you like to continue with the BeamMP installation?"
else
    echo "0x1 Unsupported Language"
    exit 1
fi

if [ -n "$WHIPTAILF" ]; then
    while true; do
        clear
        echo -e "$MENU0\n"
        read -p "[$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) break;;
            "${NOBUTTON,,}" ) clear; echo "$REJECT0"; exit 0;;
            * ) clear;;
        esac
    done
else
    whiptail --title "$TITLE" --defaultno --yes-button "$ACCEPTBUTTON" --no-button "$REJECTBUTTON" --yesno "$MENU0" 0 0
    if [[ "$?" == "1" ]]; then
        echo "$REJECT0"
        exit 0
    fi
fi

export STARTMENUSHORT=""
export DESKTOPSHORT=""
export BINSHORT=""
if [ -n "$WHIPTAILF" ]; then
    while true; do
        clear
        echo -e "$MENU1\n\n$OPTION11\n"
        read -p "[$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) clear; echo -e "$MENU1\n\n$OPTION12\n"; read -e -i "$HOME/.local/share/applications" -p "> " STARTMENUSHORT; break;;
            "${NOBUTTON,,}" ) break;;
            * ) echo;;
        esac
    done
    while true; do
        clear
        echo -e "$MENU1\n\n$OPTION21\n"
        read -p "[$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) clear; echo -e "$MENU1\n\n$OPTION22\n"; read -e -i "$HOME/Desktop" -p "> " STARTMENUSHORT; break;;
            "${NOBUTTON,,}" ) break;;
            * ) echo;;
        esac
    done
    while true; do
        clear
        echo -e "$MENU1\n\n$OPTION31\n"
        read -p "[$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) clear; echo -e "$MENU1\n\n$OPTION32\n"; read -e -i "$HOME/.local/bin" -p "> " STARTMENUSHORT; break;;
            "${NOBUTTON,,}" ) break;;
            * ) echo;;
        esac
    done
else
    eval EXTRAS=($(whiptail --nocancel --notags --title "$TITLE" --checklist "$MENU1" 0 0 0 "1" "$OPTION11" ON "2" "$OPTION21" OFF "3" "$OPTION31" ON 3>&1 1>&2 2>&3))
    for EXTRA in "${EXTRAS[@]}"; do
        if [[ "$EXTRA" == "1" ]]; then
            export STARTMENUSHORT=$(whiptail --nocancel --title "$TITLE" --inputbox "$OPTION12" 0 0 "$HOME/.local/share/applications" 3>&1 1>&2 2>&3)
        fi
        if [[ "$EXTRA" == "2" ]]; then
            export DESKTOPSHORT=$(whiptail --nocancel --title "$TITLE" --inputbox "$OPTION22" 0 0 "$HOME/Desktop" 3>&1 1>&2 2>&3)
        fi
        if [[ "$EXTRA" == "3" ]]; then
            export BINSHORT=$(whiptail --nocancel --title "$TITLE" --inputbox "$OPTION32" 0 0 "$HOME/.local/bin" 3>&1 1>&2 2>&3)
        fi
    done
fi

if [ -n "$WHIPTAILF" ]; then
    clear
    echo -e "\n\n$OPTION41\n"
    read -e -i "$HOME/.local/share/BeamMP" -p "> " INSTALLLOC
    while true; do
        clear
        echo -e "\n\n$MENU7\n"
        read -p "[$CONTINUEBUTTON/$CANCELBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${CONTINUEBUTTON,,}" ) break;;
            "${CANCELBUTTON,,}" ) break;;
            * ) echo;;
        esac
    done
else
    export INSTALLLOC=$(whiptail --nocancel --title "$TITLE" --inputbox "$OPTION41" 0 0 "$HOME/.local/share/BeamMP" 3>&1 1>&2 2>&3)

    whiptail --title "$TITLE" --yes-button "$CONTINUEBUTTON" --no-button "$CANCELBUTTON" --yesno "$MENU7" 0 0
    if [[ "$?" == "1" ]]; then
        echo "$REJECT0"
        exit 0
    fi
fi

export PACKAGEREQUEST=""
if command -v apt &>/dev/null; then
    # libc6, libgcc-s1, libstdc++6
    if [ -n "$WHIPTAILF" ]; then
        clear
        echo "$CHECKING \"libc6\"..."
        if [[ "$(dpkg-query -W --showformat='${Status}\n' "libc6" | grep "install ok installed")" == "" ]]; then
            export PACKAGEREQUEST="libc6 $PACKAGEREQUEST"
        fi
        clear
        echo "$CHECKING \"libgcc-s1\"..."
        if [[ "$(dpkg-query -W --showformat='${Status}\n' "libgcc-s1" | grep "install ok installed")" == "" ]]; then
            export PACKAGEREQUEST="libgcc-s1 $PACKAGEREQUEST"
        fi
        clear
        echo "$CHECKING \"libstdc++6\"..."
        if [[ "$(dpkg-query -W --showformat='${Status}\n' "libstdc++6" | grep "install ok installed")" == "" ]]; then
            export PACKAGEREQUEST="libstdc++6 $PACKAGEREQUEST"
        fi
    else
        {
            echo "0"
            if [[ "$(dpkg-query -W --showformat='${Status}\n' "libc6" | grep "install ok installed")" == "" ]]; then
                export PACKAGEREQUEST="libc6 $PACKAGEREQUEST"
            fi
            echo "33"
            if [[ "$(dpkg-query -W --showformat='${Status}\n' "libgcc-s1" | grep "install ok installed")" == "" ]]; then
                export PACKAGEREQUEST="libgcc-s1 $PACKAGEREQUEST"
            fi
            echo "66"
            if [[ "$(dpkg-query -W --showformat='${Status}\n' "libstdc++6" | grep "install ok installed")" == "" ]]; then
                export PACKAGEREQUEST="libstdc++6 $PACKAGEREQUEST"
            fi
            echo "100"
        } | whiptail --title "$TITLE" --gauge "$MENU3..." 0 0 0
    fi
elif command -v dnf &>/dev/null; then
    # glibc, libstdc++, libgcc
    if [ -n "$WHIPTAILF" ]; then
        clear
        echo "$CHECKING \"glibc\"..."
        if ! dnf list --installed "glibc" &>/dev/null; then
            export PACKAGEREQUEST="glibc $PACKAGEREQUEST"
        fi
        clear
        echo "$CHECKING \"libstdc++\"..."
        if ! dnf list --installed "libstdc++" &>/dev/null; then
            export PACKAGEREQUEST="libstdc++ $PACKAGEREQUEST"
        fi
        clear
        echo "$CHECKING \"libgcc\"..."
        if ! dnf list --installed "libgcc" &>/dev/null; then
            export PACKAGEREQUEST="libgcc $PACKAGEREQUEST"
        fi
    else
        {
            echo "0"
            if ! dnf list --installed "glibc" &>/dev/null; then
                export PACKAGEREQUEST="glibc $PACKAGEREQUEST"
            fi
            echo "33"
            if ! dnf list --installed "libstdc++" &>/dev/null; then
                export PACKAGEREQUEST="libstdc++ $PACKAGEREQUEST"
            fi
            echo "66"
            if ! dnf list --installed "libgcc" &>/dev/null; then
                export PACKAGEREQUEST="libgcc $PACKAGEREQUEST"
            fi
            echo "100"
        } | whiptail --title "$TITLE" --gauge "$MENU3..." 0 0 0
    fi
elif command -v pacman &>/dev/null; then
    if [ -n "$WHIPTAILF" ]; then
        clear
        echo "$CHECKING \"gcc-libs\"..."
        if ! pacman -Qs "gcc-libs" > /dev/null ; then
            export PACKAGEREQUEST="gcc-libs $PACKAGEREQUEST"
        fi
        clear
        echo "$CHECKING \"glibc\"..."
        if ! pacman -Qs "glibc" > /dev/null ; then
            export PACKAGEREQUEST="glibc $PACKAGEREQUEST"
        fi
    else
        {
            echo "0"
            if ! pacman -Qs "gcc-libs" > /dev/null ; then
                export PACKAGEREQUEST="gcc-libs $PACKAGEREQUEST"
            fi
            echo "50"
            if ! pacman -Qs "glibc" > /dev/null ; then
                export PACKAGEREQUEST="glibc $PACKAGEREQUEST"
            fi
            echo "100"
        } | whiptail --title "$TITLE" --gauge "$MENU3..." 0 0 0
    fi
else
    whiptail --title "$TITLE" --defaultno --yes-button "$CONTINUEBUTTON" --no-button "$CANCELBUTTON" --yesno "$MENU2" 0 0
    if [[ "$?" == "1" ]]; then
        echo "0x2 Unsupported Language"
        exit 2
    fi
fi

if [ -n "$PACKAGEREQUEST" ]; then
    if [ -n "$WHIPTAILF" ]; then
        clear
        echo -e "$MENU41 $PACKAGEREQUEST $MENU42\n"
        read -p "[$CONTINUEBUTTON/$CANCELBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${CONTINUEBUTTON,,}" ) break;;
            "${CANCELBUTTON,,}" ) clear; echo "$REJECT0"; exit 0;;
            * ) clear;;
        esac
    else
        whiptail --title "$TITLE" --defaultno --yes-button "$CONTINUEBUTTON" --no-button "$CANCELBUTTON" --yesno "$MENU41 $PACKAGEREQUEST $MENU42" 0 0
        if [[ "$?" == "1" ]]; then
            echo "$REJECT0"
            exit 0
        fi
    fi
fi

if [ -n "$WHIPTAILF" ]; then
    clear
    echo "$MENU5..."
    mkdir -p $INSTALLLOC &>/dev/null
    if [ ! -d "$INSTALLLOC" ]; then
        echo "0x5 Invalid Install Directory"
        exit 5
    fi
    rm -f $INSTALLLOC/BeamMP-Launcher &>/dev/null
    rm -f $INSTALLLOC/BeamMP.ico &>/dev/null
    touch $INSTALLLOC/BeamMP-Launcher
    tail +FILELINELENGTH0 "$0" | head -n OUTFILELINELENGTH0 > $INSTALLLOC/BeamMP-Launcher
    chmod +x $INSTALLLOC/BeamMP-Launcher &>/dev/null
    touch $INSTALLLOC/BeamMP.ico
    tail +FILELINELENGTH1 "$0" | head -n OUTFILELINELENGTH1 > $INSTALLLOC/BeamMP.ico
    chmod +x $INSTALLLOC/BeamMP.ico &>/dev/null
    touch $INSTALLLOC/BeamMP.desktop
    tail +FILELINELENGTH2 "$0" | head -n OUTFILELINELENGTH2 > $INSTALLLOC/BeamMP.desktop
    chmod +x $INSTALLLOC/BeamMP.desktop &>/dev/null
    sed -i "s/SETUPINSTALLLOCATION/$(echo "$INSTALLLOC" | sed "s/\\//\\\\\\//g")/g" $INSTALLLOC/BeamMP.desktop
    if [ -n "$BINSHORT" ]; then
        rm $BINSHORT/BeamMP-Launcher &>/dev/null
        ln -s $INSTALLLOC/BeamMP-Launcher $BINSHORT/BeamMP-Launcher
        chmod u+x $BINSHORT/BeamMP-Launcher
    fi
    if [ -n "$DESKTOPSHORT" ]; then
        rm $DESKTOPSHORT/BeamMP.desktop &>/dev/null
        ln -s $INSTALLLOC/BeamMP.desktop $DESKTOPSHORT/BeamMP.desktop
    fi
    if [ -n "$STARTMENUSHORT" ]; then
        rm $STARTMENUSHORT/BeamMP.desktop &>/dev/null
        ln -s $INSTALLLOC/BeamMP.desktop $STARTMENUSHORT/BeamMP.desktop
        if command -v update-desktop-database &>/dev/null; then
            update-desktop-database $STARTMENUSHORT
        fi
    fi
else
    {
        echo 0
        mkdir -p $INSTALLLOC &>/dev/null
        if [ ! -d "$INSTALLLOC" ]; then
            echo "0x5 Invalid Install Directory"
            exit 5
        fi
        rm -f $INSTALLLOC/BeamMP-Launcher &>/dev/null
        rm -f $INSTALLLOC/BeamMP.ico &>/dev/null
        echo 5
        touch $INSTALLLOC/BeamMP-Launcher
        tail +FILELINELENGTH0 "$0" | head -n OUTFILELINELENGTH0 > $INSTALLLOC/BeamMP-Launcher
        chmod +x $INSTALLLOC/BeamMP-Launcher &>/dev/null
        echo 35
        touch $INSTALLLOC/BeamMP.ico
        tail +FILELINELENGTH1 "$0" | head -n OUTFILELINELENGTH1 > $INSTALLLOC/BeamMP.ico
        chmod +x $INSTALLLOC/BeamMP.ico &>/dev/null
        echo 65
        touch $INSTALLLOC/BeamMP.desktop
        tail +FILELINELENGTH2 "$0" | head -n OUTFILELINELENGTH2 > $INSTALLLOC/BeamMP.desktop
        chmod +x $INSTALLLOC/BeamMP.desktop &>/dev/null
        sed -i "s/SETUPINSTALLLOCATION/$(echo "$INSTALLLOC" | sed "s/\\//\\\\\\//g")/g" $INSTALLLOC/BeamMP.desktop
        echo 95
        if [ -n "$BINSHORT" ]; then
            rm $BINSHORT/BeamMP-Launcher &>/dev/null
            ln -s $INSTALLLOC/BeamMP-Launcher $BINSHORT/BeamMP-Launcher
            chmod u+x $BINSHORT/BeamMP-Launcher
        fi
        if [ -n "$DESKTOPSHORT" ]; then
            rm $DESKTOPSHORT/BeamMP.desktop &>/dev/null
            ln -s $INSTALLLOC/BeamMP.desktop $DESKTOPSHORT/BeamMP.desktop
        fi
        if [ -n "$STARTMENUSHORT" ]; then
            rm $STARTMENUSHORT/BeamMP.desktop &>/dev/null
            ln -s $INSTALLLOC/BeamMP.desktop $STARTMENUSHORT/BeamMP.desktop
            if command -v update-desktop-database >/dev/null; then
                update-desktop-database $STARTMENUSHORT
            fi
        fi
        echo 100
    } | whiptail --title "$TITLE" --gauge "$MENU5..." 0 0 0
fi

if [ -n "$WHIPTAILF" ]; then
    while true; do
        clear
        echo -e "$MENU6\n"
        read -p "$OPTION51 [$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) cd $INSTALLLOC; "$INSTALLLOC/BeamMP-Launcher"; exit $?; break;;
            "${NOBUTTON,,}" ) echo "$REJECT0"; break;;
            * ) clear;;
        esac
    done
else
    eval DONES=($(whiptail --nocancel --notags --title "$TITLE" --checklist "$MENU6" 0 0 0 "1" "$OPTION51" ON 3>&1 1>&2 2>&3))
    for DONE in "${DONES[@]}"; do
        if [[ "$DONE" == "1" ]]; then
            cd $INSTALLLOC
            "$INSTALLLOC/BeamMP-Launcher"
            exit $?
        else
            echo "$REJECT0"
        fi
    done
fi