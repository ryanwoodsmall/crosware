# crosware
Tools, things, stuff, miscellaneous, detritus, junk, etc., primarily for Chrome OS / Chromium OS. This is a development-ish environment for Chrome OS on both ARM and x86 (32-bit and 64-bit for both). It should work on "normal" Linux too (Armbian, CentOS, Debian, Raspbian, Ubuntu, etc.).

## bootstrap

To bootstrap, using ```/usr/local/crosware``` with initial downloads in ```/usr/local/tmp```:

```shell
# allow your regular user to write to /usr/local
sudo chgrp ${GROUPS} /usr/local
sudo chmod 2775 /usr/local

# run the bootstrap
# use curl to download the primary shell script
# this in turn downloads a jdk, jgit and a toolchain
bash <(curl -kLs https://raw.githubusercontent.com/ryanwoodsmall/crosware/master/bin/crosware) bootstrap

# source the environment
source /usr/local/crosware/etc/profile
which crosware
```

## install some packages

```shell
# install some stuff
crosware install busybox toybox

# update environment
source /usr/local/crosware/etc/profile

# see what we just installed
which -a make busybox toybox \
| xargs realpath \
| xargs toybox file
```

## update

To get new recipes:

```crosware update```

And to re-bootstrap (for any updated zulu, jgitsh, statictoolchain installs):

```crosware bootstrap```

### further usage

Run **crosware** without any arguments to see usage; i.e, a (possibly outdated) example:

<pre>
usage: crosware [command]

commands:
  bootstrap : bootstrap crosware
  check-installed : given a package name, check if it's installed
  env : dump source-/eval-able crosware etc/profile
  help : show help
  install : attempt to build/install a package from a known recipe
  list-available : list available recipes which are not installed
  list-funcs : list crosware shell functions
  list-installed : list installed recipes
  list-recipe-files : list recipes with their source file
  list-recipe-reqs : list recipes their requirements
  list-recipes : list build recipes
  list-recipe-versions : list recipes with version number
  list-upgradable : list installed packages with available upgrades
  profile : show .profile addition
  run-func : run crosware shell function
  set : run 'set' to show full crosware environment
  show-arch : show kernel and userspace architecture
  show-env : run 'env' to show crosware environment
  show-func : show the given function name
  show-karch : show kernel architecture
  show-uarch : show userspace architecture
  uninstall : uninstall some packages
  update : attempt to update existing install of crosware
  upgrade : uninstall then install a recipe
  upgrade-all : upgrade all packages with different recipe versions
</pre>

#### use external or disable java and jgit

A few user environment variables are available to control how crosware checks itself out and updates recipes.

| var         | default | purpose                                        |
| ----------- | ------- | ---------------------------------------------- |
| CW_GIT_CMD  | jgitsh  | which "git" command to use for checkout/update |
| CW_USE_JAVA | true    | use java for bootstrap, jgit                   |
| CW_EXT_JAVA | false   | use system java instead of zulu recipe         |
| CW_USE_JGIT | true    | use jgit.sh for checkout/update                |
| CW_EXT_JGIT | false   | use system jgit.sh instead of jgitsh recipe    |

#### alpine

Alpine (https://alpinelinux.org/) uses musl libc (http://musl-libc.org) and as such cannot use the Zulu JDK as distributed. To bootstrap using the system-supplied OpenJDK from Alpine repos:

```shell
export CW_EXT_JAVA=true
apk update
apk upgrade
apk add bash curl openjdk8
cd /tmp
curl -kLO https://raw.githubusercontent.com/ryanwoodsmall/crosware/master/bin/crosware
bash crosware bootstrap
```

Make sure the environment variable ```CW_EXT_JAVA``` is set to **true** (or just something other than **false**) to use system Java. Please note that ```/usr/local/crosware/etc/profile``` contains bashisms, and does not work on BusyBox ash, so set your ```SHELL``` accordingly.

If Zulu is installed on a non-glibc distro, run ```crosware uninstall zulu``` and make sure **CW_EXT_JAVA** and **JAVA_HOME** environment variables are configured.

To manually remove the Zulu install directory, environment script and installation flag, remove these paths:

- /usr/local/crosware/etc/profile.d/zulu.sh
- /usr/local/crosware/var/inst/zulu
- /usr/local/crosware/software/zulu/

#### container

A container suitable for bootstrapping is available:

- Docker hub: https://cloud.docker.com/repository/docker/ryanwoodsmall/crosware
- buildable from: https://github.com/ryanwoodsmall/dockerfiles/tree/master/crosware

Run with:

```docker run -it ryanwoodsmall/crosware```

An interactive bash shell session will start, and any crosware C/C++ packages should build and run out of the box.

Build with something like:

```shell
docker build --tag crosware https://raw.githubusercontent.com/ryanwoodsmall/dockerfiles/master/crosware/Dockerfile
docker run -it crosware
```

Inside the container, install **git** to enable updates and list any upgradable packages:

```shell
# note: this installs git and its prereqs from source, it might take awhile
crosware install git
. /usr/local/crosware/etc/profile
crosware update
crosware list-upgradable
```

# notes

Ultimately I'd like this to be a self-hosting virtual distribution of sorts, targeting all variations of 32-/64-bit x86 and ARM on Chrome OS. A static-only GCC compiler using musl-libc (with musl-cross-make) is installed as part of the bootstrap; this sort of precludes things like emacs, but doesn't stop anyone from using a musl toolchain to build a glibc-based shared toolchain.

My initial bootstrap looks something like:

- scripted, i.e., `crosware bootstrap`:
  - get a JDK (Azul Zulu OpenJDK)
  - get jgit.sh (standalone)
  - get static bootstrapped compiler
  - checkout rest of project
- manually install some packages, i.e, `crosware install vim git ...`:
  - build GNU make
  - build native busybox, toolbox, sed, etc.
  - build a few libs / support (ncurses, openssl, slang, zlib, bzip2, lzma, libevent, pkg-config)
  - build a few packages (curl, vim w/syntax hightlighting, screen, tmux, links, lynx - mostly because I use them)

# environment

Environment stuff to figure out how to handle:

- ```PATH``` (working)
- ```PKG_CONFIG_LIBDIR/PKG_CONFIG_PATH``` (working)
- ```CC``` (working)
- ```CFLAGS``` (working)
- ```CPP``` (working)
- ```CPPFLAGS``` (working)
- ```CXX``` (working)
- ```INFOPATH```
- ```LDFLAGS``` (working)
- ```MANPAGER``` (working)
- ```MANPATH```
- ```ACLOCAL_PATH```
- ```EDITOR``` (vim?)
- ```PAGER``` (working, set to less (gnu or busybox))

# stuff to figure out

See [the to-do list](TODO.md)

# links

Chromebrew looks nice and exists now: https://github.com/skycocker/chromebrew

Alpine and Sabotage are good sources of inspiration and patches:

- Alpine: https://alpinelinux.org/ and git: https://git.alpinelinux.org/
- Sabotage: http://sabotage.tech/ and git: https://github.com/sabotage-linux/sabotage/

The Alpine folks distribute a chroot installer (untested):

- https://github.com/alpinelinux/alpine-chroot-install

And I wrote a little quick/dirty Alpine chroot creator that works on Chrome/Chromium OS; no Docker or other software necessary.

- https://github.com/ryanwoodsmall/shell-ish/blob/master/bin/chralpine.sh

The musl wiki has some pointers on patches and compatibility:

- https://wiki.musl-libc.org/compatibility.html#Software-compatibility,-patches-and-build-instructions

Mes (and m2) might be useful at some point.

- https://www.gnu.org/software/mes/
- janneke stuff:
  - https://gitlab.com/users/janneke/projects
  - https://gitlab.com/janneke/mes
  - https://gitlab.com/janneke/mes-seed
  - https://github.com/janneke/mescc-tools
  - https://gitlab.com/janneke/nyacc
  - https://gitlab.com/janneke/stage0
  - https://gitlab.com/janneke/stage0-seed
  - https://gitlab.com/janneke/tinycc
- oriansj stuff:
  - https://github.com/oriansj
  - https://github.com/oriansj/M2-Planet
  - https://github.com/oriansj/M2-Moon
  - https://github.com/oriansj/mes-m2
  - https://github.com/oriansj/mescc-tools-seed
  - https://github.com/oriansj/mescc-tools
  - https://github.com/oriansj/stage0
- https://lists.gnu.org/archive/html/guile-user/2016-06/msg00061.html
- https://lists.gnu.org/archive/html/guile-user/2017-07/msg00089.html
- http://lists.gnu.org/archive/html/info-gnu/2018-08/msg00006.html

Suckless has a list of good stuff:

- https://suckless.org/rocks/

Mark Williams Company open sourced Coherent; might be a good source for SUSv3/SUSv4/POSIX stuff:

- http://www.nesssoftware.com/home/mwc/source.php

9p implementations:

- http://9p.cat-v.org/implementations

Eltanin tools may be useful:

- https://eltan.in.net/?tools/index
- https://github.com/eltanin-os

## C/C++ compiler

Static musl GCC compiler(s) are done, and should work to compile (static-only, some shared lib support) binaries on Chrome OS:

- https://github.com/ryanwoodsmall/musl-misc/releases

Based on Rich Felker's musl-cross-make:

- https://github.com/richfelker/musl-cross-make

# recipes

## bootstrap recipes

These recipes are included in the main `bin/crosware` script, as they're the foundation of the tool and are distributed as binaries.
There are a handful of other binary recipes that are not necessary for bootstrapping.
The **statictoolchain** recipe could theoretically be pulled into a normal standalone recipe, but is bedrock enough that it fits in the main script.
A smaller, more supportable, preferably single-binary static Git client would/will hopefully also find its way to the main script for bootstrap purposes.

- **zulu** azul zulu openjdk jvm
- **jgitsh** standalone jgit shell script
- **statictoolchain** musl-cross-make static toolchain
  - now self-hosted on crosware
    - https://github.com/ryanwoodsmall/musl-misc/blob/master/musl-cross-make-confs/Makefile.arch_indep
    - https://github.com/ryanwoodsmall/dockerfiles/blob/master/crosware/statictoolchain/files/build-statictoolchain.sh

## working recipes

- abcl (common lisp, https://common-lisp.net/project/armedbear/)
- at (http://ftp.debian.org/debian/pool/main/a/at/)
- autoconf
- automake
- baseutils (https://github.com/ibara/baseutils - portable openbsd userland)
- bash (5.x, netbsdcurses)
  - bash4 (netbsdcurses)
  - bash50 (netbsdcurses)
- bc (gnu bc, dc)
- bdb47
- bearssl (https://bearssl.org/)
- bim (https://github.com/klange/bim - minimal vim-alike)
- binutils (bfd, opcodes, libiberty.a)
- bison
- bmake (http://www.crufty.net/help/sjg/bmake.html)
- brogue
- bsd programs
  - bsdjot (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?jot+1)
  - bsdrs (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?rs+1)
  - bsdunvis (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?unvis+1)
  - bsdvis (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?vis+1)
- busybox (static)
- byacc
- bzip2
- cacertificates (from alpine)
- ccache - version 3.x, autotools
  - ccache4 - now requires cmake, keep them separate for now
- cflow
- check
- cloc (https://github.com/AlDanial/cloc)
- cmake
- configgit (gnu config.guess, config.sub updates for musl, aarch64, etc. http://git.savannah.gnu.org/gitweb/?p=config.git;a=summary)
- coreutils (single static binary with symlinks, no nls/attr/acl/gmp/pcap/selinux)
- cppcheck
- cppi
- cscope
- cssc (gnu sccs)
- ctags (exuberant ctags for now, universal ctags a better choice?)
- curl
- cvs
- cxref
- dash (http://gondor.apana.org.au/~herbert/dash/ and https://git.kernel.org/pub/scm/utils/dash/dash.git)
- derby
- diffutils
- diction and style (https://www.gnu.org/software/diction/)
- dnsmasq (http://www.thekelleys.org.uk/dnsmasq/doc.html)
  - look at adding...
    - libnetfilter_conntrack (conntrack)
    - nettle, gmp (DNSSSEC)
      - ```CFLAGS=\"\${CFLAGS} -Wall -W -O2\" LDFLAGS=\"\${LDFLAGS} -static\" COPTS=\"-DHAVE_DNSSEC \${CPPFLAGS}\"```
    - idn/idn2 (IDN)
      - ```-DHAVE_IDN``` (libidn) ```-DHAVE_LIBIDN2``` (libidn2, libunistring)
    - lua? (5.2 only?)
    - dbus? ubus?
- dockerstatic (static docker binaries from https://download.docker.com/linux/static/stable/)
  - good enough for remote ```${DOCKER_HOST}``` usage
  - amd64/arm32v6/arm64v8 only
  - does _not_ work on i686
  - architecture naming conventions: https://github.com/docker-library/official-images#architectures-other-than-amd64
- dropbear (https://matt.ucc.asn.au/dropbear/dropbear.html and https://dropbear.nl/)
- duktape (http://duktape.org/ and https://github.com/svaarala/duktape)
- ecl (https://common-lisp.net/project/ecl/)
  - shared build
  - works for aarch64/i686/x86_64
  - does _not_ work on arm (gc? gmp?)
- ed (gnu ed)
- editline (https://github.com/troglobit/editline)
- elinks (http://elinks.or.cz/ from git: https://repo.or.cz/elinks.git)
  - investigate adding tre, spidermonkey javascript/ecmascript/js, ...
- elvis (https://github.com/mbert/elvis)
- expat
- file
- findutils
- flex
- gambit (https://github.com/gambit/gambit and http://gambitscheme.org/wiki/index.php/Main_Page)
- gauche (https://github.com/shirok/Gauche and https://practical-scheme.net/gauche/index.html)
  - shared build
  - all options disabled
  - investigate zlib/gdbm and tls/ssl/...
- gawk (gnu awk, prepended to $PATH, becomes default awk)
- gc (working on x86\_64, aarch64; broken on i386, arm)
- gdbm
- gettexttiny
- git
- glib (https://wiki.gnome.org/Projects/GLib)
  - old version
  - new version requires meson, ninja, thus python3
- global
- gmp
- gnupg (with ntbtls - https://gnupg.org/software/index.html)
  - gnupg1 (gnupg 1.x - older, smaller gnupg version, with fewer prereqs)
- go
  - static binary archive
  - built via: https://github.com/ryanwoodsmall/go-misc/blob/master/bootstrap-static/build.sh
  - gobootstrap recipe with 1.4 bootstrap binaries (i386, amd64, arm, arm 32-bit static for aarch64)
- grep (gnu grep)
- groff
- guile (https://www.gnu.org/software/guile/)
  - works for aarch64/x86_64
  - does _not_ work on arm/i686 (gc)
  - guile2 recipe as well, with same caveats
- heirloom project tools (http://heirloom.sourceforge.net/ - musl/static changes at https://github.com/ryanwoodsmall/heirloom-project)
  - exvi with netbsdcurses also available as a standalone package
- help2man
- htermutils (https://chromium.googlesource.com/apps/libapps/+/HEAD/hterm/etc/)
- htop
- iftop
- inetutils
- indent
- iperf
  - iperf
  - iperf3
- isl
- itsatty (https://github.com/ryanwoodsmall/itsatty)
- j7zip
- jo (https://github.com/jpmens/jo)
- jq (https://stedolan.github.io/jq/ - with oniguruma regex)
- jruby
- jscheme
- jython
- kawa (scheme)
- kernelheaders (https://github.com/sabotage-linux/kernel-headers - from sabotage linux)
- ksh93 (https://github.com/att/ast/ via at&t ast)
  - this is actually ksh2020...
  - should be renamed as such
- less (netbsdcurses)
- lftp (https://lftp.yar.ru/)
- libassuan (https://gnupg.org/software/libassuan/index.html)
- libatomicops
- libbsd
- libedit (https://www.thrysoee.dk/editline/ aka editline, from netbsd - ncurses and netbsdcurses)
- libev (http://software.schmorp.de/pkg/libev.html)
- libevent (no openssl support yet)
- libffi
- libgcrypt (https://gnupg.org/software/libgcrypt/index.html)
- libgit2
- libgpgerror (https://gnupg.org/software/libgpg-error/index.html)
- libidn (https://www.gnu.org/software/libidn/)
- libidn2 (https://www.gnu.org/software/libidn/#libidn2)
- libksba (https://gnupg.org/software/libksba/index.html)
- libmd (https://www.hadrons.org/software/libmd/)
- libmetalink (https://github.com/metalink-dev/libmetalink)
- libnl
- liboop (https://www.lysator.liu.se/liboop/)
- libpcap
- libressl (https://www.libressl.org/)
- libssh2 (openssl, zlib)
- libtasn1 (https://ftp.gnu.org/gnu/libtasn1/)
- libtool
- libunistring (https://ftp.gnu.org/gnu/libunistring/)
- libuv (https://github.com/libuv/libuv)
- libxml2
- libxslt
- linenoise (https://github.com/antirez/linenoise)
- links (ncurses)
- loksh (https://github.com/dimkr/loksh)
- lsh (https://www.lysator.liu.se/~nisse/lsh/ - version 2.0, 2.1 has issues with separate/new nettle)
- lua (posix, no readline)
- lynx (ncurses and slang, ncurses default)
- lz4 (https://github.com/lz4/lz4)
- lzip
  - clzip
  - lunzip
  - lzip
  - lziprecover
  - lzlib
  - pdlzip
  - plzip
  - zutils
- m4
- make (gnu)
  - bootstrapmake (gnu make w/o gnu sed requirement)
- mandoc (http://mandoc.bsd.lv/)
- manpages, consisting of...
  - man-pages (https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/)
  - man-pages-posix (https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/man-pages-posix/)
- mawk (https://invisible-island.net/mawk/mawk.html)
- mbedtls (polarssl)
- meson (http://mesonbuild.com/)
- miller (https://github.com/johnkerl/miller - mlr, needs '-g -pg' disabled in c/Makefile.{am,in})
- minischeme (https://github.com/catseye/minischeme)
- mksh (http://www.mirbsd.org/mksh.htm)
- most (https://www.jedsoft.org/most/)
- mpc
- mpfr
- mtm (https://github.com/deadpixi/mtm - micro terminal multiplexer)
- mujs (http://mujs.com/ and https://github.com/ccxvii/mujs)
- muslfts (https://github.com/pullmoll/musl-fts)
- muslstandalone (http://musl.libc.org/ - unbundled musl libc and kernel headers with musl-gcc wrapper, possibly different version from statictoolchain)
- ncurses
- neat/litcave stuff (http://litcave.rudi.ir/)
  - neatvi (https://github.com/aligrudi/neatvi)
- netbsdcurses (manual CPPFLAGS/LDFLAGS for now - sabotage https://github.com/sabotage-linux/netbsd-curses)
- netcatopenbsd (from debian, https://salsa.debian.org/debian/netcat-openbsd)
  - should replace opennc, which is, uhhhhhhh missing?
- netsurf libraries
  - libparserutils (https://www.netsurf-browser.org/projects/libparserutils/)
  - libwapcaplet (https://www.netsurf-browser.org/projects/libwapcaplet/)
  - libhubbub (https://www.netsurf-browser.org/projects/hubbub/)
  - libdom (https://www.netsurf-browser.org/projects/libdom/)
  - libcss (https://www.netsurf-browser.org/projects/libcss/)
- nettle (http://www.lysator.liu.se/~nisse/nettle/ and https://git.lysator.liu.se/nettle/nettle)
- ninja (https://ninja-build.org/)
- nmap
- npth (https://gnupg.org/software/npth/index.html)
- ntbtls (https://gnupg.org/software/ntbtls/index.html)
- nvi (via debian, https://salsa.debian.org/debian/nvi)
- nvi179 (4bsd release from keith bostic, https://sites.google.com/a/bostic.com/keithbostic/vi)
- oksh (https://github.com/ibara/oksh - netbsdcurses)
- oniguruma (https://github.com/kkos/oniguruma)
- openssh (openssl, netbsdcurses libedit)
- openssl
- outils (https://github.com/leahneukirchen/outils - utils from openbsd, including jot/rs/vis/unvis/etc.)
- p7zip
- par (http://www.nicemice.net/par/ via debian https://packages.debian.org/buster/text/par)
- patch (gnu)
- patchelf (https://nixos.org/patchelf.html and https://github.com/NixOS/patchelf)
- pcc (http://pcc.ludd.ltu.se/)
  - only x86_64 for now!
  - kinda painful for static compilation, segfaults, etc.
  - not sure on `crt?.o` files either
  - uses muslstandalone as libc
- pcre
- pcre2
- perl
- pinentry (curses via ncurses, tty)
- pixman (http://www.pixman.org/ and https://www.cairographics.org/releases/)
- pkgconfig
- python
  - python2 (very basic support)
  - python3 (wip)
- qalc (https://qalculate.github.io/ - libqalculate and cli/text interface)
- qemacs (https://bellard.org/qemacs/)
- qemuuser (https://www.qemu.org/ - linux userspace only for now)
- quickjs (https://bellard.org/quickjs/)
- rc (http://tobold.org/article/rc, https://github.com/rakitzis/rc - needs to be git hash, currently old release)
- rcs (gnu)
- readline (ncurses and netbsdcurses)
- reflex (https://invisible-island.net/reflex/reflex.html)
- rhino
- rlwrap (netbsdcurses)
- rogue
- rsync
- sc (from debian, https://packages.debian.org/buster/sc)
- scheme48 (http://s48.org)
- screen
- sdkman (http://sdkman.io)
- sed (gnu gsed, prepended to $PATH, becomes default sed)
- sharutils (https://www.gnu.org/software/sharutils/)
- shellinabox (https://github.com/shellinabox/shellinabox)
- simh (http://simh.trailing-edge.com and https://github.com/simh/simh)
- sisc (scheme)
- slang (ncurses)
- slibtool (https://github.com/midipix-project/slibtool)
- slsc (jedsoft "sc" console spreadsheet for slang)
- socat
- source-highlight (https://www.gnu.org/software/src-highlite/)
  - OLD 1.x version
  - limited language support, though
  - see below for notes on newer versions (boost req, yeesh)
- strace (https://strace.io/ and https://github.com/strace/strace)
- stunnel
- sqlite
- suckless
  - 9base (https://tools.suckless.org/9base)
  - sbase (https://core.suckless.org/sbase)
  - ubase (https://core.suckless.org/ubase)
- svnkit
- texinfo (untested, requires perl)
- tig
- tini (small init for containers, https://github.com/krallin/tini)
- tinycc
  - tcc from gnu guix mirror
  - https://ftp.gnu.org/pub/gnu/guix/mirror/)
  - sorta works?
  - static is broken, like...
  - default shared lib seems to work?
  - `tcc -run file.c` seems to work on x86_64
  - everything else is kinda broken
  - tcc from git probably a better option
  - uses muslstandalone as libc
- tinyccmob (https://repo.or.cz/tinycc.git)
  - more up-to-date tcc from git snapshot
  - x86_64 "works"-ish
  - static still has issues
  - shared seems to work for hello world stuff
  - uses muslstandalone as libc
- tinyemu (https://bellard.org/tinyemu/ - risc-v 32/64, risc-v 128 on x86_64/aarch64, x86 w/kvm on x86_64/i686; no sdl)
- tinyscheme (http://tinyscheme.sourceforge.net/home.html)
- tio (https://tio.github.io and https://github.com/tio/tio)
- tmux
- tnftp (ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/)
- toybox (static)
- tree (http://mama.indstate.edu/users/ice/tree/)
- unrar
- unzip
- utillinux
- uucp (https://www.airs.com/ian/uucp.html and https://www.gnu.org/software/uucp/)
- vile (https://invisible-island.net/vile/)
- vim (with syntax highlighting, which chrome/chromium os vim lacks)
- w3m (https://github.com/tats/w3m)
- wget
- wolfssl (cyassl)
- xinetd (https://github.com/openSUSE/xinetd forked from https://github.com/xinetd-org/xinetd)
- xmlstarlet (http://xmlstar.sourceforge.net/)
- xvi (http://martinwguy.github.io/xvi/)
- xxhash (https://github.com/Cyan4973/xxHash)
- xz (https://tukaani.org/xz/)
- yash (http://yash.osdn.jp/ and https://github.com/magicant/yash)
- zip
- zlib
- zstd (https://github.com/facebook/zstd)

## recipes to consider

- 9pfs (https://github.com/mischief/9pfs - fuse 9p driver)
- 9pro (https://github.com/ftrvxmtrx/9pro - 9p tools for unix)
  - moved? https://github.com/ftrvxmtrx/o-hai-I-m-moving-to-git.sr.ht
  - https://git.sr.ht/~ft/9pro
- ack (https://beyondgrep.com/)
- acl (https://savannah.nongnu.org/projects/acl/)
- ag (the silver searcher https://geoff.greer.fm/ag/)
- agner fog's stuff
  - https://www.agner.org/optimize/#objconv
- align (and width, perl scripts, http://kinzler.com/me/align/)
- aloa (linter - https://github.com/ralfholly/aloa)
- ansicurses (https://github.com/byllgrim/ansicurses)
- argp-standalone (http://www.lysator.liu.se/~nisse/misc/ and https://git.alpinelinux.org/aports/tree/main/argp-standalone)
- aria2 (https://github.com/aria2/aria2 and https://aria2.github.io/)
- arr (https://github.com/leahneukirchen/arr)
- assemblers?
  - fasm
  - nasm
  - vasm
  - yasm
- at&t ast
  - old, full code:
    - does not work at all bulding w/musl
    - old freebsd/debian/etc. stuff useful?
      - https://svnweb.freebsd.org/ports?view=revision&revision=480231
      - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=887743
      - https://github.com/att/ast/commit/cbe3543e0616f01973bc2f1f1ee8784be87fa1d6
    - tksh needs x11, no way
    - ```git clone https://github.com/att/ast.git ; cd ast ; git checkout 2016-01-10-beta```
    - totally convoluted build system
      - iffe -> mamake -> nmake -> stuff?
    - busybox, mksh, bash, byacc, reflex, flex, bison, gdbm, ???, ...
    - errors:
      - error: unknown type name 'off64_t'; did you mean 'off_t'?
      - error: conflicting types for '_sfio_FILE'
      - error: storage size of 'st' isn't known
      - error: dereferencing pointer to incomplete type 'Stat_t' {aka 'struct stat64'}
    - _GNU_SOURCE, USE_GNU, etc., not working
    - wip, trying, failing, ...:
```
git grep -ril '#.*define.*off64_t' . | xargs sed -i '/define/s/off64_t/off_t/g'
git grep -ril '#.*undef.*off_t' | xargs sed -i '/undef/s/off_t/off64_t/g'
time \
  env -i \
    PATH=${cwsw}/ccache/current/bin:${cwsw}/mksh/current/bin:${cwsw}/bash/current/bin:${cwsw}/statictoolchain/current/bin:${cwsw}/byacc/current/bin:${cwsw}/reflex/current/bin:${cwsw}/busybox/current/bin:${cwsw}/bison/current/bin:${cwsw}/flex/current/bin \
    mksh -x ./bin/package make \
      CFLAGS= \
      LDFLAGS= \
      CPPFLAGS= \
      CCFLAGS="-D_GNU_SOURCE -D_BSD_SOURCE -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_USE_GNU -D__GLIBC__" 2>&1 | tee /tmp/astbuild.out
wc -l /tmp/astbuild.out
```
- attr (https://savannah.nongnu.org/projects/attr/)
- awk (https://github.com/onetrueawk/awk - the one true awk)
- axtls (http://axtls.sourceforge.net/ - dead? curl deprecated)
- b2sum (https://github.com/dchest/b2sum)
- babashka (https://github.com/borkdude/babashka - clojure+shell?)
- bashdb (http://bashdb.sourceforge.net/ - bash debugger)
- basher (https://github.com/basherpm/basher - bash script package manager)
- bic (https://github.com/hexagonal-sun/bic - c repl)
- big data stuff
  - hadoop (version 2.x? 3.x? separate out into separate versioned recipes?)
  - hbase (version?)
  - spark (included in sdkman)
- binfmt-support (https://git.savannah.gnu.org/cgit/binfmt-support.git - ???)
- blake2 (https://github.com/BLAKE2/BLAKE2)
- boost (...)
  - ```./bootstrap.sh --prefix=${ridir} --without-icu ; ./b2 --prefix=${ridir} --layout=system -q link=static install```
  - it's like a 100MB tgz, 700MB extracted, 900MB during build, 190MB installed
  - yikes
- botan (https://github.com/randombit/botan)
  - build with something like...
  - ```
    ./configure.py \
      --prefix=${ridir} \
      --cc=gcc \
      --ar-command=${AR} \
      --cc-bin=$(which ${CXX}) \
      --cxxflags="-fPIC -Wl,-static" \
      --ldflags=-static \
      --system-cert-bundle=${cwtop}/etc/ssl/cert.pem \
      --disable-shared-library \
      --build-targets=static,cli
    ```
- bpkg (http://www.bpkg.sh/ and https://github.com/bpkg/bpkg - bash package manager)
- brotli (https://github.com/google/brotli)
- brogue stuff
  - brogue (https://github.com/tsadok/brogue)
  - broguece (https://github.com/tmewett/BrogueCE)
  - brogue-linux (https://github.com/CubeTheThird/brogue-linux)
  - gbrogue (https://github.com/gbelo/gBrogue)
- bsd-coreutils (https://github.com/Projeto-Pindorama/bsd-coreutils - bsd stuff, fork of lobase-old?)
- bsdgames (debian - https://packages.debian.org/buster/bsdgames)
- bsd-headers (http://cgit.openembedded.org/openembedded-core/tree/meta/recipes-core/musl - oe/yocto)
- build-scripts (https://github.com/noloader/Build-Scripts - useful versions, packaging, etc. stuff)
- c9 (https://github.com/ftrvxmtrx/c9 - small 9p client/server impl)
  - moved? https://github.com/ftrvxmtrx/o-hai-I-m-moving-to-git.sr.ht
  - https://git.sr.ht/~ft/c9
- c-ares (https://github.com/c-ares/c-ares)
- c-kermit (http://www.kermitproject.org/, and/or e-kermit...)
- cataclysm: dark days ahead (https://github.com/CleverRaven/Cataclysm-DDA - fork of https://github.com/Whales/Cataclysm)
- cawf (nroff workalike, https://github.com/ksherlock/cawf or https://github.com/0xffea/MINIX3/tree/master/commands/cawf or ???)
- cembed (https://github.com/rxi/cembed - embed files in a c header - useful for tinyscheme/minischeme library in single binary???)
- cepl (https://github.com/alyptik/cepl)
- ching (https://github.com/floren/ching - i ching from bsd)
  - needs nroff (heirloom or groff)
  - ```
    sed -i.ORIG s,/usr/local,${ridir},g Makefile phx/pathnames.h ching.sh
    sed -i s,${ridir}/games,${ridir}/bin,g Makefile phx/pathnames.h ching.sh
    make CC="${CC} -static -Wl,-static"
    ```
- chrpath
- cjson (https://github.com/DaveGamble/cJSON)
- c/c++ compiler stuff
  - 8cc (https://github.com/rui314/8cc)
  - 9cc (https://github.com/rui314/9cc)
  - 9-cc (https://github.com/0intro/9-cc - unix port of plan 9 compiler)
  - andrew chambers's c (https://github.com/andrewchambers/c)
  - c4 (https://github.com/rswier/c4)
  - chibicc (https://github.com/rui314/chibicc)
  - cproc (https://git.sr.ht/~mcf/cproc and https://github.com/michaelforney/cproc)
  - kencc (https://github.com/aryx/fork-kencc)
  - lacc (https://github.com/larmel/lacc)
  - lcc (https://github.com/drh/lcc)
  - mazucc (https://github.com/jserv/MazuCC)
  - plan9-cc (https://github.com/huangguiyang/plan9-cc)
  - qbe (https://c9x.me/compile/)
  - scc (http://www.simple-cc.org/)
  - tendra (https://bitbucket.org/asmodai/tendra/src/default/ https://en.wikipedia.org/wiki/TenDRA_Compiler)
- cmark (commonmark markddown - https://github.com/commonmark/cmark)
  - cmark-gfm (github fork - https://github.com/github/cmark-gfm)
- cparser (https://pp.ipd.kit.edu/git/cparser/)
- cpplint (https://github.com/google/styleguide and https://github.com/cpplint/cpplint)
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?)
  - would be useful to provide gcc with glibc support for more "native" builds
  - base on centos 7? rhel 8? debian 10? ubuntu 20 lts?
  - could be used to bootstrap llvm/clang and bootstrap rust?
- cryanc (https://github.com/classilla/cryanc - crypto ancienne, tls for old platformcs)
- curl caextract (https://curl.haxx.se/docs/caextract.html - replace/augment cacertificates?)
- dante (socks proxy client/server https://www.inet.no/dante/)
- dasel (https://github.com/TomWright/dasel - data selector like jq, yq - go)
- ddrescue
- diod (https://github.com/chaos/diod - 9p fileserver)
- discount (markdown - https://github.com/Orc/discount)
- docbook?
- dpic (https://ece.uwaterloo.ca/~aplevich/dpic/)
- dsvpn (https://github.com/jedisct1/dsvpn)
- dtach (https://github.com/crigler/dtach - simpler detachable screenalike)
- dumb-init (https://github.com/Yelp/dumb-init)
- duplicity (http://duplicity.nongnu.org/)
- e (https://github.com/hellerve/e - simple editor, syntax highlighting, archived?)
- e2fsprogs (https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/ - usable uuid for python)
  - config opts: `--disable-lto --enable-symlink-install --enable-verbose-makecmds --disable-nls --enable-libuuid --enable-libblkid`
  - `make install` needs `MKDIR_P='mkdir -p'`
- edbrowse (http://edbrowse.org/ and https://github.com/CMB/edbrowse)
  - cmake, curl, pcre, tidy (cmake), duktape
- elfutils (https://sourceware.org/elfutils/)
- ellcc (embedded clang build, http://ellcc.org/)
- elvm (https://github.com/shinh/elvm)
- emacs
  - 26.1+ can be compiled without gnutls?
  - needs aslr disabled during dump?
  - or ```setarch $(uname -m) -R``` prepended to make?
  - `--without-x --with-xml2 --with-modules`
  - `LIBGNUTLS_LIBS='-lgnutls -lhogweed -lnettle -lgmp -ltasn1 -lunistring'`
  - `LIBXML2_LIBS='-lxml2 -lz -lz -llzma'`
- emulation stuff
  - axpbox (https://github.com/lenticularis39/axpbox - alpha)
  - gxemul (http://gavare.se/gxemul/)
- entr (http://entrproject.org/)
- eris (https://github.com/nealey/eris - small web server)
- finit (https://github.com/troglobit/finit)
- firejail (https://github.com/netblue30/firejail)
- fountain (formerly? http://hea-www.cfa.harvard.edu/~dj/tmp/fountain-1.0.2.tar.gz)
- gatling (http://www.fefe.de/gatling/ - small web/cgi/ftp/smb server)
- gcompat (https://code.foxkit.us/adelie/gcompat and https://github.com/AdelieLinux/gcompat)
- geomyidae (http://r-36.net/scm/geomyidae/ - gopher server)
- gdb
- git-crypt (https://github.com/AGWA/git-crypt)
- gmni (https://sr.ht/~sircmpwn/gmni/ and https://git.sr.ht/~sircmpwn/gmni - gemini client)
- gmnisrv (https://sr.ht/~sircmpwn/gmnisrv/ and https://git.sr.ht/~sircmpwn/gmnisrv - gemini server)
- gojq (https://github.com/itchyny/gojq)
- gpg
  - gpgme
  - etc.
- gnutls
  - needs nettle, gmplib, libtasn1, libunistring
  - configure needs ```--without-p11-kit --disable-doc --enable-manpages --with-default-trust-store-file=${cwetc}/ssl/cert.pem```
  - mini-nettle/mini-gmp?
- gophernicus (https://github.com/gophernicus/gophernicus - gopher server)
- got (https://gameoftrees.org/ - game of trees, openbsd-specific git-like)
- gotty (https://github.com/yudai/gotty - like shellinabox in go)
- graphviz (http://graphviz.org/)
- gsl (gnu scientific library, https://www.gnu.org/software/gsl/)
- hitch (https://hitch-tls.org/ - libev tls proxy)
- hoedown (markdown lib - https://github.com/hoedown/hoedown)
- hq (https://github.com/rbwinslow/hq)
- http-parser (https://github.com/nodejs/http-parser - useful with libgit2?)
- ibara's good portable/bsd stuff
  - m4 (https://github.com/ibara/m4)
  - yacc (https://github.com/ibara/yacc)
- inadyn (https://github.com/troglobit/inadyn)
- incron (https://github.com/ar-/incron - cron for filesystem events)
- inotify-tools (https://github.com/rvoicilas/inotify-tools)
- invisible-island (thomas e. dickey) stuff
  - bcpp (https://invisible-island.net/bcpp/bcpp.html)
  - c_count (https://invisible-island.net/c_count/c_count.html)
  - cindent (https://invisible-island.net/cindent/cindent.html)
  - cproto (https://invisible-island.net/cproto/cproto.html)
  - dialog (https://invisible-island.net/dialog/dialog.html)
  - misc_tools (ftp://ftp.invisible-island.net/pub/misc_tools/)
- iodine (https://github.com/yarrick/iodine)
  - **src/Makefile** needs a ```$(CC) -c``` for the _.c.o_ rule
  - build with something like ```make CFLAGS="-I${cwsw}/zlib/current/include -D__GLIBC__=1" LDFLAGS="-L${cwsw}/zlib/current/lib -lz -static" CPPFLAGS= SHELL='bash -x'```
  - musl static build errors out with ```iodined: open_tun: Failed to open tunneling device: No such file or directory```?
- java stuff
  - alpine openjdk? 11? 8?
  - ant (included in sdkman)
  - antlr
  - beanshell
  - ceylon (included in sdkman)
  - clojure (leiningen included in sdkman)
  - ecj (separate compiler from eclipse? native code w/graal, gcj, etc.?)
  - frege (https://github.com/Frege/frege)
  - gradle (included in sdkman)
  - grails (included in sdkman)
  - groovy (included in sdkman)
  - hg4j and client wrapper (https://github.com/nathansgreen/hg4j)
  - java-repl
  - jbang (https://www.jbang.dev/ - in sdkman)
  - jikes (dead but useful?)
  - jline
  - jmk (http://jmk.sourceforge.net/edu/neu/ccs/jmk/jmk.html)
  - kotlin (included in sdkman)
  - libjffi (https://github.com/jnr/jffi)
  - luaj
  - maven (included in sdkman)
  - mina (apache multipurpose infrastructure for network applications: java nio, ftp, sshd, etc.; https://mina.apache.org/)
  - nailgun (https://github.com/facebook/nailgun and http://www.martiansoftware.com/nailgun/)
  - rembulan (jvm lua)
  - ringojs
  - sbt (included in sdkman)
  - scala (included in sdkman)
  - teavm (https://github.com/konsoletyper/teavm - java bytecode to javascript)
  - xtend
- java jvm/jdk stuff
  - adoptopenjdk (https://adoptopenjdk.net/)
  - avian (https://readytalk.github.io/avian/)
  - cacao
  - corretto (https://github.com/corretto)
  - dragonwell (https://github.com/alibaba/dragonwell8)
  - jamvm
  - jikes rvm
  - liberica (https://www.bell-sw.com/java.html)
  - maxine (https://github.com/beehive-lab/Maxine-VM)
  - ojdkbuild (https://github.com/ojdkbuild/ojdkbuild)
  - openj9
  - ...
- javascript stuff
  - colony-compiler (unmaintained - https://github.com/tessel/colony-compiler)
  - dukluv (https://github.com/creationix/dukluv - libuv+duktape)
  - espruino (https://github.com/espruino/Espruino)
  - esvu (https://github.com/devsnek/esvu)
  - iv (https://github.com/Constellation/iv)
  - jerryscript (https://github.com/jerryscript-project/jerryscript and http://jerryscript.net/)
  - jsi (jsish - https://jsish.org/)
  - jsvu (https://github.com/GoogleChromeLabs/jsvu)
  - mininode (https://github.com/mininode/mininode - embedded node.js compat on duktape, cool not sure how mature)
  - mjs (formerly v7 - https://github.com/cesanta/mjs and https://github.com/cesanta/v7/)
  - quad-wheel (https://code.google.com/archive/p/quad-wheel/)
  - tiny-js (https://github.com/gfwilliams/tiny-js)
- jdbc
  - drivers
    - derby (included in derby.jar)
    - h2 (http://www.h2database.com/html/main.html)
    - hsqldb (http://hsqldb.org/)
    - mariadb (https://mariadb.com/kb/en/library/about-mariadb-connector-j/)
    - mssql (https://github.com/Microsoft/mssql-jdbc)
    - mysql (https://dev.mysql.com/downloads/connector/j/)
    - oracle? (probably not)
    - postgresql (https://jdbc.postgresql.org/)
    - sqlite (https://bitbucket.org/xerial/sqlite-jdbc and https://github.com/xerial/sqlite-jdbc)
  - programs/clients/other
    - ha-jdbc (https://github.com/ha-jdbc/ha-jdbc)
    - henplus (https://github.com/neurolabs/henplus - formerly http://henplus.sourceforge.net/)
    - jisql (https://github.com/stdunbar/jisql)
    - sqlshell (scala, sbt - https://github.com/bmc/sqlshell)
- jed (https://www.jedsoft.org/jed/)
- jitter (http://ageinghacker.net/projects/jitter/ - jit/vm/interpreter thing)
- joe (https://joe-editor.sourceforge.io/)
- kakoune (http://kakoune.org/ and https://github.com/mawww/kakoune)
- kerberos
  - heimdal
    - for static musl libraries, **heimdal** likely needs to be built with:
      - libedit (external, or with its _\-D_ workaround); readline may flake out
      - all DB drivers turned off
      - ncurses, openssl, ?
    - see: http://lists.busybox.net/pipermail/buildroot/2017-July/198737.html
  - mit
- kineto (https://sr.ht/~sircmpwn/kineto/ and https://git.sr.ht/~sircmpwn/kineto - gemini to http gateway/proxy)
- kramdown (markdown, in ruby - https://github.com/gettalong/kramdown)
- larn (short roguelike https://en.wikipedia.org/wiki/Larn_(video_game) - maintained/modern https://github.com/atsb/RL_M)
- ldd
  - driver script
  - run toybox to figure out if musl or glibc and get dyld
  - if static just say so
  - depending on dynamic linker...
    - glibc: ```LD_TRACE_LOADED_OBJECTS=1 /path/to/linker.so /path/to/executable```
    - musl: setup **ldd** symlink to **ld.so**, run ```ldd /path/to/executable```
- lemon (https://www.hwaci.com/sw/lemon/ https://www.sqlite.org/lemon.html https://sqlite.org/src/doc/trunk/doc/lemon.html)
- levee (https://github.com/Orc/levee)
- lf (https://github.com/gokcehan/lf - go)
- libconfig (https://hyperrealm.github.io/libconfig/ and https://github.com/hyperrealm/libconfig)
- libdeflate (https://sortix.org/libdeflate/)
- libdnet (https://github.com/boundary/libdnet or up-to-date fork at https://github.com/busterb/libdnet)
  - mostly want the dnet binary
- libeconf (https://github.com/openSUSE/libeconf)
- libfetch (https://git.alpinelinux.org/aports/tree/main/libfetch?h=3.3-stable and https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/net/libfetch/README.html - alpine, netbsd, needs work)
- libffcall (https://www.gnu.org/software/libffcall/)
- libfuse (https://github.com/libfuse/libfuse - separate userspace? uses meson? `fusermount` needs setuid)
- libiconv (https://www.gnu.org/software/libiconv/)
- libixp (https://github.com/0intro/libixp - 9p client/library)
- libnl-tiny (from sabotage, replacement for big libnl? https://github.com/sabotage-linux/libnl-tiny)
- libpsl (https://github.com/rockdaboot/libpsl https://github.com/publicsuffix/list https://publicsuffix.org/)
- libsigsegv (https://www.gnu.org/software/libsigsegv/)
- libsixel (https://github.com/saitoha/libsixel)
- libslz (http://www.libslz.org/)
- libsodium (https://github.com/jedisct1/libsodium)
- libtap (https://github.com/zorgnax/libtap)
- libtirpc (https://sourceforge.net/projects/libtirpc/ and http://git.linux-nfs.org/?p=steved/libtirpc.git;a=summary)
- libtom
  - libtomcrypt
    - w/libtommath
    - ```make -j${cwmakejobs} PREFIX="${ridir}" CFLAGS="${CFLAGS} -DLTC_CLEAN_STACK -DUSE_LTM -DLTM_DESC -I${cwsw}/libtommath/current/include" EXTRALIBS="-static -L${cwsw}/libtommath/current/lib -ltommath" bins hashsum ltcrypt sizes constants tv_gen test timing install install_bins```
  - libtomfloat
  - libtommath
  - libtompoly
  - tomsfastmath
- libucontext (https://github.com/kaniini/libucontext)
- libudev-zero (https://github.com/illiliti/libudev-zero)
- libunwind (http://www.nongnu.org/libunwind/ and http://savannah.nongnu.org/projects/libunwind)
- libusb (https://github.com/libusb/libusb)
- libutf (https://github.com/cls/libutf)
- libwebsockets (https://libwebsockets.org/)
- libyaml (https://github.com/yaml/libyaml)
- libz (sortix, zlib fork https://sortix.org/libz/)
- lisp stuff
  - aria (https://github.com/rxi/aria - tiny embeddable language)
  - clisp (https://clisp.sourceforge.io/
    - reqs: libsigsegv, libffcall, readline, ncurses
    - configure with ```--without-dynamic-modules``` (and? ```--with-dynamic-ffi```)
    - asm/page.h -> sys/user.h inplace
    - no concurrent make
    - stack size (```ulimit -s```) needs to be at least 16k?
    - _may_ need address randomization disablement? ```setarch linux64 -R make```
    - trouble getting this working at all, maybe not possible/worth it
  - clozure (https://ccl.clozure.com/)
  - cmucl (https://www.cons.org/cmucl/)
  - fe (https://github.com/rxi/fe - tiny embeddable language)
  - gcl (https://www.gnu.org/software/gcl/)
    - reqs: m4, configgit, gmp?
    - needs ```setarch linux64 -R ...``` with proper linux64/linux32 setting before configure, make
    - not sure if this will work either
  - janet (https://janet-lang.org/ and https://github.com/janet-lang/janet)
  - le-lisp (http://christian.jullien.free.fr/lelisp/)
  - lisp500 (http://web.archive.org/web/20070722203906/https://www.modeemi.fi/~chery/lisp500/)
  - mankai common lisp (https://common-lisp.net/project/mkcl/)
  - newlisp (http://www.newlisp.org/ - unnoficial code mirror at https://github.com/kosh04/newlisp)
    - needs libffi, ncurses, readline
    - ```make makefile_build ; sed -i 's/ = gcc$/ = gcc $(CPPFLAGS) $(shell pkg-config --cflags libffi)/g;s/-lreadline/$(LDFLAGS) -lreadline -lncurses/g' makefile_build```
  - picolisp (https://picolisp.com/wiki/?home)
    - picolisp (c, lisp)
    - ersatz picolisp (java)
  - roswell (https://github.com/roswell/roswell)
  - sbcl (http://sbcl.org and https://github.com/sbcl/sbcl)
- llvm / clang
  - this is "complicated," to put it nicely
    - opens up rust, emscripten, zig, etc.
  - something like...
    - build musl static+shared
    - build gcc shared; something like:
      ```
      env C{XX,}FLAGS=-fPIC \
          LDFLAGS= \
          CPPFLAGS= \
          ../configure \
            --enable-languages=c,c++ \
            --prefix=${rbdir}/llvm-stage0 \
            --disable-multilib \
            --disable-lto \
            --disable-libsanitizer \
            --disable-libgomp \
            --host=$(${CC} -dumpmachine) \
            --with-native-system-header-dir=${cwsw}/statictoolchain/current/$(${CC} -dumpmachine)/include
      # may need: --without-headers ...
      ```
    - build llvm with new gcc; something like:
      ```
      env CPPFLAGS= \
          LDFLAGS= \
          C{XX,}FLAGS=-fPIC \
          CC=${rbdir}/llvm-stage0/bin/gcc \
          CXX=${rbdir}/llvm-stage0/bin/g++ \
          cmake .. \
            -D{CMAKE_INSTALL_PREFIX,CMAKE_PREFIX_PATH}=${rbdir}/llvm-stage0 \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_ENABLE_LIBXML2=OFF \
            -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,${rbdir}/llvm-stage0/lib -L${rbdir}/llvm-stage0/lib" \
            -DLLVM_TARGETS_TO_BUILD=X86
      ```
    - build lld with new gcc
    - build clang with new gcc
    - build libc++/libc++abi/compiler-rt with clang?/new gcc?
    - build final dedicated musl with clang?/new gcc?
    - build llvm with clang
    - build lld with clang
    - build libc++/libc++abi/libcompiler-rt with clang
    - build clang with clang
    - final build of all of the above with clang?
    - dynamic linker?
    - `-rpath` settings?
    - lot of questions here
    - criminy...
  - needs:
    - cmake
    - python3
    - gcc needs mpc/mpfr/gmp/isl
    - zlib?
    - ninja (supposedly faster than make)
    - ...
  - links:
    - http://www.linuxfromscratch.org/lfs/view/7.7/chapter05/gcc-pass1.html
    - http://www.linuxfromscratch.org/blfs/view/10.0-systemd/general/llvm.html
    - https://github.com/ziglang/zig/wiki/How-to-build-LLVM,-libclang,-and-liblld-from-source#posix
    - https://llvm.org/docs/GettingStarted.html
    - https://clang.llvm.org/get_started.html
    - https://libcxx.llvm.org/docs/BuildingLibcxx.html
    - https://compiler-rt.llvm.org/
    - https://stackoverflow.com/questions/46905464/how-to-enable-a-llvm-backend
    - https://releases.llvm.org/download.html
    - https://reviews.llvm.org/D34910
- lnav (https://github.com/tstack/lnav)
- lobase (https://github.com/Duncaen/lobase)
  - lobase (https://github.com/ataraxialinux/lobase - fork, updated)
  - lobase-old (https://github.com/ataraxialinux/lobase-old - fork? bsd stuff)
- long-shebang (https://github.com/shlevy/long-shebang)
- lowzip (https://github.com/svaarala/lowzip)
- lrzsz (https://ohse.de/uwe/software/lrzsz.html)
- lua stuff
  - elua (http://www.eluaproject.net/ and https://github.com/elua/elua)
  - lua2c (https://github.com/davidm/lua2c or a fork?)
  - luajit (https://luajit.org/)
  - terra (https://github.com/zdevito/terra and http://terralang.org/)
- mailx (for sus/lsb/etc. - http://heirloom.sourceforge.net/mailx.html)
  - s-nail (https://www.sdaoden.eu/code.html#s-mailx) - up-to-date w/tls (openssl 1.1+) support
  - or gnu mailutils (https://www.gnu.org/software/mailutils/mailutils.html)
- makeself (https://makeself.io/ and https://github.com/megastep/makeself - bin pkgs? with signing?)
- man stuff
  - MANPATH settings
  - roffit (https://daniel.haxx.se/projects/roffit/)
- mandown (https://github.com/Titor8115/mandown - man like markdown, markdown like man?)
- matrixssl (https://github.com/matrixssl/matrixssl)
- mcpp (http://mcpp.sourceforge.net/)
- mercurial / hg
  - need docutils: ```env PATH=${cwsw}/python2/current/bin:${PATH} pip install docutils```
  - config/build/install with: ```env PATH=${cwsw}/python2/current/bin:${PATH} make <all|install> PREFIX=${ridir} CPPFLAGS="${CPPFLAGS}" LDFLAGS="${LDFLAGS//-static/}" CFLAGS='' CPPFLAGS=''```
- merecat (https://github.com/troglobit/merecat)
- mes (https://www.gnu.org/software/mes/) and m2 stuff (links above)
- mesalink (https://mesalink.io/ and https://github.com/mesalock-linux/mesalink)
- mgksh (https://github.com/ibara/mgksh - static ksh and mg (emacs) from openbsd in a single bin)
- mkcert (https://github.com/FiloSottile/mkcert)
- micro (https://micro-editor.github.io/ and https://github.com/zyedidia/micro - go terminal editor)
- micro_httpd (http://acme.com/software/micro_httpd/)
- micro_inetd (http://acme.com/software/micro_inetd/)
- micropython (https://github.com/micropython/micropython)
  - needs python, git, libffi, pkgconfig, make, mbedtls
  - clone repo (single tag, **--depth 1**, **--single-branch**, etc.); i.e., for 1.10:
    - ```git clone -b v1.10 --depth 1 https://github.com/micropython/micropython.git micropython-1.10```
  - init submodules
    - ```git submodule update --force --init```
  - or do both in one step (same syntax for git/jgit.sh)
    - ```jgitsh clone https://github.com/micropython/micropython.git mpblah -b v1.10 --recurse-submodules -v```
  - disable BDB
    - ```sed -i '/^MICROPY_PY_BTREE/s/1/0/' ports/unix/mpconfigport.mk```
  - use mbedtls instead of built-in axtls
    - ```
      sed -i '/^MICROPY_SSL_AXTLS/s/1/0/' ports/unix/mpconfigport.mk
      sed -i '/^MICROPY_SSL_MBEDTLS/s/0/1/' ports/unix/mpconfigport.mk
      ```
  - set CPP and build (static, mbedtls here)
    - ```
      cd ports/unix
      make \
        V=1 \
        CPP="${CC} -E"
        LDFLAGS_EXTRA="-L${cwsw}/mbedtls/current/lib -static" \
        CFLAGS_EXTRA="-I${cwsw}/mbedtls/current/include"
      ```
  - binary will be **ports/unix/micropython**
- minit (https://github.com/chazomaticus/minit - small init with startup/shutdown scripts)
- miniyacc (https://c9x.me/yacc/)
- miniz (zlib, png? needs cmake? https://github.com/richgel999/miniz)
- mk (go, https://github.com/dcjones/mk)
- mg
  - https://github.com/hboetes/mg - tracks openbsd, uses libbsd
    - ```
      export PKG_CONFIG_PATH=${cwsw}/netbsdcurses/current/lib/pkgconfig:${cwsw}/libbsd/current/lib/pkgconfig
      make -f GNUmakefile \
        clean \
        install-strip \
          prefix=${ridir} \
          STRIP=$(which strip) \
          PKG_CONFIG=$(which pkg-config) \
          CPPFLAGS="-I${cwsw}/netbsdcurses/current/include $(pkg-config --cflags libbsd-overlay)" \
          LDFLAGS="-L${cwsw}/netbsdcurses/current/lib -L${cwsw}/libbsd/current/lib" \
          LIBS='-lcurses -lterminfo -lbsd -static' \
          STATIC=yesplease
      ```
  - https://github.com/troglobit/mg - extra features/portability
    - ```
      ./configure \
        --prefix=${ridir} \
          CPPFLAGS="-I${cwsw}/netbsdcurses/current/include" \
          LDFLAGS="-L${cwsw}/netbsdcurses/current/lib -static" \
          LIBS="-lcurses -lterminfo"
      ```
- moreutils (https://joeyh.name/code/moreutils/)
- mosquitto (https://github.com/eclipse/mosquitto and https://mosquitto.org/ - mqtt broker & pub/sub client)
  - tls (openssl) and cjson necessary for minimal secure functionality
  - c-ares (for SRV records) and libwebsockets for full functionality
- mpg123
- mpg321
- mruby (https://github.com/mruby/mruby)
- multimarkdown (https://github.com/fletcher/MultiMarkdown-6)
- musl stuff
  - musl-locales (https://github.com/rilian-la-te/musl-locales - cmake? seriously?)
  - musl-obstack (https://github.com/pullmoll/musl-obstack and/or https://github.com/void-linux/musl-obstack)
  - musl-utils
    - should these be in statictoolchain, i.e in https://github.com/ryanwoodsmall/musl-misc?
    - getconf (https://git.alpinelinux.org/cgit/aports/tree/main/musl/getconf.c)
    - getent (https://git.alpinelinux.org/cgit/aports/tree/main/musl/getent.c)
    - iconv (https://git.alpinelinux.org/cgit/aports/tree/main/musl/iconv.c)
- mutt
- mvi (https://github.com/byllgrim/mvi)
- nc / ncat / netcat
- ne (https://github.com/vigna/ne terminal editor)
- neat/litcave stuff (http://litcave.rudi.ir/)
  - neatcc (https://github.com/aligrudi/neatcc)
  - neatld (https://github.com/aligrudi/neatld)
  - neatas (https://repo.or.cz/neatas.git)
  - neatlibc (https://github.com/aligrudi/neatlibc)
  - neatroff (https://github.com/aligrudi/neatroff)
    - neatroff_make (https://github.com/aligrudi/neatroff_make)
  - neateqn (https://github.com/aligrudi/neateqn)
  - neatpost (https://github.com/aligrudi/neatpost)
  - neatrefer (https://github.com/aligrudi/neatrefer)
  - neatmkfn (https://github.com/aligrudi/neatmkfn)
  - fbpdf (https://github.com/aligrudi/fbpdf)
  - fbvis (https://repo.or.cz/fbvis.git)
  - fbff (https://github.com/aligrudi/fbff)
  - fbpad (https://github.com/aligrudi/fbpad)
  - fbvnc (https://repo.or.cz/fbvnc.git)
- nethack
- netkit (finger, etc. use rhel/centos srpm? http://www.hcs.harvard.edu/~dholland/computers/netkit.html and https://wiki.linuxfoundation.org/networking/netkit)
- netsurf stuff
  - netsurf w/framebuffer nsfb? sdl? vnc doesn't seem to work
  - libnsfb (https://www.netsurf-browser.org/projects/libnsfb/)
- nfs-utils (http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=summary and https://mirrors.edge.kernel.org/pub/linux/utils/nfs-utils/)
- nghttp2 (https://github.com/nghttp2/nghttp2)
- nghttp3 (https://github.com/ngtcp2/nghttp3)
- ngtcp2 (https://github.com/ngtcp2/ngtcp2)
- nnn (https://github.com/jarun/nnn)
- node / npm (ugh)
- noice (https://git.2f30.org/noice/)
- notcurses (https://github.com/dankamongmen/notcurses)
- nq (https://github.com/leahneukirchen/nq)
- nss (ugh)
- num-utils (http://suso.suso.org/programs/num-utils/index.phtml)
- nyacc (https://www.nongnu.org/nyacc/ and https://savannah.nongnu.org/projects/nyacc)
- obase (https://github.com/leahneukirchen/obase - unmaintained, see outils)
- odbc?
  - iodbc?
  - unixodbc?
- odhcploc (http://odhcploc.sourceforge.net/ - dhcp locater)
- oleo (gnu spreadsheet, https://www.gnu.org/software/oleo/oleo.html)
- openbsd-libz (https://github.com/ataraxialinux/openbsd-libz)
- openconnect
- opengit (https://github.com/khanzf/opengit)
- p11-kit (https://p11-glue.github.io/p11-glue/p11-kit.html)
  - probably not...
  - "cannot be used as a static library" - what?
  - needs libffi, libtasn1
  - configure ```--without-libffi --without-libtasn1```
- otools (https://github.com/CarbsLinux/otools - carbs linux openbsd ports)
- parenj / parenjs
- pass (https://www.passwordstore.org/)
- pax
- pciutils (https://github.com/pciutils/pciutils)
  - _/usr/share/misc/pci.ids_ file (https://github.com/pciutils/pciids)
- pdsh (https://github.com/chaos/pdsh or https://github.com/grondo/pdsh ?)
- picocom (https://github.com/npat-efault/picocom)
- pigz
- plan9port (without x11; necessary? already have stripped down suckless 9base)
- planck (clojurescript repl, https://github.com/planck-repl/planck)
- poke (http://www.jemarch.net/poke.html - gnu binary data editor/language)
- prngd (http://prngd.sourceforge.net/ - for lxc? dropbear? old? hmm?)
- procps-ng (https://gitlab.com/procps-ng/procps)
  - needs autoconf, automake, libtool, ncurses, pkgconfig, slibtool
  - disable ```man-po``` and ```po``` **SUBDIRS** in _Makefile.am_
  - ```autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal -I${cwsw}/pkgconfig/current/share/aclocal```
  - ```./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls LIBS=-static LDFLAGS="-L${cwsw}/ncurses/current/lib -static"```
    - ```--disable-modern-top``` for old-style top
  - ```make install-strip LIBTOOL="${cwsw}/slibtool/current/bin/slibtool-static -all-static"```
    - slibtool require should make this automatic
- psmisc
- pty tools
  - updated djb pty/ptyget/ptybandage/ptyrun/...
  - https://unix.stackexchange.com/questions/249723/how-to-trick-a-command-into-thinking-its-output-is-going-to-a-terminal
  - http://jdebp.eu./Softwares/djbwares/bernstein-ptyget.html
  - https://github.com/drudru/pty4 and https://github.com/drudru/ptyget
  - http://code.dogmap.org./ptyget/
  - nosh/execline?
    - http://skarnet.org./software/execline/
    - http://jdebp.eu./Softwares/nosh/
- pup (https://github.com/ericchiang/pup)
- ragel (http://www.colm.net/open-source/ragel/)
- ranger (https://ranger.github.io - python)
- rawtar (https://github.com/andrewchambers/rawtar)
- re2c (http://re2c.org/ and https://github.com/skvadrik/re2c)
- redir (https://github.com/troglobit/redir)
- redo-c (https://github.com/leahneukirchen/redo-c - djb's redo concept implemented in c instead of python)
- regx (https://github.com/wd5gnr/regx - regx and litgrep, literate regex)
- relational-pipes (https://relational-pipes.globalcode.info/)
- remake (http://bashdb.sourceforge.net/remake/ and https://github.com/rocky/remake)
- retro (forth, http://retroforth.org/)
- rredir (https://github.com/rofl0r/rrredir)
- rover (https://lecram.github.io/p/rover)
- rpcbind (https://sourceforge.net/projects/rpcbind/ and http://git.linux-nfs.org/?p=steved/rpcbind.git;a=summary)
- rpcsvc-proto (https://github.com/thkukuk/rpcsvc-proto)
- rust (https://www.rust-lang.org/)
  - bootstrap? (https://guix.gnu.org/blog/2018/bootstrapping-rust/ - guix!)
  - mrustc (https://github.com/thepowersgang/mrustc - c++)
  - rust-gcc (https://rust-gcc.github.io/ and https://github.com/Rust-GCC/gccrs)
  - rustup (https://rustup.rs/)
- rvm?
- rw (https://sortix.org/rw/)
- rwc (https://github.com/leahneukirchen/rwc)
- sacc (https://git.fifth.space/sacc/log.html - gopher client)
- samurai (https://github.com/michaelforney/samurai)
- sbang (https://github.com/spack/sbang)
- scdoc (https://sr.ht/~sircmpwn/scdoc/ and https://git.sr.ht/~sircmpwn/scdoc - simple man page generator)
- scheme stuff:
  - bigloo
  - chez (scheme, https://github.com/cisco/ChezScheme - utillinux (uuid), ncurses, disable x11)
  - chibi-scheme (https://github.com/ashinn/chibi-scheme)
  - chicken (https://www.call-cc.org)
  - elk (http://sam.zoy.org/elk)
  - femtolisp (https://github.com/JeffBezanson/femtolisp)
  - gerbil (https://cons.io/ and https://github.com/vyzo/gerbil)
  - ikarus (https://en.wikipedia.org/wiki/Ikarus_(Scheme_implementation))
    - https://github.com/lambdaconservatory/ikarus
    - shared, no static
    - gmp, libffi, pkgconfig, probably configgit
    - configure with... ```./configure --prefix=${ridir} CPPFLAGS="${CPPFLAGS} $(pkg-config --cflags libffi)" CFLAGS="${CFLAGS//-Wl,-static}" LDFLAGS="${LDFLAGS//-static/}"```
  - ksi (http://ksi.sourceforge.net/)
    - gmp, gc
  - larceny (and petit larceny, http://larcenists.org)
  - micro-lisp (https://github.com/carld/micro-lisp)
  - minilisp (https://github.com/rui314/minilisp)
  - minischeme
    - https://github.com/ignorabimus/minischeme
  - mit/gnu scheme (requires gnu/mit scheme... to build... itself)
  - mosh (https://github.com/higepon/mosh and http://mosh.monaos.org/files/doc/text/About-txt.html)
  - oaklisp (https://github.com/barak/oaklisp)
  - racket
  - rscheme (http://www.rscheme.org/rs)
  - s7 (https://ccrma.stanford.edu/software/snd/snd/s7.html)
  - scheme2c (https://github.com/barak/scheme2c)
  - scm (http://people.csail.mit.edu/jaffer/SCM.html)
  - sigscheme (https://github.com/uim/sigscheme)
  - siod (http://people.delphiforums.com/gjc//siod.html)
  - slib (http://people.csail.mit.edu/jaffer/SLIB.html)
  - stalin (w/debian patches? https://github.com/barak/stalin)
  - stklos (http://www.stklos.net/)
  - tinyscheme
    - https://github.com/linneman/tinyscheme
    - https://github.com/sungit/TinyScheme
    - https://github.com/ignorabimus/tinyscheme
    - other forks/branches?
  - tisp (https://github.com/edvb/tisp)
  - umb-scheme
  - vicare (ikarus fork-of-fork, https://github.com/barak/vicare)
  - ypsilon (http://www.littlewingpinball.net/mediawiki/index.php/Ypsilon)
- sc-im (https://github.com/andmarti1424/sc-im - sc spreadsheet improved)
- sdbm (https://github.com/jaydg/sdbm - dbm/ndbm alike, updated for modern systems)
- sed-bin (https://github.com/lhoursquentin/sed-bin - posix sed to c??? cool)
- selfdock (https://github.com/anordal/selfdock - container alike)
- shells?
  - es (https://github.com/wryun/es-shell)
  - fish
  - gash (guile as shell, https://savannah.nongnu.org/projects/gash/)
  - ksh2020 (https://github.com/ksh2020/ksh - figure out this vs ast ksh93/forks/etc.)
  - ksh93 (https://github.com/ksh93/ksh - actually fixing things in ksh93u)
  - ksh93 (https://github.com/ksh-community/ksh or https://github.com/jelmd/ksh)
    - AT&T AST fork
    - uses old AST build system which is pretty much a non-starter on musl
    - for now anyway
    - no updates whatsoever, this isn't a serious fork
  - mrsh (https://mrsh.sh/ - https://git.sr.ht/~emersion/mrsh and https://github.com/emersion/mrsh)
    - imrsh (https://git.sr.ht/~sircmpwn/imrsh - interactive mrsh)
  - rc (muennich's rakitzis fork https://github.com/muennich/rc)
  - scsh (https://scsh.net)
  - sh (https://github.com/mvdan/sh - shell parser/formatter in go)
  - tcsh (and/or standard csh)
  - xs (https://github.com/TieDyedDevil/XS - rc+es+scheme/lisp)
  - zsh
- shellcheck (https://www.shellcheck.net/ and https://github.com/koalaman/shellcheck - haskell)
- shuffle (http://savannah.nongnu.org/projects/shuffle/)
- simplecpp (https://github.com/danmar/simplecpp)
- sljit (http://sljit.sourceforge.net/)
- sloccount (https://dwheeler.com/sloccount/)
- snarf (https://www.xach.com/snarf/ - old but small, still useful?)
- source-highlight (https://www.gnu.org/software/src-highlite/)
  - 2.x, 3.x require boost (yeeee), ctags
  - ```./configure --prefix=${ridir} --enable-static{,=yes} --enable-shared=no --disable-shared --with-boost-libdir=${cwsw}/boost/current/lib LDFLAGS="${LDFLAGS} -L${cwsw}/boost/current/lib" CXXFLAGS="${CXXFLAGS} -I${cwsw}/boost/current/include"```
  - ```source-highlight --out-format esc256 --output STDOUT --input blah.cpp | less -R```
- spidermonkey
- spidernode
- sparse (https://sparse.wiki.kernel.org/index.php/Main_Page)
- splint (https://en.wikipedia.org/wiki/Splint_(programming_tool))
- spm (https://notabug.org/kl3/spm/ - password manager, fork of tpm)
- sprite (https://github.com/ibara/sprite - curses sprite editor, libpng export support!)
- squashfs-tools (https://github.com/plougher/squashfs-tools/tree/master/squashfs-tools)
- srv (https://github.com/joshuarli/srv)
- sshuttle (https://github.com/sshuttle/sshuttle)
- sslh (https://www.rutschle.net/tech/sslh/README.html and https://www.rutschle.net/tech/sslh/README.html)
- sslwrap (http://www.rickk.com/sslwrap/ way old)
- subversion / svn
  - needs apr/apr-util (easy) and serf (uses scons, needs fiddling)
- suckless
  - quark (https://tools.suckless.org/quark/)
  - sinit (https://core.suckless.org/sinit/)
- sudo (https://www.sudo.ws/)
  - require `slibtool` for static build
  - configuration, ugh
  - really only useful in container?
  - ```
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-log-server \
      --disable-nls \
      --with-env-editor \
      --without-pam \
      --without-skey \
      --sysconfdir=${cwtop}/var/etc \
      --localstatedir=${cwtop}/var \
      --disable-shared-libutil \
      --enable-static-sudoers
    ```
- sundown (markdown lib - https://github.com/vmg/sundown)
- svi (https://github.com/byllgrim/svi)
- tab (https://tkatchev.bitbucket.io/tab/)
- taskwarrior (https://taskwarrior.org/ and https://github.com/GothenburgBitFactory/taskwarrior)
- taskserver (https://github.com/GothenburgBitFactory/taskserver)
- timewarrior (https://timewarrior.net/ and https://github.com/GothenburgBitFactory/taskwarrior)
- t3x.org stuff (nils holm)
  - klisp (http://t3x.org/klisp)
  - s9fes (https://www.t3x.org/s9fes https://github.com/bakul/s9fes and https://github.com/barak/scheme9)
  - subc (https://www.t3x.org/subc)
- tcc (http://repo.or.cz/w/tinycc.git)
  - static compilation is _pretty broken_
- tidy (https://github.com/htacg/tidy-html5 - cmake)
- tinyproxy (https://tinyproxy.github.io/ and https://github.com/tinyproxy/tinyproxy)
- tinyssh (https://tinyssh.org and https://github.com/janmojzis/tinyssh)
- tnftpd (ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/)
- torgo (https://github.com/as/torgo)
- tpm (https://github.com/nmeum/tpm/ - tiny password manager)
- tre (https://github.com/laurikari/tre)
- tsocks
- ttyd (https://github.com/tsl0922/ttyd - gotty in c, like shellinabox w/xterm.js, libwebsockets, uses cmake)
- ttynvt (https://gitlab.com/lars-thrane-as/ttynvt - network virtual terminal, needs fuse)
- twtxt stuff
  - htwtxt (https://github.com/plomlompom/htwtxt - twtxt server)
  - twtxt (https://github.com/buckket/twtxt - minimal text based microblogging)
  - twtxtc (https://hub.darcs.net/dertuxmalwieder/twtxtc - c client)
  - txtnish (https://github.com/mdom/txtnish - minimal client)
- txt2tags (https://github.com/txt2tags/txt2tags)
- tzdb (https://www.iana.org/time-zones)
- u9fs (https://github.com/unofficial-mirror/u9fs - 9p filesystem (or one of the forks))
  - https://github.com/sevki/u9fs - can turn off rhosts auth? need ~rpc bits otherwise
- uacme (https://github.com/ndilieto/uacme)
- ublinter (https://github.com/danmar/ublinter)
- udptunnel (http://www.cs.columbia.edu/~lennox/udptunnel/)
- uftpd (https://github.com/troglobit/uftpd)
- unfs3 (https://unfs3.github.io/ and https://github.com/unfs3/unfs3)
- uniso (from alpine https://github.com/alpinelinux/alpine-conf/blob/master/uniso.c)
- units (https://www.gnu.org/software/units)
- upx (https://github.com/upx/upx)
- uredir (https://github.com/troglobit/uredir)
- u-root (https://github.com/u-root/u-root - go userland w/bootloaders, may be useful!)
- usbutils (https://github.com/gregkh/usbutils)
- utalk (http://utalk.ourproject.org/)
- vde (virtual distributed ethernet, https://github.com/virtualsquare/vde-2)
- vera / vera++ (bitbucket? github?)
- vifm (https://github.com/vifm/vifm)
- vpnc
  - **vpnc-script** needs to ignore unknown "via ??? ???" output from ```ip route```
  - **config.c** needs proper **vpnc-script** and **default.conf** paths
- wasmer (https://github.com/wasmerio/wasmer - cross-platform webassembly binaries everywhere)
- webcat (https://git.sr.ht/~rumpelsepp/webcat - go, see https://rumpelsepp.org/blog/ssh-through-websocket/)
- websocat (https://github.com/vi/websocat - rust)
- websocketd (go, https://github.com/joewalnes/websocketd)
- websockify (https://github.com/novnc/websockify)
- whatshell.sh (https://www.in-ulm.de/~mascheck/various/whatshell/ and https://www.in-ulm.de/~mascheck/various/whatshell/whatshell.sh)
- wolfssh (https://github.com/wolfSSL/wolfssh)
- wordgrinder (https://github.com/davidgiven/wordgrinder - word processor)
- wrp (https://github.com/tenox7/wrp - web rendering proxy)
- wsServer (https://theldus.github.io/wsServer/ and https://github.com/Theldus/wsServer - websocket server in c)
- xe (https://github.com/leahneukirchen/xe)
- xq (https://github.com/jeffbr13/xq)
- xserver-sixel (https://github.com/saitoha/xserver-sixel)
- yq (https://github.com/kislyuk/yq)
- ytalk (http://ytalk.ourproject.org/)
- z3 (https://github.com/Z3Prover/z3)
  - cppcheck can use/may require this for 2.x+
- zork (https://github.com/devshane/zork - it's zork dude)
- support libraries for building the above
- whatever else seems useful

## deprecated/broken recipes

- bsdheaders (https://github.com/bonsai-linux/bsd-headers - from bonsai linux, workaround DECLS for cdefs.h)
  - upstream repo went missing
- opennc (openbsd netcat http://systhread.net/coding/opennc.php)
  - site regularly goes offline, use netcatopenbsd instead


<!--
# vim: ft=markdown
-->
