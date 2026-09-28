# 8086tiny: a tiny, highly functional, highly portable PC emulator/VM
# Copyright 2013-14, Adrian Cable (adrian.cable@gmail.com) - http://www.megalith.co.uk/8086tiny
#
# This work is licensed under the MIT License. See included LICENSE.TXT.

# 8086tiny builds with graphics and sound support
# 8086tiny_slowcpu improves graphics performance on slow platforms (e.g. Raspberry Pi)
# no_graphics compiles without SDL graphics/sound

OPTS_ALL=-O0 -g3 -fsigned-char -std=c99
SDK_SYSROOT ?= $(if $(SDKTARGETSYSROOT),$(SDKTARGETSYSROOT),/opt/calculinux-sdk/sysroots/cortexa7t2hf-neon-vfpv4-poky-linux-musleabi)
SDL_PKG_CONFIG = PKG_CONFIG_SYSROOT_DIR="$(SDK_SYSROOT)" PKG_CONFIG_LIBDIR="$(SDK_SYSROOT)/usr/lib/pkgconfig:$(SDK_SYSROOT)/usr/share/pkgconfig" PKG_CONFIG_PATH= pkg-config --cflags --libs sdl
OPTS_NOGFX=-DNO_GRAPHICS
OPTS_SLOWCPU=-DGRAPHICS_UPDATE_DELAY=25000
STRIP ?= strip

.PHONY: 8086tiny 8086tiny_slowcpu no_graphics clean force

8086tiny: build/8086tiny

# The checked-in binary may be stripped, so always rebuild it with debug info.
build/8086tiny: 8086tiny.c Makefile force
	set -e; sdl_flags="$$( $(SDL_PKG_CONFIG) )"; ${CC} 8086tiny.c $$sdl_flags ${OPTS_ALL} -o build/8086tiny

force:

8086tiny_slowcpu: 8086tiny.c
	set -e; sdl_flags="$$( $(SDL_PKG_CONFIG) )"; ${CC} 8086tiny.c $$sdl_flags ${OPTS_ALL} ${OPTS_SLOWCPU} -o build/8086tiny

no_graphics: 8086tiny.c
	${CC} 8086tiny.c ${OPTS_NOGFX} ${OPTS_ALL} -o build/8086tiny

clean:
	rm build/8086tiny
