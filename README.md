# crosware
Tools, things, stuff, miscellaneous, detritus, junk, etc., for Chrome OS / Chromium OS. Eventually this will be a development-ish environment for Chrome OS on both ARM and x86 (32-bit and 64-bit for both). It should work (eventually) on "normal" Linux too.

Ultimately I'd like this to be a self-hosting virtual distribution of sorts, targeting all variations of 32-/64-bit x86 and ARM on Chrome OS. Leaning towards distributing a static-only build system using musl-libc; this precludes things like emacs, but doesn't stop anyone from using a musl toolchain to build a glibc-based shared toolchain. Planning on starting out with shell script-based recipes for configuring/compiling/installing versioned "packages." Initial bootstrap will look something like:

- get a JDK (Azul Zulu OpenJDK)
- get jgit.sh (standalone)
- get static bootstrapped compiler
- checkout rest of project
- build GNU make (v3, no perl)
- build native busybox (if I don't distributed one)
- build a few libs / support (ncurses, openssl, slang, zlib, bzip2, lzma, libevent, pkg-config) 
- build a few packages (curl, vim w/syntax, tmux, links, lynx - mostly because I use them)

Environment stuff to figure out how to handle:

- PATH
- PKG_CONFIG_LIBDIR/PKG_CONFIG_PATH
- CFLAGS
- CPPFLAGS
- LDFLAGS

This is currently just some notes, not-even-half-lazy scripts, and a config file or two.

Chromebrew looks nice and exists now: (https://github.com/skycocker/chromebrew)

Mes might be useful at some point.

- https://gitlab.com/janneke/mes
- https://lists.gnu.org/archive/html/guile-user/2016-06/msg00061.html
- https://lists.gnu.org/archive/html/guile-user/2017-07/msg00089.html

Some things:
- bison
- busybox (static)
- byacc
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?) _or_
- musl-cross-make (static only? preferable, easier)
- dnsmasq
- dropbear
- file
- flex
- git
- java (oracle or zulu openjdk? both)
- jgit (standalone client)
- jruby
- jython
- make
- mercurial / hg
- nc / ncat / netcat
- screen
- socat
- subversion / svn
- tmux
- vim (with syntax highlighting)

Some other things:
- abcl (common lisp, https://common-lisp.net/project/armedbear/)
- ant
- antlr
- at&t ast
- autoconf
- automake
- bc / dc (gnu)
- clojure
- cmake
- curl
- cvs
- dynjs
- elinks (old, deprecated)
- go
- gradle
- groovy
- heimdal
- hg4j and client wrapper (dead?)
- java-repl
- jcvs
- jline
- jmk (http://jmk.sourceforge.net/edu/neu/ccs/jmk/jmk.html)
- jq
- jscheme (dead)
- kawa (scheme)
- llvm / clang
- libedit
- libressl
- libtool
- links (ncurses)
- luaj
- lynx (ncurses, s-lang)
- m4
- maven
- mg (https://homepage.boetes.org/software/mg/)
- moreutils
- musl
- mutt
- ncurses
- netbsd-curses (sabotage https://github.com/sabotage-linux/netbsd-curses)
- node / npm (ugh)
- nodyn (dead)
- openconnect
- openssl
- parenj / parenjs
- pcc
- perl
- plan9port (without x11...)
- pkg-config
- python
- qemacs (https://bellard.org/qemacs/)
- qemu
- readline
- rembulan (lua)
- rhino
- ringojs
- rlwrap
- scala
- sisc (scheme)
- slang
- spidermonkey
- spidernode
- stunnel
- svnkit 
- tcc
- tig
- tinyscheme
- tsocks
- vpnc
- support libraries for building the above
- heirloom project tools (http://heirloom.sourceforge.net/)
- whatever else seems useful
