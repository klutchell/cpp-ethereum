#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for installing pre-requisite packages for cpp-ethereum on a
# variety of Linux and other UNIX-derived platforms.
#
# This is an "infrastucture-as-code" alternative to the manual build
# instructions pages which we previously maintained, first as Wiki pages
# and later as readthedocs pages at http://ethdocs.org.
#
# The aim of this script is to simplify things down to the following basic
# flow for all supported operating systems:
#
# - git clone --recursive
# - ./install_deps.sh
# - cmake && make
#
# At the time of writing we are assuming that 'lsb_release' is present for all
# Linux distros, which is not a valid assumption.  We will need a variety of
# approaches to actually get this working across all the distros which people
# are using.
#
# See http://unix.stackexchange.com/questions/92199/how-can-i-reliably-get-the-operating-systems-name
# for some more background on this common problem.
#
# TODO - There is no support here yet for cross-builds in any form, only
# native builds.  Expanding the functionality here to cover the mobile,
# wearable and SBC platforms covered by doublethink and EthEmbedded would
# also bring in support for Android, iOS, watchOS, tvOS, Tizen, Sailfish,
# Maemo, MeeGo and Yocto.
#
# The documentation for cpp-ethereum is hosted at http://cpp-ethereum.org
#
# ------------------------------------------------------------------------------
# This file is part of cpp-ethereum.
#
# cpp-ethereum is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# cpp-ethereum is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with cpp-ethereum.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 cpp-ethereum contributors.
#------------------------------------------------------------------------------

set -e

# Check for 'uname' and abort if it is not available.
uname -v > /dev/null 2>&1 || { echo >&2 "ERROR - cpp-ethereum requires 'uname' to identify the platform."; exit 1; }

case $(uname -s) in

#------------------------------------------------------------------------------
# macOS
#------------------------------------------------------------------------------

Darwin)
    case $(sw_vers -productVersion | awk -F . '{print $1"."$2}') in
        10.9)
            echo "Installing cpp-ethereum dependencies on OS X 10.9 Mavericks."
            ;;
        10.10)
            echo "Installing cpp-ethereum dependencies on OS X 10.10 Yosemite."
            ;;
        10.11)
            echo "Installing cpp-ethereum dependencies on OS X 10.11 El Capitan."
            ;;
        10.12)
            echo "Installing cpp-ethereum dependencies on macOS 10.12 Sierra."
            echo ""
            echo "NOTE - You are in unknown territory with this preview OS."
            echo "Even Homebrew doesn't have official support yet, and there are"
            echo "known issues (see https://github.com/ethereum/webthree-umbrella/issues/614)."
            echo "If you would like to partner with us to work through these issues, that"
            echo "would be fantastic.  Please just comment on that issue.  Thanks!"
            ;;
        *)
            echo "Unsupported macOS version."
            echo "We only support Mavericks, Yosemite and El Capitan, with work-in-progress on Sierra."
            exit 1
            ;;
    esac

    # Check for Homebrew install and abort if it is not installed.
    brew -v > /dev/null 2>&1 || { echo >&2 "ERROR - cpp-ethereum requires a Homebrew install.  See http://brew.sh."; exit 1; }

    # And finally install all the external dependencies.
    brew install \
        leveldb \
        libmicrohttpd \
        miniupnpc

    ;;

#------------------------------------------------------------------------------
# FreeBSD
#------------------------------------------------------------------------------
FreeBSD)
    echo "Installing cpp-ethereum dependencies on FreeBSD."
    echo "ERROR - 'install_deps.sh' doesn't have FreeBSD support yet."
    echo "Please let us know if you see this error message, and we can work out what is missing."
    echo "At https://gitter.im/ethereum/cpp-ethereum-development."
    exit 1
    ;;

#------------------------------------------------------------------------------
# Linux
#------------------------------------------------------------------------------
Linux)

    # Detect if sudo is needed.
    SUDO=""
    if [ $(id -u) != 0 ]; then
        SUDO="sudo"
    fi

#------------------------------------------------------------------------------
# Arch Linux
#------------------------------------------------------------------------------

    if [ -f "/etc/arch-release" ]; then

        echo "Installing cpp-ethereum dependencies on Arch Linux."

        # The majority of our dependencies can be found in the
        # Arch Linux official repositories.
        # See https://wiki.archlinux.org/index.php/Official_repositories
        $SUDO pacman -Sy --noconfirm \
            autoconf \
            automake \
            gcc \
            libtool \
            boost \
            leveldb \
            libmicrohttpd \
            miniupnpc

    elif [ -f "/etc/os-release" ]; then

        case $(source /etc/os-release; echo $NAME) in
        Debian*)
            echo "Installing cpp-ethereum dependencies on Debian Linux."

            $SUDO apt-get -q update
            $SUDO apt-get -qy install \
                build-essential \
                libboost-all-dev \
                libcurl4-openssl-dev \
                libgmp-dev \
                libleveldb-dev \
                libmicrohttpd-dev \
                libminiupnpc-dev
            ;;
        esac

    else

        case $(lsb_release -is) in

#------------------------------------------------------------------------------
# Alpine Linux
#------------------------------------------------------------------------------
        Alpine)
            #Alpine
            echo "Installing cpp-ethereum dependencies on Alpine Linux."
            echo "ERROR - 'install_deps.sh' doesn't have Alpine Linux support yet."
            echo "See http://cpp-ethereum.org/building-from-source/linux.html for manual instructions."
            echo "If you would like to get 'install_deps.sh' working for AlpineLinux, that would be fantastic."
            echo "Drop us a message at https://gitter.im/ethereum/cpp-ethereum-development."
            echo "See also https://github.com/ethereum/webthree-umbrella/issues/495 where we are working through Alpine support."
            exit 1
            ;;

#------------------------------------------------------------------------------
# Fedora
#------------------------------------------------------------------------------
        Fedora)
            #Fedora
            echo "Installing cpp-ethereum dependencies on Fedora."

            # Install "normal packages"
            # See https://fedoraproject.org/wiki/Package_management_system.
            dnf install \
                autoconf \
                automake \
                boost-devel \
                curl-devel \
                gcc \
                gcc-c++ \
                gmp-devel \
                leveldb-devel \
                libtool \
                miniupnpc-devel \
                snappy-devel
            ;;

#------------------------------------------------------------------------------
# OpenSUSE
#------------------------------------------------------------------------------
        openSUSE*)
            #openSUSE
            echo "Installing cpp-ethereum dependencies on openSUSE."
            echo "ERROR - 'install_deps.sh' doesn't have openSUSE support yet."
            echo "See http://cpp-ethereum.org/building-from-source/linux.html for manual instructions."
            echo "If you would like to get 'install_deps.sh' working for openSUSE, that would be fantastic."
            echo "See https://github.com/ethereum/webthree-umbrella/issues/552."
            exit 1
            ;;

#------------------------------------------------------------------------------
# Ubuntu
#
# TODO - I wonder whether all of the Ubuntu-variants need some special
# treatment?
#
# TODO - We should also test this code on Ubuntu Server, Ubuntu Snappy Core
# and Ubuntu Phone.
#
# TODO - Our Ubuntu build is only working for amd64 and i386 processors.
# It would be good to add armel, armhf and arm64.
# See https://github.com/ethereum/webthree-umbrella/issues/228.
#------------------------------------------------------------------------------
        Ubuntu|LinuxMint)
            #Ubuntu or LinuxMint
            case $(lsb_release -cs) in
                trusty|rosa|rafaela|rebecca|qiana)
                    #trusty or compatible LinuxMint distributions
                    echo "Installing cpp-ethereum dependencies on Ubuntu Trusty Tahr (14.04)."
                    echo "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main" \
                    | $SUDO tee -a /etc/apt/sources.list > /dev/null
                    ;;
                utopic)
                    #utopic
                    echo "Installing cpp-ethereum dependencies on Ubuntu Utopic Unicorn (14.10)."
                    ;;
                vivid)
                    #vivid
                    echo "Installing cpp-ethereum dependencies on Ubuntu Vivid Vervet (15.04)."
                    ;;
                wily)
                    #wily
                    echo "Installing cpp-ethereum dependencies on Ubuntu Wily Werewolf (15.10)."
                    ;;
                xenial|sarah)
                    #xenial
                    echo "Installing cpp-ethereum dependencies on Ubuntu Xenial Xerus (16.04)."
                    echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-3.9 main" \
                    | $SUDO tee -a /etc/apt/sources.list > /dev/null
                    ;;
                yakkety)
                    #yakkety
                    echo "Installing cpp-ethereum dependencies on Ubuntu Yakkety Yak (16.10)."
                    echo ""
                    echo "NOTE - You are in unknown territory with this preview OS."
                    echo "See https://github.com/ethereum/webthree-umbrella/issues/624."
                    echo "If you would like to partner with us to work through these, that"
                    echo "would be fantastic.  Please just comment on that issue.  Thanks!"
                    ;;
                *)
                    #other Ubuntu
                    echo "ERROR - Unknown or unsupported Ubuntu version."
                    echo "We only support Trusty, Utopic, Vivid, Wily and Xenial, with work-in-progress on Yakkety."
                    exit 1
                    ;;
            esac

            if [ TRAVIS ]; then
                # On Travis CI llvm package conficts with the new to be installed.
                $SUDO apt-get -y remove llvm
            fi
            $SUDO apt-get -q update
            $SUDO apt-get install -qy --no-install-recommends --allow-unauthenticated \
                build-essential \
                libboost-all-dev \
                libcurl4-openssl-dev \
                libgmp-dev \
                libleveldb-dev \
                libmicrohttpd-dev \
                libminiupnpc-dev \
                libz-dev \
                llvm-3.9-dev
            ;;

#------------------------------------------------------------------------------
# Other (unknown) Linux
# Major and medium distros which we are missing would include Mint, CentOS,
# RHEL, Raspbian, Cygwin, OpenWrt, gNewSense, Trisquel and SteamOS.
#------------------------------------------------------------------------------
        *)
            #other Linux
            echo "ERROR - Unsupported or unidentified Linux distro."
            echo "See http://cpp-ethereum.org/building-from-source/linux.html for manual instructions."
            echo "If you would like to get your distro working, that would be fantastic."
            echo "Drop us a message at https://gitter.im/ethereum/cpp-ethereum-development."
            exit 1
            ;;
        esac
    fi
    ;;

#------------------------------------------------------------------------------
# Other platform (not Linux, FreeBSD or macOS).
# Not sure what might end up here?
# Maybe OpenBSD, NetBSD, AIX, Solaris, HP-UX?
#------------------------------------------------------------------------------
*)
    #other
    echo "ERROR - Unsupported or unidentified operating system."
    echo "See http://cpp-ethereum.org/building-from-source/ for manual instructions."
    echo "If you would like to get your operating system working, that would be fantastic."
    echo "Drop us a message at https://gitter.im/ethereum/cpp-ethereum-development."
    ;;
esac
