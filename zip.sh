#!/bin/bash

# This script adds the file ./bin/rediscompat.so to the zip file with the pattern rediscompt-<Linux|macos>-<osnick>-<arch>.version.zip
version=1.0.0
# Get OS name and architecture
os=$(uname -s)
arch=$(uname -m)
echo $os
echo $arch


# Get OS nick name
if [[ $os = 'Darwin' ]]
then
    os='macos'
    OS_NICK=$(sw_vers -productVersion)
    # get major version
    OS_NICK=${OS_NICK%%.*}
else
    VERSION=$(grep '^VERSION_ID' /etc/os-release | sed 's/"//g')
    VERSION=${VERSION#"VERSION_ID="}
    OS_NAME=$(grep '^NAME' /etc/os-release | sed 's/"//g')
    OS_NAME=${OS_NAME#"NAME="}
    OS_NICK=${OS_NAME,,}${VERSION}
    OS_NICK=${OS_NICK// /'_'}
fi
echo $OS_NICK

# Get OS nick name
if [[ $os = 'macos' ]]
then
# Since macos uses bash v3, we cannot use associative arrays
    case $OS_NICK in
        12)
            OS_NICK="monterey"
            ;;
        13)
            OS_NICK="ventura"
            ;;
        *)
            echo "Unknown MacOS version $OS_NICK"
            exit 1
            ;;
    esac
    case $arch in
        x86_64)
            arch="x86_64"
            ;;
        aarch64)
            arch="arm64v8"
            ;;
        *)
            echo "Unknown MacOS architecture $arch"
            exit 1
            ;;
    esac
else
    declare -A LINUX_OSNICKS=(
        ["rocky_linux8.8"]="rhel8"
        ["centos_linux7"]="rhel7"
        ["ubuntu18.04"]="ubuntu18.04"
        ["ubuntu20.04"]="ubuntu20.04"
        ["ubuntu22.04"]="ubuntu22.04"
        ["amazon_linux2"]="amzn2"
        ["debian_gnu/linux11"]="bullseye"
    )
    OS_NICK=${LINUX_OSNICKS[$OS_NICK]}
fi
echo $OS_NICK
echo $arch

# Call zip and create the zip file
echo "Creating zip file ./bin/rediscompat-${os}-${OS_NICK}-${arch}.${version}.zip"
zip -j ./bin/rediscompat-${os}-${OS_NICK}-${arch}.${version}.zip ./bin/rediscompat.so
rm ./bin/rediscompat.so
