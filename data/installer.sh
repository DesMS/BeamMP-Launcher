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
    export MENU41="It appears you do not have libraries:\n\n"
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
            "${YESBUTTON,,}" ) clear; echo -e "$MENU1\n\n$OPTION22\n"; read -e -i "$HOME/Desktop" -p "> " DESKTOPSHORT; break;;
            "${NOBUTTON,,}" ) break;;
            * ) echo;;
        esac
    done
    while true; do
        clear
        echo -e "$MENU1\n\n$OPTION31\n"
        read -p "[$YESBUTTON/$NOBUTTON]> " RESPONSE
        case "${RESPONSE,,}" in
            "${YESBUTTON,,}" ) clear; echo -e "$MENU1\n\n$OPTION32\n"; read -e -i "$HOME/.local/bin" -p "> " BINSHORT; break;;
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

# libc.so.6, libgcc_s.so.1, libm.so.6, libstdc++.so.6, 

if command -v ldconfig > /dev/null; then
SETUPLIBREQUEST
    if [ -n "$LIBREQUEST" ]; then
        if [ -n "$WHIPTAILF" ]; then
            clear
            echo -e "$MENU41 $LIBREQUEST $MENU42\n"
            read -p "[$CONTINUEBUTTON/$CANCELBUTTON]> " RESPONSE
            case "${RESPONSE,,}" in
                "${CONTINUEBUTTON,,}" ) break;;
                "${CANCELBUTTON,,}" ) clear; echo "0x2 Potentially Unsupported"; exit 2;;
                * ) clear;;
            esac
        else
            whiptail --title "$TITLE" --defaultno --yes-button "$CONTINUEBUTTON" --no-button "$CANCELBUTTON" --yesno "$MENU41 $LIBREQUEST $MENU42" 0 0
            if [[ "$?" == "1" ]]; then
                echo "0x2 Potentially Unsupported"
                exit 2
            fi
        fi
    fi
else
    whiptail --title "$TITLE" --defaultno --yes-button "$CONTINUEBUTTON" --no-button "$CANCELBUTTON" --yesno "$MENU2" 0 0
    if [[ "$?" == "1" ]]; then
        echo "0x2 Potentially Unsupported"
        exit 2
    fi
fi

export ECHOCOMMAND="true"

DOECHO() {
    if [ -n "$ECHOCOMMAND" ]; then
        echo $@
    fi
}

DOLINK() {
    ln -s $1 $2 &>/dev/null
    if [[ ! -L "$2" || ! -e "$2" ]]; then
        rm $2 &>/dev/null
        rm -f $2 &>/dev/null
        cp $1 $2 # Backup incase symlinking is broken (Dependent on your filesystem type)
    fi
}

PERFORM_SETUP() {
    DOECHO 0
    mkdir -p $INSTALLLOC &>/dev/null
    if [ ! -d "$INSTALLLOC" ]; then
        echo "0x5 Invalid Install Directory"
        exit 5
    fi
    rm -f $INSTALLLOC/BeamMP-Launcher &>/dev/null
    rm -f $INSTALLLOC/BeamMP.ico &>/dev/null
    DOECHO 5
    touch $INSTALLLOC/BeamMP-Launcher
    cat "$0" | tail -n +FILELINELENGTH0 | head -n OUTFILELINELENGTH0 > $INSTALLLOC/BeamMP-Launcher
    chmod +x $INSTALLLOC/BeamMP-Launcher &>/dev/null
    DOECHO 35
    touch $INSTALLLOC/BeamMP.ico
    cat "$0" | tail -n +FILELINELENGTH1 | head -n OUTFILELINELENGTH1 > $INSTALLLOC/BeamMP.ico
    DOECHO 65
    touch $INSTALLLOC/BeamMP.desktop
    cat "$0" | tail -n +FILELINELENGTH2 | head -n OUTFILELINELENGTH2 > $INSTALLLOC/BeamMP.desktop
    sed -i "s/SETUPINSTALLLOCATION/$(echo "$INSTALLLOC" | sed "s/\\//\\\\\\//g")/g" $INSTALLLOC/BeamMP.desktop
    DOECHO 95
    if [ -n "$BINSHORT" ]; then
        rm $BINSHORT/BeamMP-Launcher &>/dev/null
        DOLINK $INSTALLLOC/BeamMP-Launcher $BINSHORT/BeamMP-Launcher
        chmod +x $BINSHORT/BeamMP-Launcher
    fi
    if [ -n "$DESKTOPSHORT" ]; then
        rm $DESKTOPSHORT/BeamMP.desktop &>/dev/null
        cp $INSTALLLOC/BeamMP.desktop $DESKTOPSHORT/BeamMP.desktop # Common practice to cp, not link
    fi
    if [ -n "$STARTMENUSHORT" ]; then
        rm $STARTMENUSHORT/BeamMP.desktop &>/dev/null
        DOLINK $INSTALLLOC/BeamMP.desktop $STARTMENUSHORT/BeamMP.desktop
        if command -v update-desktop-database >/dev/null; then
            update-desktop-database $STARTMENUSHORT
        fi
    fi
    DOECHO 100
}

if [ -n "$WHIPTAILF" ]; then
    clear
    echo "$MENU5..."
    export echocommand=""
    PERFORM_SETUP
    echo "Finished installing BeamMP"
else
    {
        PERFORM_SETUP
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
