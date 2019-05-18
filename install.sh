#!/bin/bash
# Copyright (C) 2018, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

BIN_FOLDER="/usr/local/bin"

uninstaller_bin()
{
    echo " - Remove binaries"
    # Remove the service from /etc/init.d
    if [ -f "/etc/systemd/system/jetson_performance.service" ] ; then
        # Uninstall the service
        if [ $(systemctl is-active jetson_performance.service) = "active" ] ; then
            tput setaf 1
            echo "   * Stop and jetson_performance service"
            tput sgr0
            # Stop the service
            sudo systemctl stop jetson_performance.service
        fi
        # Disable the service
        sudo systemctl disable jetson_performance.service
        echo "   * Remove the service from /etc/systemd/system"
        sudo rm "/etc/systemd/system/jetson_performance.service"
    fi
    # Update service list
    sudo systemctl daemon-reload

    # Remove jetson_release link
    if [ -f "$BIN_FOLDER/jtop" ] ; then
        echo "   * Remove jtop link"
        sudo rm "$BIN_FOLDER/jtop"
    fi
    # Remove from bashrc jetsonstat variables
    if [ -f "/etc/profile.d/jetson_env.sh" ] ; then
        echo "   * Remove the jetson_env.sh from /etc/profile.d/"
        sudo rm "/etc/profile.d/jetson_env.sh"
    fi
    
    # Remove jetson_release link
    if [ -f "$BIN_FOLDER/jetson_release" ] ; then
        echo "   * Remove jetson_release link"
        sudo rm "$BIN_FOLDER/jetson_release"
    fi

    # Remove jetson_swap link
    if [ -f "$BIN_FOLDER/jetson_swap" ] ; then
        echo "   * Remove jetson_swap link"
        sudo rm "$BIN_FOLDER/jetson_swap"
    fi

    # Remove jetson-docker link
    if [ -f "$BIN_FOLDER/jetson-docker" ] ; then
        echo "   * Remove jetson-docker link"
        sudo rm "$BIN_FOLDER/jetson-docker"
    fi
}

uninstaller()
{
    local JETSON_FOLDER=$1
    
    echo " - Uninstall jetson_stats on $JETSON_FOLDER"
    # Remove configuration
    if [ -f $JETSON_FOLDER/l4t_dfs.conf ] ; then
        echo "   * Remove the jetson_clock.sh configuration"
        sudo rm $JETSON_FOLDER/l4t_dfs.conf
    fi

    # Remove jetson_easy folder
    if [ -d "$JETSON_FOLDER" ] ; then
        # remove folder
        echo "   * Remove jetson_easy folder"
        sudo rm -r $JETSON_FOLDER
    fi
    
}

installer()
{
    local JETSON_FOLDER=$1
    local FORCE_INSTALL=$2
    
    # Launch installer pip
    if $FORCE_INSTALL ; then
        sudo -H pip install . --upgrade
    else
        sudo -H pip install .
    fi
    
    # Update service list
    sudo systemctl daemon-reload
}

usage()
{
	if [ "$1" != "" ]; then
    	tput setaf 1
		echo "$1"
		tput sgr0
	fi
	
    echo "Jetson_stats, Installer for nvidia top and different information modules."
    echo "Usage:"
    echo "$0 [options]"
    echo "options,"
    echo "   -h|--help    | This help"
    echo "   -s|--silent  | Run jetson_stats in silent mode"
    echo "   -i|--inst    | Change default install folder"
    echo "   -f|--force   | Force install all tools"
    echo "   -auto        | Run at start-up jetson performance"
    echo "   -uninstall   | Run the uninstaller"
}

main()
{
    local SKIP_ASK=true
    local AUTO_START=false
    local FORCE_INSTALL=false
    local START_UNINSTALL=false
    local JETSON_FOLDER="/opt/jetson_stats"
    
	# Decode all information from startup
    while [ -n "$1" ]; do
        case "$1" in
            -i|--inst)
                JETSON_FOLDER=$2
                shift 1
                ;;
            -s|--silent)
                SKIP_ASK=false
                ;;
            -f|--force)
                FORCE_INSTALL=true
                ;;
            -auto)
                AUTO_START=true
                ;;
            -uninstall)
                START_UNINSTALL=true
                ;;
            -h|--help)
                # Load help
                usage
                exit 0
                ;;
            *)
                usage "[ERROR] Unknown option: $1"
                exit 1
            ;;
        esac
            shift 1
    done
    
    if [[ `id -u` -ne 0 ]] ; then 
        tput setaf 1
        echo "Please run as root"
        tput sgr0
        exit 1
    fi
	
	local install_uninstall_string="install"
	if $START_UNINSTALL ; then
        install_uninstall_string="uninstall"
    fi
	
    while $SKIP_ASK; do
        read -p "Do you wish to $install_uninstall_string jetson_stats? [Y/n] " yn
            case $yn in
                [Yy]* ) # Break and install jetson_stats 
                        break;;
                [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
    
    if $START_UNINSTALL ; then
        # Run uninstaller binaries
        uninstaller_bin
        # Remove configuration standard
        uninstaller $JETSON_FOLDER
        # remove old configurations
        if [ -d /etc/jetson_easy ] ; then
            uninstaller /etc/jetson_easy
        fi
    else
        # Run installer
        installer $JETSON_FOLDER $FORCE_INSTALL
        
        if $AUTO_START ; then
            tput setaf 4
            echo " - Enable and start jetson_performance"
            tput sgr0
            # Enable service
            sudo systemctl enable jetson_performance.service
            # Run the service
            sudo systemctl start jetson_performance.service
        fi
    fi
    
    tput setaf 2
    echo "DONE!"
    tput sgr0
}

main $@
exit 0

#EOF
