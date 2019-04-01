# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="hyperion.ng"
PKG_VERSION="714b4d2c547f2c6aea5124fab8c4e3539f9cf081"
PKG_SHA256="58d4191f24a9b92f99bf16efc01c5210727aff550b924887aed880a020a81525"
PKG_REV="100.2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Portisch/hyperion.ng"
PKG_URL="https://github.com/Portisch/hyperion.ng/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python3 avahi libusb qt-everywhere protobuf flatbuffers:target"
PKG_SECTION="service"
PKG_SHORTDESC="Hyperion.NG: an AmbiLight controller"
PKG_LONGDESC="Hyperion.NG($PKG_VERSION) is an modern opensource AmbiLight implementation."

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="Hyperion.NG"
PKG_ADDON_TYPE="xbmc.service"

# Setting default values
PKG_PLATFORM="-DPLATFORM=x86"
PKG_AMLOGIC_SUPPORT="-DENABLE_AMLOGIC=0"
PKG_V4L2_SUPPORT="-DENABLE_V4L2=1"
PKG_DISPMANX_SUPPORT="-DENABLE_DISPMANX=0"
PKG_FB_SUPPORT="-DENABLE_FB=1"
PKG_X11_SUPPORT="-DENABLE_X11=0"
PKG_DENABLE_WS281XPWM="-DENABLE_WS281XPWM=0"

if [ "$KODIPLAYER_DRIVER" = "libamcodec" ]; then
  PKG_PLATFORM="-DPLATFORM=amlogic"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libamcodec"
  PKG_AMLOGIC_SUPPORT="-DENABLE_AMLOGIC=1"
  PKG_V4L2_SUPPORT="-DENABLE_V4L2=0"
elif [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_PLATFORM="-DPLATFORM=rpi"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver rpi_ws281x"
  PKG_DISPMANX_SUPPORT="-DENABLE_DISPMANX=1"
  PKG_FB_SUPPORT="-DENABLE_FB=0"
  PKG_DENABLE_WS281XPWM="-DENABLE_WS281XPWM=1"
elif [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET xorg-server xrandr"
  PKG_X11_SUPPORT="-DENABLE_X11=1"
fi

pre_configure_target() {
  echo "" > ../cmake/FindGitVersion.cmake
}

PKG_CMAKE_OPTS_TARGET="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
                       -DCMAKE_BUILD_TYPE=Release\
                       -DUSE_SHARED_AVAHI_LIBS=ON\
                       -DUSE_SYSTEM_PROTO_LIBS=1 \
                       -DUSE_SYSTEM_FLATBUFFERS_LIBS=ON\
                       $PKG_PLATFORM \
                       $PKG_AMLOGIC_SUPPORT \
                       $PKG_DISPMANX_SUPPORT \
                       $PKG_FB_SUPPORT \
                       $PKG_DENABLE_WS281XPWM \
                       $PKG_X11_SUPPORT \
                       $PKG_V4L2_SUPPORT \
                       -DENABLE_OSX=0 \
                       -DENABLE_SPIDEV=1 \
                       -DENABLE_TINKERFORGE=0 \
                       -DENABLE_QT5=1 \
                       -DENABLE_TESTS=0 \
                       -Wno-dev"

makeinstall_target() {
  : # nothing to do here
}

addon() {
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp $PKG_BUILD/.$TARGET_NAME/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $PKG_BUILD/assets/webconfig $ADDON_BUILD/$PKG_ADDON_ID
  cp -PR $PKG_BUILD/effects $ADDON_BUILD/$PKG_ADDON_ID
}
