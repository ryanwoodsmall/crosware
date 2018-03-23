# crosware
Tools, things, stuff, miscellaneous, detritus, junk, etc., for Chrome OS / Chromium OS. Eventually this will be a development-ish environment for Chrome OS on both ARM and x86 (32-bit and 64-bit for both). It should work (eventually) on "normal" Linux too.

Ultimately I'd like this to be a self-hosting virtual distribution of sorts, targeting all variations of 32-/64-bit x86 and ARM on Chrome OS. Leaning towards distributing a static-only build system using musl-libc (with musl-cross-make); this precludes things like emacs, but doesn't stop anyone from using a musl toolchain to build a glibc-based shared toolchain. Planning on starting out with shell script-based recipes for configuring/compiling/installing versioned "packages." Initial bootstrap will look something like:

- get a JDK (Azul Zulu OpenJDK)
- get jgit.sh (standalone)
- get static bootstrapped compiler
- checkout rest of project
- build GNU make (v3, no perl)
- build native busybox (if I don't distribute one)
- build a few libs / support (ncurses, openssl, slang, zlib, bzip2, lzma, libevent, pkg-config)
- build a few packages (curl, vim w/syntax hightlighting, screen, tmux, links, lynx - mostly because I use them)

Environment stuff to figure out how to handle:

- ```PATH``` (working)
- ```PKG_CONFIG_LIBDIR/PKG_CONFIG_PATH``` (working)
- ```CC``` (working)
- ```CFLAGS``` (working)
- ```CPP``` (working)
- ```CPPFLAGS``` (working)
- ```CXX``` (working)
- ```LDFLAGS``` (working)
- ```MANPATH```
- ```ACLOCAL_PATH```

This is currently just some notes, not-even-half-lazy scripts, and a config file or two.

Chromebrew looks nice and exists now: (https://github.com/skycocker/chromebrew)

Alpine and Sabotage are good sources of inspiration and patches:

- Alpine: https://alpinelinux.org/ and git: https://git.alpinelinux.org/
- Sabotage: http://sabotage.tech/ and git: https://github.com/sabotage-linux/sabotage/

The Alpine folks distribute a chroot installer (untested):

- https://github.com/alpinelinux/alpine-chroot-install

And I wrote a little quick/dirty Alpine chroot creator that works on Chrome/Chromium OS; no Docker or other software necessary.

- https://github.com/ryanwoodsmall/shell-ish/blob/master/bin/chralpine.sh

And the musl wiki has some pointers on patches and compatibility:

- https://wiki.musl-libc.org/compatibility.html#Software-compatibility,-patches-and-build-instructions

Mes might be useful at some point.

- https://gitlab.com/janneke/mes
- https://lists.gnu.org/archive/html/guile-user/2016-06/msg00061.html
- https://lists.gnu.org/archive/html/guile-user/2017-07/msg00089.html

Regarding compilers, the GCC 4.7 series is the last version written in C; subsequent versions have moved to C++. GCC 4.x isn't even on life support anymore - i.e., it's dead - but distributing a C-only build system with no C++ support has a masochistic appeal to me.

Newer static musl compilers (GCC 6+) are "done," and should work to compile (static-only) binaries on Chrome OS:

- https://github.com/ryanwoodsmall/musl-misc/releases

Bootstrap recipes:
- **zulu** azul zulu openjdk jvm
- **jgitsh** standalone jgit shell script
- **static-toolchain** musl-cross-make static toolchain

Working recipes:
- abcl (common lisp, https://common-lisp.net/project/armedbear/)
- autoconf
- automake
- bash (4.x, static)
- bc (gnu bc, dc)
- bison
- busybox (static)
- byacc
- bzip2
- curl
- dropbear
- ed (gnu ed)
- expat
- file
- flex
- gawk (gnu awk)
- gettext-tiny (named gettexttiny)
- git
- glib
- grep (gnu grep)
- groff
- htop (uses jython during build)
- jython
- kawa (scheme)
- less
- libbsd
- libevent (no openssl support yet)
- libffi
- libgcrypt
- libgpg-error (named libgpgerror)
- libtool
- links (ncurses)
- lua (posix, no readline)
- lynx (ncurses and slang, ncurses default)
- lzip
- m4
- make
- mbedtls (polarssl)
- ncurses
- netbsd-curses (as netbsdcurses, manual CPPFLAGS/LDFLAGS for now - sabotage https://github.com/sabotage-linux/netbsd-curses)
- opennc (openbsd netcat http://systhread.net/coding/opennc.php)
- openssl
- pcre
- pcre2
- perl
- pkg-config (named pkgconfig)
- python2 (very basic support)
- qemacs (https://bellard.org/qemacs/)
- rc (http://tobold.org/article/rc, https://github.com/rakitzis/rc)
- readline
- rlwrap
- rogue
- rsync
- screen
- sdkman (http://sdkman.io)
- sed (gnu gsed)
- sisc (scheme)
- slang
- socat
- suckless
  - 9base (https://tools.suckless.org/9base)
  - sbase (https://core.suckless.org/sbase)
  - ubase (https://core.suckless.org/ubase)
- svnkit
- tmux
- toybox (static)
- unzip
- vim (with syntax highlighting, which chrome/chromium os vim lacks)
- zip
- zlib

Some things:
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?) _or_
- dnsmasq
- java (oracle or zulu openjdk? both)
- jruby
- mercurial / hg
- nc / ncat / netcat
- subversion / svn

Some other things:
- ant
- antlr
- at&t ast (just ksh now?)
- axtls
- c-kermit (http://www.kermitproject.org/, and/or e-kermit...)
- clojure
- cmake
- cvs
- duplicity (http://duplicity.nongnu.org/)
- dynjs
- editline (https://github.com/troglobit/editline)
- elinks (old, deprecated)
- gc (http://www.hboehm.info/gc/)
- gnutls
- go
- gpg
- gradle
- groovy
- heimdal
- henplus (http://henplus.sourceforge.net/)
- hg4j and client wrapper (dead?)
- hterm utils for chrome os (https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc)
- java-repl
- jcvs
- jline
- jmk (http://jmk.sourceforge.net/edu/neu/ccs/jmk/jmk.html)
- jq
- jscheme (dead)
- llvm / clang
- libedit
- libressl
- lrzsz (https://ohse.de/uwe/software/lrzsz.html)
- luaj
- maven
- mg (https://homepage.boetes.org/software/mg/)
- moreutils
- mutt
- node / npm (ugh)
- nodyn (dead)
- nss
- openconnect
- parenj / parenjs
- pass (https://www.passwordstore.org/)
- pcc
- plan9port (without x11)
- qemu
- rembulan (jvm lua)
- rhino
- ringojs
- scala
- slibtool (https://github.com/midipix-project/slibtool)
- spidermonkey
- spidernode
- sslwrap (http://www.rickk.com/sslwrap/ way old)
- stunnel
- texinfo (requires perl)
- tcc
- tig
- tinyscheme
- tsocks
- vpnc
- w3m (or fork)
- wget
- wolfssl (cyassl)
- support libraries for building the above
- heirloom project tools (http://heirloom.sourceforge.net/)
- whatever else seems useful

Bootstrap packages:
- bash
- openssl
- curl (https)
- git (https/ssh, could replace jgit, not require a jdk?)
- busybox
- toybox
