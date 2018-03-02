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

- ```PATH```
- ```PKG_CONFIG_LIBDIR/PKG_CONFIG_PATH```
- ```CC```
- ```CFLAGS```
- ```CPP```
- ```CPPFLAGS```
- ```CXX```
- ```LDFLAGS```
- ```MANPATH```

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
- bash (4.x, static)
- busybox (static)
- byacc
- curl
- dropbear
- flex
- groff
- htop (uses jython during build)
- jython
- kawa (scheme)
- less
- libevent (no openssl support yet)
- links (ncurses)
- lynx (ncurses and slang, ncurses default)
- m4
- make
- ncurses
- openssl
- perl
- pkg-config (named pkgconfig)
- qemacs (https://bellard.org/qemacs/)
- rc (http://tobold.org/article/rc, https://github.com/rakitzis/rc)
- readline
- rlwrap
- screen
- sdkman (http://sdkman.io)
- sisc (scheme)
- slang
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

Possibly working recipes:
- bison
- bzip2
- expat
- gettext-tiny (named gettexttiny)
- git
- pcre
- pcre2

Some things:
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?) _or_
- dnsmasq
- file
- java (oracle or zulu openjdk? both)
- jruby
- mercurial / hg
- nc / ncat / netcat
- socat
- subversion / svn

Some other things:
- ant
- antlr
- at&t ast
- autoconf
- automake
- awk (gnu gawk)
- bc / dc (gnu)
- clojure
- cmake
- cvs
- dynjs
- editline (https://github.com/troglobit/editline)
- elinks (old, deprecated)
- gc (http://www.hboehm.info/gc/)
- go
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
- libtool
- luaj
- maven
- mg (https://homepage.boetes.org/software/mg/)
- moreutils
- musl
- mutt
- netbsd-curses (sabotage https://github.com/sabotage-linux/netbsd-curses)
- node / npm (ugh)
- nodyn (dead)
- openconnect
- opennc (openbsd netcat http://systhread.net/coding/opennc.php)
- parenj / parenjs
- pcc
- plan9port (without x11)
- python
- qemu
- rembulan (jvm lua)
- rhino
- ringojs
- scala
- sed (gnu gsed)
- spidermonkey
- spidernode
- stunnel
- texinfo (requires perl)
- tcc
- tig
- tinyscheme
- tsocks
- vpnc
- w3m (or fork)
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
