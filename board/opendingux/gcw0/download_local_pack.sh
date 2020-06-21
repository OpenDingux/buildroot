#!/usr/bin/env bash

set -euo pipefail

decode_uri_filename() {
  while read; do
    echo -e "${REPLY//%/\\x}"
  done
}

dl() {
  local -r url="$1"
  local filename
  if [[ $# -eq 2 ]]; then
    filename="$2"
  else
    filename="$(basename "$url" | decode_uri_filename)"
  fi

  local -a curl_args=(-L --fail --remote-time -o "$filename" -#)
  if [[ -f "$filename" ]]; then
    # Only re-download if the remote file is newer than the local one
    curl_args+=(-z "$filename")
  fi
  set -x
  curl "${curl_args[@]}" "$url"
  { set +x; } 2>/dev/null
}

declare -r RGH_OD_REPO="https://raw.githubusercontent.com/retrogamehandheld/OpenDingux/master"
declare -r SEONG_RG350_REPO="https://raw.githubusercontent.com/SeongGino/RetroGame350-AppRepo/master"

mkdir -p dl/od_local_pack/
cd dl/od_local_pack/

# Most sources come from a list maintained here:
# https://github.com/SeongGino/RetroGame350-AppRepo

## Applications

# ODcalc | Calculator
dl https://github.com/Jakz/open-dingux-calculator/releases/latest/download/odcalc.opk

# FFPlay | Video player
dl "${RGH_OD_REPO}/Applications/FFPlay.opk"

# Oldplay | Music player
dl "${RGH_OD_REPO}/Applications/Oldplay.opk"

# Bard | E-book reader
dl "${RGH_OD_REPO}/Applications/Bard.opk"

# Glutexto | Text editor
dl "${RGH_OD_REPO}/Applications/Glutexto.opk"

# GMU
dl "${SEONG_RG350_REPO}/Applications/gmu-0.10.1-gcw0.opk"

# ST-SDL | Terminal
dl https://github.com/glebm/rs97_st-sdl/releases/latest/download/st-rg350.opk

# HWTest | Input tester
dl "${RGH_OD_REPO}/Applications/HWTest.opk"

# Built as part of the buildroot:
# * DinguxCommander

## Emulators
# Some renamed after download to default names used by SimpleMenu:
# https://github.com/fgl82/simplemenu/blob/8102ffd50615837837f0a5f97d7fc32758689e01/simplemenu/configs/RG-350/config/sections.cfg

# gambatte
dl https://github.com/bardeci/dot-matrix-simulator/releases/download/20200127/gambatte-multi-r572u4-20200127.opk \
  gambatte-gcw0-r572u3-20190718-004431.opk

# fceux
dl "${SEONG_RG350_REPO}/Emulators/FCEUX_2019-11-15.opk" \
  fceux.opk

# nestopia
dl https://rs97.bitgala.xyz/RG-350/localpack/extra_apps/nestopia-28b16e5.opk

# PocketSNES
dl "${SEONG_RG350_REPO}/Emulators/PocketSNES_2019-12-12.opk" \
  PocketSNES.opk

# SMS Plus GX
dl https://gameblabla.nl/files/ipk/gcw0/smsplus_gcw0.opk

# Picodrive
rm -f picodrive.opk
dl https://gameblabla.nl/files/ipk/gcw0/picodrive_gcw0.opk \
  picodrive.opk

# Genesis Plus GX
dl "${SEONG_RG350_REPO}/Emulators/GenesisPlusGX_2019-12-23.opk" \
  GenplusGX.opk

# ReGBA
dl "${SEONG_RG350_REPO}/Emulators/ReGBA_2019-12-26.opk" \
  Regba.opk

# Temper | NEC PC-Engine/TurboGrafx-16, CD System
dl https://gameblabla.nl/files/ipk/gcw0/temper_rs97_gcw0.opk \
  temper1.24.opk

# SmallPCFX | NEC PC-FX
# TODO: https://github.com/gameblabla/pcfx-mednafen/

# Snes9x
rm -f Snes9x_*.opk
dl "${SEONG_RG350_REPO}/Emulators/Snes9x_2019-11-11.opk"

# SwanEmu | Bandai Wonderswan (B/W, Color)
dl https://gameblabla.nl/files/ipk/gcw0/swanemu_gcw0.opk

# NEO4All | SNK Neo-Geo CD
rm -f NEO4All*.opk
dl "${SEONG_RG350_REPO}/Emulators/NEO4All_2019-12-16.opk"

# NGPCEmu | SNK Neo-Geo Pocket (B/W, Color)
dl https://gameblabla.nl/files/ipk/gcw0/ngpcemu_gcw0.opk

# Retro8
dl https://github.com/Jakz/retro8/releases/download/0.1b/retro8_v1b_20200108.opk

# ScummVM
dl https://github.com/craigsc/scummvm-rg350/releases/download/v0.2/scummvm-rg350-01132020.opk

# DOSBox
dl "${SEONG_RG350_REPO}/Emulators/DOSBox_2019-11-11-launcher.opk"

# midpath | J2ME emulator
dl https://rs97.bitgala.xyz/RG-350/localpack/extra_apps/midpath_20170502_GCW0.opk

# Built as part of the buildroot:
# * pcsx4all

## Ports (require additional data)

# PRBoom+ | Doom
dl 'https://github.com/Ninoh-FOX/PrBoom-plus-for-RG350/releases/latest/download/prboom+.opk'

# EDuke32 | Duke Nukem 3D
dl "${RGH_OD_REPO}/Games%20%26%20Ports/EDuke32.opk"

# DevilutionX | Diablo
dl https://github.com/diasurgical/devilutionX/releases/latest/download/devilutionx-rg350.opk

## Games

# Arkanoid
dl "${RGH_OD_REPO}/Games%20%26%20Ports/Arkanoid.opk"

# Blockrage
dl "${RGH_OD_REPO}/Games%20%26%20Ports/Blockrage.opk"

# Mr. Drillux
dl https://github.com/jbanes/rs97-mrdrillux/releases/latest/download/mrdrillux.opk

# Cave Story
dl "${RGH_OD_REPO}/Games%20%26%20Ports/NXEngine.opk"

# Slitherlink
dl https://github.com/glebm/od-slitherlink/releases/latest/download/slitherlink-rg350.opk

# Built as part of the buildroot
# * BlockAttack
# * Hocoslamfly
# * Ghouls'n Ghosts Remix

cd -
