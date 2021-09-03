#!/usr/bin/env bash

RASPPIOS_IMAGE_URL="https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip"

### 
echo ".raspbery pi contained virtual machine."
echo ""
set -e

[[ ! -e .packages_ok ]] && {
    su - `apt update -y`
    su - `apt install unzip httpie`
    su - `rm -rf sdcard`
    su - `rm -rf image`

[[ ! -d  'sdcard' ]] && mkdir sdcard
[[ ! -d  'image' ]] && mkdir image

RASPIOS_ZIP=$(basename "$RASPPIOS_IMAGE_URL")
http -d "$RASPPIOS_IMAGE_URL" -o "images/$RASPIOS_ZIP"

unzip -d image/ "$RASPIOS_ZIP"
mv image/*.img image/raspios.img

touch "${RASPIOS_ZIP%.[^.]*}.info"
touch .packages_ok
}

case "$1" in

    buid-vm )
        vm="$2"
        echo "Buidling VM: $vm"
        ;;

    fresh-os )
        echo "FRESH OS DEPLOY - REMOVE /sdcard volume..."
        ;;
    
    clone2boot)
        repo="$2"
        echo "Clone repo to /boot partiton..."
        ;;

    run)
        vm="$2"
        echo "Run $vm"
        ;;

    stop)
        vm="$2"
        echo "Stop $vm"
        ;;

esac
