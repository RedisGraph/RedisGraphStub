#!/bin/bash

# This script adds the file ./bin/rediscompat.so to the zip file with the pattern rediscompt-<Linux|macos>-<osnick>-<arch>.version.zip
version=1.0.0
# Get OS name and architecture
os=$(uname -s)
arch=$(uname -m)


# Get OS nick name
if [[ $os = 'Darwin' ]]
then
    os='macos'
    OS_NICK=$(sw_vers -productVersion)
    OS_NICK=${OS_NICK//./_}
else
    VERSION=$(grep '^VERSION_ID' /etc/os-release | sed 's/"//g')
    VERSION=${VERSION#"VERSION_ID="}
    OS_NAME=$(grep '^NAME' /etc/os-release | sed 's/"//g')
    OS_NAME=${OS_NAME#"NAME="}
    OS_NICK=${OS_NAME,,}${VERSION}
    OS_NICK=${OS_NICK// /'_'}
fi
echo $OS_NICK


declare -A archs=(
    ["x86_64"]="x86_64"
    ["aarch64"]="arm64v8"
    ["arm64v8"]="arm64v8"
)

declare -A OSNICKS=(
    ["rocky8"]="rhel8"
    ["centos7"]="rhel7"
    ["ubuntu18.04"]="ubuntu18.04"
    ["ubuntu20.04"]="ubuntu20.04"
    ["ubuntu22.04"]="ubuntu22.04"
    ["amazonlinux2"]="amzn2"
)

# Get OS nick name
OS_NICK=${OSNICKS[$OS_NICK]}
echo $OS_NICK

# Get architecture
arch=${archs[$arch]}
echo $arch

# Call zip and create the zip file
zip -j ./bin/rediscompat-${os}-${OS_NICK}-${arch}.${version}.zip ./bin/rediscompat.so
rm ./bin/rediscompat.so
