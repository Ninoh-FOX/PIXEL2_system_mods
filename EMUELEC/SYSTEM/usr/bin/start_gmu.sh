#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

set_kill set "-HUP gmu.bin"

GMUPATH="/storage/.config/gmu"
GMUCONFIG="${GMUPATH}/gmu.conf"
GMUINPUT="${GMUPATH}/gmuinput.conf"

if [ ! -f "/storage/.configured" ]
then
if [ -d "/storage/.local/share/gmu" ]
then
  rm -rf /storage/.local/share/gmu
fi

FBHEIGHT="$(fbheight)"
FBWIDTH="$(fbwidth)"

if [ ! -d "${GMUPATH}" ]
then
  mkdir -p ${GMUPATH}
fi

cp -rf /usr/config/gmu/* ${GMUPATH}
ln -sf ${GMUPATH}/playlists /storage/.local/share/gmu

#sed -i "s~SDL.Height=.*\$~SDL.Height=${FBHEIGHT}~g" ${GMUCONFIG}
#sed -i "s~SDL.Width=.*\$~SDL.Width=${FBWIDTH}~g" ${GMUCONFIG}


if [ "${1}" ]
then
  PLAYLIST="-l \"${1}\""
fi

### Set up controls
for CONTROL in DEVICE_BTN_SOUTH DEVICE_BTN_EAST DEVICE_BTN_NORTH         \
               DEVICE_BTN_WEST DEVICE_BTN_TL DEVICE_BTN_TR               \
               DEVICE_BTN_TL2 DEVICE_BTN_TR2 DEVICE_BTN_SELECT           \
               DEVICE_BTN_START DEVICE_BTN_MODE DEVICE_BTN_THUMBL        \
               DEVICE_BTN_THUMBR DEVICE_BTN_DPAD_UP DEVICE_BTN_DPAD_DOWN \
               DEVICE_BTN_DPAD_LEFT DEVICE_BTN_DPAD_RIGHT
do
  sed -i "s~@${CONTROL}@~${!CONTROL}~g" ${GMUINPUT}
done
fi

FBHEIGHT="240"
FBWIDTH="320"

sed -i "s~SDL.Height=.*\$~SDL.Height=${FBHEIGHT}~g" ${GMUCONFIG}
sed -i "s~SDL.Width=.*\$~SDL.Width=${FBWIDTH}~g" ${GMUCONFIG}

cd /usr/local/share/gmu
/usr/local/bin/gmu.bin -d /usr/local/etc/gmu -c /storage/.config/gmu/gmu.conf ${PLAYLIST}
