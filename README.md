# crosware
Tools, things, stuff, miscellaneous, detritus, junk, etc., primarily for Chrome OS / Chromium OS. This is a development-ish environment for Chrome OS on both ARM and x86 (32-bit and 64-bit for both). It should work on "normal" Linux too (Armbian, CentOS, Debian, Raspbian, Ubuntu, etc.).

## bootstrap

If running on a Chromebook/Chromebox/ChromeOS/Flex machine, **developer mode is necessary**.
_crosware_ temporarily requires `root` access to set ownership and permission in `/usr/local`.

To bootstrap, using ```/usr/local/crosware``` with initial downloads in ```/usr/local/tmp```...

# :warning: On ChromeOS `sudo` must be run via a virtual terminal :warning:

Google, in their infinite wisdom, has disabled `sudo` on ChromeOS.
Or, rather, disabled gaining extra privileges in the current process (`PR_SET_NO_NEW_PRIVS`/`minijail`/???).
This effectively stops `root` user access via the ChromeOS GUI.

This means the `sudo` commands below must be run via a VT.

- To access a VT, press one of the following key sequences:
  - Ctrl-Alt-right arrow (F2)
  - Ctrl-Alt-refresh (F3)
  - Ctrl-Alt-full screen (F4)
- Login as `chronos` either with no password, or with a dev password (if you set one)
- Run the `sudo ...` commands below
- Return to the ChromeOS GUI with Ctrl-Alt-back arrow (F1)

If you want to start a locally-accessible SSH daemon, see: [scripts/start-root-sshd](scripts/start-root-sshd).

```shell
# check you're the chronos user on a chromebook/not root in a container
whoami

# allow your regular user to write to /usr/local
sudo chgrp ${GROUPS} /usr/local
sudo chmod 2775 /usr/local
```

The sudo commands above only need to be run once; it should be safe to run them again.
If you choose to use the [scripts/start-root-sshd](scripts/start-root-sshd) script, it must be run after every reboot.

The following can now be run as the standard ChromeOS user _chronos_ from a GUI/`crosh` shell terminal.

```shell
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

# automatically update the environment after an install
`${cwtop}/scripts/tcrs jo`
which -a jo
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
  list-installed-reqs : list installed recipes with their requirements
  list-recipe-deps : list recipes with their declared dependencies
  list-recipe-files : list recipes with their source file
  list-recipe-reqs : list recipes with their requirements
  list-recipe-reqs-expanded : list recipes with their expanded requirements
  list-recipes : list build recipes
  list-recipe-transitive-reqs : list recipes with only transitive requirements
  list-recipe-versions : list recipes with version number
  list-upgradable : list installed packages with available upgrades
  profile : show .profile addition
  reinstall : uninstall then install given packages without chasing upgrades
  run-func : run crosware shell function
  set : run 'set' to show full crosware environment
  show-arch : show kernel and userspace architecture
  show-env : run 'env' to show crosware environment
  show-func : show the given function name
  show-karch : show kernel architecture
  show-uarch : show userspace architecture
  uninstall : uninstall some packages
  update : attempt to update existing install of crosware
  update-list-upgradable : update crosware and list upgradable recipes
  update-upgrade-all : update crosware and upgrade out-of-date recipes
  upgrade : uninstall then install a recipe
  upgrade-all : upgrade all packages with different recipe versions
  upgrade-all-with-deps : upgrade all out-of-date packages and installed dependents
  upgrade-deps : upgrade any installed deps of a package
  upgrade-with-deps : upgrade a package and installed depdendents
</pre>

### a few more examples

See the [scripts/](scripts/) directory for a hodge-podge of stuff.

```shell
# works anywhere - for use system-wide on a normal non-chromeos linux distro (non-root users only)
sudo ln -sf /usr/local/crosware/scripts/etc-profile-dot-d_crosware.sh /etc/profile.d/zz-crosware.sh

# works anywhere - remove dev bits ({C,LD,...}FLAGS, etc.) from the environment
# also move crosware paths to the end of ${PATH}
# facilitates "i just want the command" installs
. /usr/local/crosware/etc/profile
. ${cwtop}/scripts/non-interactive.sh

# chromeos only - when using the scripts/start-root-sshd script
# for sudossh (non-interactive) and sudossht (terminal) command wrappers
sudo ln -sf /usr/local/crosware/scripts/usr-local-bin-sudossh /usr/local/bin/sudossh
sudo ln -sf /usr/local/crosware/scripts/usr-local-bin-sudossht /usr/local/bin/sudossht

# chromeos only? - obsolete on chromeos but good to note anyway
# wrap sudo to be passwordless with a trust-on-first-use approach
# this is (well, was) useful for dev-mode chromebooks with a chronos user password set
. /usr/local/crosware/scripts/passwordless-sudo.sh
```

#### use external or disable java and jgit

A few user environment variables are available to control how crosware checks itself out and updates recipes.

| var               | default | purpose                                        |
| ----------------- | ------- | ---------------------------------------------- |
| CW_GIT_CMD        | jgitsh  | which "git" command to use for checkout/update |
| CW_USE_JAVA       | true    | use java for bootstrap, jgit                   |
| CW_EXT_JAVA       | false   | use system java instead of zulu recipe         |
| CW_USE_JGIT       | true    | use jgit.sh for checkout/update                |
| CW_EXT_JGIT       | false   | use system jgit.sh instead of jgitsh recipe    |
| CW_UPDATE_USE_GIT | true    | use a git client to update                     |
| CW_UPDATE_USE_ZIP | true    | use `update-crosware-from-zip.sh` to update    |
| CW_IGNORE_MISSING | false   | set to "true" ot ignore any missing prereqs    |

#### alpine

Alpine (https://alpinelinux.org/) uses musl libc (http://musl-libc.org) and as such cannot use the Zulu JDK as distributed. To bootstrap using the system-supplied OpenJDK from Alpine repos:

```shell
# as above, make sure /usr/local is writable by the primary user/group you'll be using...
# this assumes you're using the default busybox ash shell, and running apk as root...
export CW_EXT_JAVA=true
apk update
apk upgrade
apk add bash curl openjdk11
cd /tmp
curl -kLO https://raw.githubusercontent.com/ryanwoodsmall/crosware/master/bin/crosware
bash crosware bootstrap
# or, using bash process substitution...
#   bash -c 'export CW_EXT_JAVA=true ; bash <(curl -kLs https://raw.githubusercontent.com/ryanwoodsmall/crosware/master/bin/crosware) bootstrap'
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

This is a _mostly_ self-hosting virtual Linux distribution of sorts, targeting all variations of 32-/64-bit x86 and ARM on Chrome OS, installable on other Linux distributions independently - with **riscv64** support as well.
The primary aim of _crosware_ is to be a small - for some definition of small - and "as statically-linked as possible" development environment aimed at containers and ChromeOS, but also piggybacking on virtually any distribution that has a persistent `/usr/local` with write permissions.

A static-only GCC compiler using [musl libc](https://musl.libc.org/) (with [musl-cross-make](https://github.com/richfelker/musl-cross-make.git) ) is installed as part of the bootstrap; this sort of precludes things like emacs, but doesn't stop anyone from using the static musl toolchain to build a shared toolchain and libraries, bootstrap another compiler, leverage Alpine packages, etc..
Despite having "static" in the name, a `libc.so` (and `ld.so`, normally a symlink to musl's libc) is available and leveraged for a number packages, primarily to support other programming languages' linking modes and plugin/shared object strategies.

The initial bootstrap looks something like:

- scripted, i.e., `crosware bootstrap`:
  - get a JDK (Azul Zulu OpenJDK for glibc)
  - get jgit.sh (standalone)
  - get static bootstrapped compiler
  - checkout rest of project
- manually install some packages, i.e, `crosware install vim git ...`:
  - build GNU make
  - build native busybox, toolbox, sed, etc.
  - build a few libs / support (ncurses, openssl, slang, zlib, bzip2, lzma, libevent, pkg-config)
  - build a few packages (curl, vim w/syntax hightlighting, screen, tmux, links, lynx - mostly because I use them)

Some scripts that might be use for bootstrapping on a non-glibc distro:

- [scripts/install-static-bins.sh](scripts/install-static-bins.sh)
- [scripts/update-crosware-from-tar.sh](scripts/update-crosware-from-tar.sh) (or [scripts/update-crosware-from-zip.sh](scripts/update-crosware-from-zip.sh) )
- [scripts/install-musl-zulu.sh](scripts/install-musl-zulu.sh)
- [scripts/reconstitute-git.sh](scripts/reconstitute-git.sh)

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

See [the to-do list (TODO.md)](TODO.md)

See [the maybe file (MAYBE.md)](MAYBE.md) for recipes to consider, notes, etc.

# links

Chromebrew looks nice and exists now: https://github.com/skycocker/chromebrew

Alpine and Sabotage are good sources of inspiration and patches:

- Alpine: https://alpinelinux.org/ and git: https://git.alpinelinux.org/
- Sabotage: http://sabotage.tech/ and git: https://github.com/sabotage-linux/sabotage/

The Alpine folks distribute a chroot installer:

- https://github.com/alpinelinux/alpine-chroot-install

And I wrote a little quick/dirty Alpine chroot creator that works on Chrome/Chromium OS; no Docker or other software necessary.

- https://github.com/ryanwoodsmall/shell-ish/blob/master/bin/chralpine.sh

The musl wiki has some pointers on patches and compatibility, and a list of useful alternative implementations of common programs/libraries/utilities/etc.;
many are in use in crosware:

- https://wiki.musl-libc.org/compatibility.html#Software-compatibility,-patches-and-build-instructions
- https://wiki.musl-libc.org/alternatives.html

## bootstrapping ex nihilo

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
  - https://github.com/oriansj/bootstrap-seeds
- https://lists.gnu.org/archive/html/guile-user/2016-06/msg00061.html
- https://lists.gnu.org/archive/html/guile-user/2017-07/msg00089.html
- http://lists.gnu.org/archive/html/info-gnu/2018-08/msg00006.html

## other sites/utilities/etc.

Suckless has a list of good stuff:

- https://suckless.org/rocks/

Mark Williams Company open sourced Coherent; might be a good source for SUSv3/SUSv4/POSIX stuff:

- http://www.nesssoftware.com/home/mwc/source.php

9p implementations:

- http://9p.cat-v.org/implementations

Eltanin tools may be useful:

- https://eltan.in.net/?tools/index
- https://github.com/eltanin-os

Busybox tiny utility notes:

- https://busybox.net/tinyutils.html

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
    - https://github.com/ryanwoodsmall/crosware/blob/master/scripts/build-statictoolchain.sh

## working recipes

- 9pro (https://git.sr.ht/~ft/9pro - 9p tools for unix)
- abcl (common lisp, https://common-lisp.net/project/armedbear/)
- abduco (https://www.brain-dump.org/projects/abduco/ and https://github.com/martanne/abduco)
- acl (https://savannah.nongnu.org/projects/acl/)
- acme labs programs (via http://www.acme.com/software/)
  - httpget (http://www.acme.com/software/http_get/)
    - httpgetlibressl (libressl https support)
    - httpgetopenssl (openssl https support)
  - httppost (http://www.acme.com/software/http_post/)
    - httppostlibressl (libressl https support)
    - httppostopenssl (openssl https support)
  - microhttpd (http://acme.com/software/micro_httpd/)
  - microinetd (http://acme.com/software/micro_inetd/)
  - microproxy (http://acme.com/software/micro_proxy/)
  - minihttpd (http://www.acme.com/software/mini_httpd/)
    - minihttpdlibressl (libressl https support)
    - minihttpdopenssl (openssl https support)
  - minisendmail (http://www.acme.com/software/mini_sendmail/)
  - subproxy (http://www.acme.com/software/sub_proxy/)
  - thttpd (http://www.acme.com/software/thttpd/)
- ag (https://geoff.greer.fm/ag/ and https://github.com/ggreer/the_silver_searcher - the silver searcher, fast grep/ack-like)
- age (https://github.com/FiloSottile/age - age encryption tool in go)
- alpinemuslutils (https://github.com/alpinelinux/aports/tree/master/main/musl - getconf, getent, iconv from alpine's musl)
- argon2 (https://github.com/P-H-C/phc-winner-argon2 - password hashing program and libargon2 library)
- at (http://ftp.debian.org/debian/pool/main/a/at/)
- attr (https://savannah.nongnu.org/projects/attr/)
- autoconf
- automake
- baseutils (https://github.com/ibara/baseutils - portable openbsd userland)
- bash (latest 5.x, netbsdcurses)
  - bashminimal (latest 5.x, internal readline, no curses/termcap)
  - bashtiny (latest 5.x, no readline/curses/termcap)
  - bash4 (4.4, netbsdcurses)
  - bash50 (5.0, netbsdcurses)
  - bash51 (5.1, netbsdcurses)
  - bashtermcap (termcap.h, libtermcap.a from bash, etc/termcap from gnu termcap)
- bc (gnu bc, dc)
- bdb185 (berkeley db 1.85)
- bdb47 (berkeley db 4.x)
- beanshell2 (https://github.com/beanshell/beanshell and https://beanshell.github.io - java scripting, leaving beanshell open for 3.x...)
- bearssl (https://bearssl.org/)
- bim (https://github.com/klange/bim - minimal vim-alike, pure-C version 2.x)
  - bim3 (kuroko-based editor)
- binutils (bfd, opcodes, libiberty.a)
- bison (https://www.gnu.org/software/bison/ and http://savannah.gnu.org/projects/bison/ and http://git.savannah.gnu.org/cgit/bison.git)
  - bison37 (older version before some possible posix-mandated breaking changes)
- bmake (http://www.crufty.net/help/sjg/bmake.html)
- brogue
- brotli (https://github.com/google/brotli)
- bsd programs
  - bsdjot (from outils)
  - bsdrs (from outils)
  - bsdunvis (from outils)
  - bsdvis (from outils)
- busybox (static)
- byacc
- bzip2
- cacertificates (from alpine)
- cadaver (https://notroj.github.io/cadaver/ and https://github.com/notroj/cadaver - cli webdav client using neon - openssl+expat+readline)
  - cadavergnutls (gnutls)
  - cadavergnutlsminimal (gnutls + nettle w/mini-gmp)
  - cadaverlibressl (libressl)
- cares (https://github.com/c-ares/c-ares and https://c-ares.haxx.se/ - c-ares, asynch dns, must explicitly opt-in)
- ccache - version 3.x, autotools
  - ccache4 - now requires cmake, keep them separate for now
- certstrap (https://github.com/square/certstrap - simple CA in go)
- cflow
- check
- cjson (https://github.com/DaveGamble/cJSON)
- cloc (https://github.com/AlDanial/cloc)
- cmake
- colorizedlogs (https://github.com/kilobyte/colorized-logs and https://launchpad.net/ubuntu/+source/colorized-logs - includes ansi2txt/ansi2html/ttyrec2ansi/pipetty)
- configgit (gnu config.guess, config.sub updates for musl, aarch64, etc. http://git.savannah.gnu.org/gitweb/?p=config.git;a=summary)
- coreutils (single static binary with symlinks, no nls/attr/acl/gmp/pcap/selinux)
- corkscrew (http://wiki.kartbuilding.net/index.php/Corkscrew_-_ssh_over_https and http://web.archive.org/web/20160207093437/http://agroman.net/corkscrew/ - ssh over http/socks)
- cppcheck
- cppi
- cpu (https://github.com/u-root/cpu - plan 9-like cpu - "push" local filesystem/program to remote, execute - in go, works like ssh+9p)
  - p9ufs (https://github.com/hugelgupf/p9 - standalone go 9p fileserver, included in u-root/gobusybox)
  - smbiosdmidecode (https://github.com/u-root/smbios - go dmidecode)
  - uroot (https://github.com/u-root/u-root - go userland w/bootloaders and other amenities)
    - also contains...
      - gobusybox (https://github.com/u-root/gobusybox - a general-purpose wrapper to create a `bb` binary with a number of go cmd/... sources)
      - mkuimage (https://github.com/u-root/mkuimage - small go-based cpio root filesystems)
- cronolog (https://linux.die.net/man/1/cronolog - version 1.6.2 with fedora largefile patch)
- cryanc (https://github.com/classilla/cryanc - crypto ancienne, tls for old platforms, provides "carl" binary with client+proxy)
- cscope
- cssc (gnu sccs)
- ctags (exuberant ctags for now, universal ctags a better choice?)
- curl (https://curl.se/ - openssl)
  - curlbearssl
  - curlgnutls
  - curlgnutlsminimal (with nettleminimal/mini-gmp)
  - curllibressl
  - curlmbedtls
  - curlwolfssl
  - caextract (https://curl.haxx.se/docs/caextract.html - mozilla ca certs in .pem format)
- cvs
- cwstaticbinaries (https://github.com/ryanwoodsmall/static-binaries - static binaries, possibly useful for bootrapping?)
- cxref
- dasel (https://github.com/TomWright/dasel - select/put/delete/convert data from json/toml/yaml/xml/csv)
- dash (http://gondor.apana.org.au/~herbert/dash/ and https://git.kernel.org/pub/scm/utils/dash/dash.git)
  - dashminimal (libedit with basic termcap)
  - dashtiny (no libedit)
- ddrescue (https://www.gnu.org/software/ddrescue/ - gnu data recovery tool/nicer dd)
- derby
- diffutils
- diction and style (https://www.gnu.org/software/diction/)
- direvent (https://www.gnu.org.ua/software/direvent/direvent.html - gnu directory event monitoring daemon)
- distcc (https://distcc.github.io/ and https://github.com/distcc/distcc - minimal build, no pump, libiberty, avahi, etc.)
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
- doctl (https://github.com/digitalocean/doctl and https://docs.digitalocean.com/reference/doctl/ - digital ocean api control program)
- dropbear (https://matt.ucc.asn.au/dropbear/dropbear.html and https://dropbear.nl/ - zlib, lsh sftp-server - tcp port 2222)
  - dropbearminimal (zlib - tcp port 22222)
- dsvpn (https://github.com/jedisct1/dsvpn - dead simple vpn)
- dtach (https://github.com/crigler/dtach and http://dtach.sourceforge.net/ - simpler detachable screenalike)
- duktape (http://duktape.org/ and https://github.com/svaarala/duktape)
- dvtm (https://www.brain-dump.org/projects/dvtm/ and https://github.com/martanne/dvtm/)
- e2fsprogs (https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/ and http://e2fsprogs.sourceforge.net/ and https://github.com/tytso/e2fsprogs)
- ecl (https://common-lisp.net/project/ecl/)
  - shared build
  - works for aarch64/i686/x86_64
  - does _not_ work on arm (gc? gmp?)
- ed (gnu ed)
- elfutils (https://sourceware.org/elfutils/ - library and utilities for dealing with elf files, including some binutils workalikes(?) - ar, nm, ranlib, strings, strip, etc.)
- elinks (https://github.com/rkd77/elinks - up-to-date/maintained elinks fork, currently only minimal variant)
  - elinksminimal (libressl, zlib)
  - investigate adding tre, spidermonkey/mujs/quickjs javascript/ecmascript/js, ...
- elvis (https://github.com/mbert/elvis)
- entr (http://entrproject.org/ and https://github.com/eradman/entr)
- es (https://github.com/wryun/es-shell - extensible shell, descended from plan9/rc, with scheme/lisp/other functional programming additions)
- etcd (https://etcd.io/ and https://github.com/etcd-io/etcd)
- ethtool (https://mirrors.edge.kernel.org/pub/software/network/ethtool/)
- expat
- fennel (https://fennel-lang.org/ and https://github.com/bakpakin/Fennel - a lisp that compiles to lua, with a dedicated shared lua install and readline support via luarocks)
- fetchfreebsd (https://github.com/jrmarino/fetch-freebsd - freebsd fetch program/fetch.h header/libfetch.a lib, openssl, custom compilation instead of cmake)
  - fetchfreebsdlibressl (same with libressl)
- file
- findutils
- flex
- gambit (https://github.com/gambit/gambit and http://gambitscheme.org/wiki/index.php/Main_Page)
  - look at openssl/libressl
- gauche (https://github.com/shirok/Gauche and https://practical-scheme.net/gauche/index.html)
  - shared build
  - sdbm (ndbm) kv/hash, zlib, mbedtls, libressl for `openssl` command
- gawk (gnu awk, prepended to $PATH, becomes default awk)
- gc (working on x86\_64, aarch64; broken on i386, arm)
- gdbm
- gettexttiny
- ghostunnel (https://github.com/ghostunnel/ghostunnel - stunnel-ish in go, with mutual tls auth)
- git - built with curl+openssl
  - gitlibressl - built with libressl+curl
- github tools
  - gh (https://github.com/cli/cli and https://cli.github.com/ - gh command in go with release management...)
  - hub (https://github.com/github/hub and https://hub.github.com - git wrapper)
- glab (https://gitlab.com/gitlab-org/cli - gitlab glab cli)
- glib (https://wiki.gnome.org/Projects/GLib)
  - old version
  - new version requires meson, ninja, thus python3
- global
- glorytun (https://github.com/angt/glorytun - udp tunnel using libsodium)
  - uses mud (https://github.com/angt/mud - multipath udp lib)
  - docker container example: https://github.com/angt/mudock
- gmp
- gnupg (with ntbtls - https://gnupg.org/software/index.html)
  - gnupg1 (gnupg 1.x - older, smaller gnupg version, with fewer prereqs)
- gnutls (https://gnutls.org/)
  - gnutlsminimal (built against nettleminimal w/mini-gmp, openssl compat enabled)
- gpgme (https://gnupg.org/software/gpgme/index.html - gnupg access library)
- go
  - go recipe is latest available version
  - verions
    - gobootstrap recipe with 1.4 bootstrap binaries (i386, amd64, arm, arm 32-bit static for aarch64)
    - go117 recipe with golang 1.17.x static binaries for all supported architectures
    - go118 recipe with golang 1.18.x static binaries for all supported architectures
    - go119 recipe with golang 1.19.x static binaries for all supported architectures
    - go120 recipe with golang 1.20.x static binaries for all supported architectures
    - go121 recipe with golang 1.21.x static binaries for all supported architectures
    - go122 recipe with golang 1.22.x static binaries for all supported architectures
    - go123 recipe with golang 1.23.x static binaries for all supported architectures
  - static binary archive
  - built via: https://github.com/ryanwoodsmall/go-misc/blob/master/bootstrap-static/build.sh
- gogit (https://github.com/go-git/go-git - `go-git` cli with `git-{receive,upload}-pack` wrappers)
- gojq (https://github.com/itchyny/gojq - jq in go)
- goldy (https://github.com/ibm-security-innovation/goldy - dtls to udp proxy using mbedtls)
- got (https://gameoftrees.org/ - game of trees, openbsd-specific git-like, libressl)
  - gotopenssl recipe provided as well
  - portable: https://gameoftrees.org/portable.html
  - supports git, ssh, git+ssh protocols - no http/https
  - has a tig-like `tog` program, nice!
- gotoml (https://github.com/pelletier/go-toml - toml processing/conversion with jsontoml/tomljson/tomll)
- goyq (https://github.com/mikefarah/yq - yq implementation in go)
- grep (gnu grep)
- groff
- gosftpserver (https://github.com/pkg/sftp - standalone `sftp-server` that works with tinysshd/dropbear from go sftp lib)
- guile (https://www.gnu.org/software/guile/)
  - works for aarch64/x86_64
  - does _not_ work on arm/i686 (gc)
  - guile2 recipe as well, with same caveats
- h2 (http://www.h2database.com/ and https://github.com/h2database/h2database - java embedded/client-server db with postgres compat mode)
- habitat (https://community.chef.io/tools/chef-habitat)
  - single static `hab` binary
- haproxy (http://www.haproxy.org/ - openssl+pcre+zlib)
  - haproxylibressl (libressl+pcre+zlib)
- hboetesmg (https://github.com/hboetes/mg - micro gnuemacs, libbsd+netbsdcurses)
- heirloom project tools (http://heirloom.sourceforge.net/ - musl/static changes at https://github.com/ryanwoodsmall/heirloom-project)
  - exvi with netbsdcurses also available as a standalone package
- helm (https://helm.sh/ and https://github.com/helm/helm - kubernetes package manager)
- help2man
- hitch (https://hitch-tls.org/ - openssl+libev tls proxy)
- hsqldb (http://hsqldb.org/ - java hypersql database, followup to hypersonicsql, with `sqltool` client)
  - http://www.hsqldb.org/doc/2.0/guide/running-chapt.html
  - http://www.hsqldb.org/doc/2.0/guide/listeners-chapt.html
- htermutils (https://chromium.googlesource.com/apps/libapps/+/HEAD/hterm/etc/)
- htop
- ibaramg (https://github.com/ibara/mg - openbsd mg editor)
- iftop
- inetutils
- indent
- inih (https://github.com/benhoyt/inih - .ini file parser in C, using ninja+meson)
- iperf
  - iperf
  - iperf3
- isl
- itsatty (https://github.com/ryanwoodsmall/itsatty)
- j7zip
- janet (https://janet-lang.org/ and https://github.com/janet-lang/janet)
- jansson (https://github.com/akheron/jansson and https://digip.org/jansson/ - C json support, used by nftables)
- jfrogcli (https://github.com/jfrog/jfrog-cli and https://jfrog.com/help/r/jfrog-cli/jfrog-cli - jfrog cli for e.g. artifactory)
- jgitsh (bootstrap recipe)
  - jgitsh6 (java 11)
  - jgitsh7 (java 17)
- jo (https://github.com/jpmens/jo)
- jq (https://stedolan.github.io/jq/ - with oniguruma regex)
- jruby
- jscheme
- jython
- k0s (https://github.com/k0sproject/k0s and https://docs.k0sproject.io/ - lens' small k8s distribution)
- k0sctl (https://github.com/k0sproject/k0sctl - bootstrapping/management for k0s nodes)
- k3s (https://k3s.io/ and https://github.com/k3s-io/k3s - small k8s distribution)
- kawa (scheme)
- kernelheaders (https://github.com/sabotage-linux/kernel-headers - from sabotage linux)
- kind (https://kind.sigs.k8s.io/ - k8s in docker, pure go)
- ksh93 (https://github.com/ksh93/ksh - up-to-date/patched at&t ksh93 with ast build system)
- kubernetes (binaries)
  - kubectllatest (kubectl only)
- kuroko (https://kuroko-lang.github.io/ and https://github.com/kuroko-lang/kuroko - small python-like dynamic language)
- less (netbsdcurses)
  - lessminimal (stripped down with small gnu termcap from bash)
- lftp (https://lftp.yar.ru/)
- libarchive (https://github.com/libarchive/libarchive and https://www.libarchive.org/ - libarchive.a, bsdtar/bsdcpio/bsdcat, gz/bz2/lzo/lz4/lzma/iso9660 fs/... support)
- libassuan (https://gnupg.org/software/libassuan/index.html)
- libatomicops
- libbsd
- libcap (https://mirrors.edge.kernel.org/pub/linux/libs/security/linux-privs/libcap2/)
- libcapng (https://people.redhat.com/sgrubb/libcap-ng/ and https://github.com/stevegrubb/libcap-ng - posix capabilities lib)
- libconfig (https://hyperrealm.github.io/libconfig/ and https://github.com/hyperrealm/libconfig)
- libconfuse (https://github.com/libconfuse/libconfuse)
- libedit (https://www.thrysoee.dk/editline/ - aka editline, from netbsd, line editing, history, etc., ncurses)
  - libeditminimal (stripped down standalone libedit + small gnu termcap, from bash)
  - libeditnetbsdcurses (same, with netbsdcurses)
  - need a few symlinks for compat w/readline: https://github.com/sabotage-linux/sabotage/blob/master/pkg/libedit
- libev (http://software.schmorp.de/pkg/libev.html)
- libevent (no openssl support yet)
- libffi
- libgcrypt (https://gnupg.org/software/libgcrypt/index.html)
- libgit2
- libgpgerror (https://gnupg.org/software/libgpg-error/index.html)
- libidn (https://www.gnu.org/software/libidn/)
- libidn2 (https://www.gnu.org/software/libidn/#libidn2)
- libixp (https://github.com/0intro/libixp - ixpc - 9p client/library)
- libksba (https://gnupg.org/software/libksba/index.html)
- libmd (https://www.hadrons.org/software/libmd/)
- libnl
- liboop (https://www.lysator.liu.se/liboop/)
- libpcap (https://www.tcpdump.org/ and https://www.tcpdump.org/release/ - packet capture library)
  - libpcap19 (older version for compatibility? with iftop? i dunno)
- libpsl (https://github.com/rockdaboot/libpsl & https://github.com/publicsuffix/list & https://publicsuffix.org/ - libidn2+libunistring, python3)
- libressl (https://www.libressl.org/)
  - libressl37 (old but default version that's still currently the current default by default, currently, until i can update to 3.8/3.9)
  - libressl38
  - libressl39
- libretls (https://git.causal.agency/libretls/about/ - libtls from libressl on top of openssl)
- libssh2 (openssl, zlib)
  - libssh2libgcrypt (gcrypt, zlib)
  - libssh2libressl (libressl, zlib)
  - libssh2mbedtls (mbedtls, zlib)
  - libssh2wolfssl (wolfssl via osp open source project port, zlib)
- libsodium (https://github.com/jedisct1/libsodium)
- libtasn1 (https://ftp.gnu.org/gnu/libtasn1/)
- libtirpc (https://sourceforge.net/projects/libtirpc/ and http://git.linux-nfs.org/?p=steved/libtirpc.git;a=summary)
- libtlsbearssl (https://github.com/michaelforney/libtls-bearssl - a standards-based tls lib implemented on top of bearssl)
- libtom
  - libtomcrypt (https://www.libtom.net/LibTomCrypt/ and https://github.com/libtom/libtomcrypt)
  - libtommath (https://www.libtom.net/LibTomMath/ and https://github.com/libtom/libtommath)
- libtool
- libuargp (https://github.com/xhebox/libuargp - argp-standalone alternative w/argp_parse)
- libucontext (https://github.com/kaniini/libucontext - glibc compat ucontext, opt-in)
- libunistring (https://ftp.gnu.org/gnu/libunistring/)
- libuv (https://github.com/libuv/libuv)
- libxml2 (https://gitlab.gnome.org/GNOME/libxml2)
  - libxml2minimal (no features)
- libxo (https://github.com/Juniper/libxo and http://juniper.github.io/libxo/libxo-manual.html - html/json/xml output lib and xo cli)
- libxslt (https://gitlab.gnome.org/GNOME/libxslt)
  - libxsltminimal (no features, built against libxml2minimal)
- libz (sortix, zlib fork https://sortix.org/libz/ - static and shared libs for compatibility with alpine/musl bins)
- lighttpd (https://www.lighttpd.net/ - mbedtls - ssl/tls, webdav support)
  - lighttpdminimal (zlib, pcre2, libbsd - not tls, webdav, etc.)
- linenoise (https://github.com/antirez/linenoise)
- links (http://links.twibright.com/ - openssl)
  - linkslibressl (libressl)
- lmdb (https://github.com/LMDB/lmdb and https://symas.com/lmdb/ - lighting memory-mapped database, dummy profile.d for now)
- loksh (https://github.com/dimkr/loksh)
- lsh (https://www.lysator.liu.se/~nisse/lsh/ - version 2.0, 2.1 has issues with separate/new nettle)
  - lshsftpserver (`sftp-server` binary only for e.g. dropbear, tinyssh, ...)
- lua (http://www.lua.org/ - 5.x release, may change! posix, no readline)
  - lua54 (posix, barebones)
  - lua53 (posix, barebones)
  - lua52 (posix, barebones)
  - lua51 (posix, barebones)
- lynx (https://lynx.invisible-island.net/ - ncurses, openssl)
  - lynxlibressl (ncurses, libressl)
  - lynxnetbsdcurses (netbsdcurses, openssl)
  - lynxnetbsdcurseslibressl (netbsdcurses, libressl)
  - lynxnetbsdcursesslang (netbsdcurses slang, openssl)
  - lynxnetbsdcursesslanglibressl (netbsdcurses slang, libressl)
  - lynxslang (ncurses slang, openssl)
  - lynxslanglibressl (ncurses slang, libressl)
  - lynxminimal (slang with tiny termcap, libressl)
- lz4 (https://github.com/lz4/lz4)
- lzo (http://www.oberhumer.com/opensource/lzo)
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
  - lts
    - mbedtls2
      - mbedtls228
    - mbedtls3
      - mbedtls36
  -compat
    - mbedtls216
- meson (http://mesonbuild.com/)
- mg (https://github.com/troglobit/mg - micro gnuemacs, netbsdcurses)
  - mgminimal (no curses/terminfo/termcap, optimized for size)
- microsocks (https://github.com/rofl0r/microsocks)
- miller (https://github.com/johnkerl/miller - miller, aka mlr, awk/sed/grep/jq/... for csv, etc.)
  - miller5 (mlr, old version in c)
  - miller6 (mlr, reimplemented in go)
- minikube (https://minikube.sigs.k8s.io/)
- minio (https://github.com/minio/minio and https://min.io - s3-compatible object store)
  - miniomc (https://github.com/minio/mc - minio `mc` client)
  - docs: https://min.io/docs/minio/linux/index.html
- minischeme (https://github.com/catseye/minischeme)
- mksh (http://www.mirbsd.org/mksh.htm)
- mosquitto (https://github.com/eclipse/mosquitto and https://mosquitto.org/ - mqtt broker & pub/sub client - openssl/cjson/c-ares)
  - mosquittolibressl (libressl/cjson/c-ares)
  - mosquittonotls (insecure/cjson/c-ares - no tls/ssl, INSECURE, plaintext, small, blah blah blah)
- most (https://www.jedsoft.org/most/)
  - mostnetbsdcurses (built with netbsdcurses terminfo and bundled slang)
- mpc
- mpfr
- mtm (https://github.com/deadpixi/mtm - micro terminal multiplexer)
- mujs (http://mujs.com/ and https://github.com/ccxvii/mujs)
- muon (https://github.com/annacrombie/muon and https://muon.build/ - meson-alike in c, use with samurai (ninja) and pkgconf (pkg-config))
- muslfts (https://github.com/pullmoll/musl-fts)
- muslobstack (https://github.com/void-linux/musl-obstack - glibc obstack+some libiberty macros for musl)
- muslstandalone (http://musl.libc.org/ - unbundled musl libc and kernel headers with musl-gcc wrapper, possibly different version from statictoolchain)
  - musl11 (musl 1.1.x for compat)
  - musl12 (musl 1.2.x with `oldmalloc` for compat)
- n2n (https://github.com/ntop/n2n and https://www.ntop.org/products/n2n/ - peer-to-peer vpn with edge and supernodes for nat traversal - openssl/zstd/libcap/libpcap)
  - n2nlibressl (libressl and zstd only, no libcap or libpcap)
  - n2nminimal (no optional features)
- nashorn (https://github.com/openjdk/nashorn and https://openjdk.org/projects/nashorn - barebones, standalone "jjs" javascript shell, no readline support/jrunscript/etc.)
- nbsdgames (https://github.com/abakh/nbsdgames - new bsd games)
- ncurses
- neat/litcave stuff (http://litcave.rudi.ir/)
  - neatvi (https://github.com/aligrudi/neatvi)
- nebula (https://github.com/slackhq/nebula - mesh network overlay/vpn)
- neofetch (https://github.com/dylanaraps/neofetch - terminal machine/os info)
- neon (https://notroj.github.io/neon/ and https://github.com/notroj/neon - http/webdav library with openssl+expat)
  - neongnutls (gnutls)
  - neongnutlsminimal (gnutls + nettle w/mini-gmp)
  - neonlibressl (libressl)
- netbsdcurses (libedit, readline, slang bundled - **manual** CPPFLAGS/LDFLAGS for now - sabotage https://github.com/sabotage-linux/netbsd-curses)
- netbsdwtf (https://github.com/void-linux/netbsd-wtf - "wtf" acronym finder from netbsd)
- netcatopenbsd (from debian, https://salsa.debian.org/debian/netcat-openbsd)
- netfilter.org stuff (WIP!!!)
  - conntracktools (https://www.netfilter.org/projects/conntrack-tools/)
  - iptables (https://www.netfilter.org/projects/iptables/)
  - libmnl (https://www.netfilter.org/projects/libmnl/)
  - libnetfilteracct (https://www.netfilter.org/projects/libnetfilter_acct/)
  - libnetfilterconntrack (https://www.netfilter.org/projects/libnetfilter_conntrack/)
  - libnetfiltercthelper (https://www.netfilter.org/projects/libnetfilter_cthelper/)
  - libnetfiltercttimeout (https://www.netfilter.org/projects/libnetfilter_cttimeout/)
  - libnetfilterlog (https://www.netfilter.org/projects/libnetfilter_log/)
  - libnetfilterqueue (https://www.netfilter.org/projects/libnetfilter_queue/)
  - libnfnetlink (https://www.netfilter.org/projects/libnfnetlink/)
  - libnftnl (https://www.netfilter.org/projects/libnftnl/)
  - nfacct (https://www.netfilter.org/projects/nfacct/index.html)
  - nftables (https://www.netfilter.org/projects/nftables/)
- netsurf libraries
  - libparserutils (https://www.netsurf-browser.org/projects/libparserutils/)
  - libwapcaplet (https://www.netsurf-browser.org/projects/libwapcaplet/)
  - libhubbub (https://www.netsurf-browser.org/projects/hubbub/)
  - libdom (https://www.netsurf-browser.org/projects/libdom/)
  - libcss (https://www.netsurf-browser.org/projects/libcss/)
- nettle (http://www.lysator.liu.se/~nisse/nettle/ and https://git.lysator.liu.se/nettle/nettle)
  - nettleminimal (opt-in, standalone; bundled mini-gmp)
- nextvi (https://github.com/kyx0r/nextvi - "next" version/fork of neatvi with some extra features/simplifications)
- nghttp2 (https://github.com/nghttp2/nghttp2)
- nginx (https://nginx.org/ - openssl and njs support)
  - nginxlibressl (libressl and njs support)
  - njs (http://nginx.org/en/docs/njs/index.html - nginx javascript cli tool, njs with libedit shell, libressl crypto)
  - njsopenssl (njs with libedit shell, openssl crypto)
  - njsquickjs (njs with libedit shell, libressl crypto and quickjs, with `-n QuickJS` cli support)
  - njsminimal (njs with libedit shell, no crypto)
  - njstiny (njs with no libedit shell, no crypto, no cli)
- ninja (https://ninja-build.org/)
- nmap
- npt (https://github.com/nptcl/npt and https://nptcl.github.io/npt/docs/md/ - ansi common lisp implementation, terme display/repl)
  - nptreadline (npt with netbsdcurses+readline)
- npth (https://gnupg.org/software/npth/index.html)
- ntbtls (https://gnupg.org/software/ntbtls/index.html)
- nvi (via debian, https://salsa.debian.org/debian/nvi)
- nvi179 (4bsd release from keith bostic, https://sites.google.com/a/bostic.com/keithbostic/vi)
- oksh (https://github.com/ibara/oksh - netbsdcurses)
  - okshsmall (limited prereqs, no curses/history support)
- onetrueawk (https://github.com/onetrueawk/awk - the one true awk)
- oniguruma (https://github.com/kkos/oniguruma)
- openconnect (https://www.infradead.org/openconnect and https://gitlab.com/openconnect/openconnect - cisco/juniper/etc. vpn client, openssl)
  - openconnectgnutls (gnutls)
  - openconnectgnutlsminimal (gnutls+nettle w/mini-gmp)
  - includes default `vpnc-script` (https://www.infradead.org/openconnect/vpnc-script.html and https://gitlab.com/openconnect/vpnc-scripts)
- opendoas (https://github.com/Duncaen/OpenDoas - much simpler "doas" sudo replacement)
- opennc (openbsd netcat - formerly http://systhread.net/coding/opennc.php)
  - see netcatopenbbsd for bsd netcat as packaged by debian
  - see libressl for tls-enabled `nc` command
- openssh (openssl, netbsdcurses, libedit, zlib)
  - opensshminimal (no openssl, built-in auth/key/cipher/mac/... only, netbsdcurses, libedit, zlib)
  - opensshlibressl (libressl, netbsdcurses, libedit, zlib)
  - opensshwolfssl (patches from wolfssl osp project - netbsdcurses, libedit, zlib)
- openssl
  - openssl111 (deprecated lts version, still default. whoops)
  - openssl30 (current lts version)
- openvpn (https://openvpn.net/community-downloads/ and https://github.com/OpenVPN/openvpn - openssl, zlib, lz4, lzo)
  - openvpnlibressl (libressl, lz4, lzo)
  - openvpnmbedtls (mbedtls, lz4, lzo)
  - openvpnwolfssl (wolfssl, lz4, lzo)
- opkg (https://git.yoctoproject.org/opkg - WIP .ipk package manager, libarchive/curl/openssl/gnupg/gpgme)
- otools (https://github.com/CarbsLinux/otools - carbs linux openbsd ports)
- outils (https://github.com/leahneukirchen/outils - utils from openbsd, including jot/rs/vis/unvis/etc.)
- p7zip
- par (http://www.nicemice.net/par/ and https://bitbucket.org/amc-nicemice/par/src/master/)
- pass (https://www.passwordstore.org/)
- patch (gnu)
- patchelf (https://nixos.org/patchelf.html and https://github.com/NixOS/patchelf)
- paxmirabilis (http://www.mirbsd.org/pax.htm - pax/tar/cpio from mirbsd)
- pcc (http://pcc.ludd.ltu.se/)
  - only x86_64 for now!
  - kinda painful for static compilation, segfaults, etc.
  - not sure on `crt?.o` files either
  - uses muslstandalone as libc
- pcre
- pcre2
- pdpmake (https://github.com/rmyorston/pdpmake - public domain posix make)
- perl
- pinentry (curses via ncurses, tty)
- pixman (http://www.pixman.org/ and https://www.cairographics.org/releases/)
- pkgconfig
- plan9port (https://github.com/9fans/plan9port - without gui/x11; suckless 9base available and much smaller)
  - plan9port9p (9p, 9pfuse standalone binaries from plan9port)
- posixstandard (https://pubs.opengroup.org/onlinepubs/9699919799/download/index.html - posix/sus (single unix specification) docs for personal use)
- ppp (https://github.com/ppp-project/ppp - paul's ppp package, static minimal pppd+chat, no pcap/tls/peap/eap/...)
  - ppplibressl (libressl, pcap, plugins - shared)
  - pppopenssl (openssl, pcap, plugins - shared)
- pv (http://www.ivarch.com/programs/pv.shtml and https://github.com/a-j-wood/pv - pv pipe viewer pipeviewer)
- px5g (https://github.com/openwrt/openwrt/tree/master/package/utils/px5g-mbedtls - mbedtls cert/key gen program)
  - px5gwolfssl (https://github.com/openwrt/openwrt/tree/master/package/utils/px5g-wolfssl - px5g built with wolfssl)
- python
  - python2 (very basic support)
  - python3 (wip)
- qemacs (https://bellard.org/qemacs/)
- qemuuser (https://www.qemu.org/ - linux userspace only for now)
- quickjs (https://bellard.org/quickjs/)
- rc (https://github.com/muennich/rc - netbsdcurses+readline, fork of tobold+rakitzis rc, basic Makefile)
  - rc174 (http://tobold.org/article/rc, https://github.com/rakitzis/rc - ncurses+readline, needs to be git hash, old release)
- rclone (https://rclone.org and https://github.com/rclone/rclone - rsync for cloud/sftp/etc., go, union mounts?)
- rcs (gnu)
- readline (https://tiswww.case.edu/php/chet/readline/rltop.html - terminal command history, completion, etc., ncurses)
  - readlinenetbsdcurses (same, netbsdcurses)
- reflex (https://invisible-island.net/reflex/reflex.html)
- retawq (http://retawq.sourceforge.net/ - text-mode windowed network/web browser, ncurses and openssl)
  - retawqlibressl (ncurses, libressl)
- rhino
- rlwrap (netbsdcurses)
  - rlwrapminimal (stripped down with small gnu termcap from bash)
- rogue
- rpcsvcproto (https://github.com/thkukuk/rpcsvc-proto - contains rpcgen)
- rrredir (https://github.com/rofl0r/rrredir)
- rsync (https://rsync.samba.org/)
  - rsyncminimal (fewer deps, smaller, but lower performance)
- samurai (https://github.com/michaelforney/samurai - small ninja alternative in c)
- sc (from debian, https://packages.debian.org/buster/sc)
- scheme48 (http://s48.org)
- scm (http://people.csail.mit.edu/jaffer/SCM.html and http://people.csail.mit.edu/jaffer/SLIB.html - scm scheme with slib library)
  - slib (https://people.csail.mit.edu/jaffer/SLIB - standalone slib for easier integration in other schemes; gambit/gauche/guile/kawa/scheme48/sisc/...)
- screen (https://www.gnu.org/software/screen - terminal multiplexer, netbsdcurses)
  - screenminimal (limited functionality using bash libtermcap)
- sdbm (https://github.com/jaydg/sdbm - dbm/ndbm alike, updated for modern systems, with ndbm.h and libndbm.a symlinks)
- sdkman (http://sdkman.io)
- sed (gnu gsed, prepended to $PATH, becomes default sed)
- sharutils (https://www.gnu.org/software/sharutils/)
- shellbench (https://github.com/shellspec/shellbench)
- shellinabox (https://github.com/shellinabox/shellinabox)
- shellish (https://github.com/ryanwoodsmall/shell-ish - some random texts from my script bucket)
- simh (system simulator - currently opensimh)
  - opensimh (https://github.com/open-simh/simh - fork/further development of simh 3+4?)
  - simh3 (http://simh.trailing-edge.com - classic simh 3.x)
  - simh4 (https://github.com/simh/simh - system simulator...?)
- sisc (scheme)
- slang (https://www.jedsoft.org/slang/ - s-lang programmers library, ncurses)
  - slangnetbsdcurses (same, netbsdcurses)
  - slangminimal (only tiny termcap from bash)
- slibtool (https://github.com/midipix-project/slibtool)
- slip tools (full slattach, etc.)?
- slirp???
- slsc (jedsoft "sc" console spreadsheet for slang)
- socat (http://www.dest-unreach.org/socat/ - openssl, netbsdcurses, readline)
  - socatlibressl (libressl, netbsdcurses, readline)
  - socatminimal (no tls/ssl, no readline - socket, port, file, etc. *only*)
  - socatwolfssl (https://github.com/wolfSSL/osp - from wolfssl open source project ports with readline support)
- source-highlight (https://www.gnu.org/software/src-highlite/)
  - OLD 1.x version
  - limited language support, though
- strace (https://strace.io/ and https://github.com/strace/strace)
- stunnel (https://www.stunnel.org/ - openssl)
  - stunnellibressl (libressl build)
- sqlite
- sslh (https://www.rutschle.net/tech/sslh/README.html and https://www.rutschle.net/tech/sslh/README.html - ssl/protocol multiplexer, with libconfig/pcre2/libcap support)
  - sslhminimal (no libcap/capabilities support)
  - sslhtiny (zero features, no capabilities, config file or regex support)
- suckless
  - 9base (https://tools.suckless.org/9base)
  - sbase (https://core.suckless.org/sbase)
  - ubase (https://core.suckless.org/ubase)
- svnkit
- sysklogd (https://github.com/troglobit/sysklogd - bsd syslog on linux, newer rfc compliant)
- tea (https://gitea.com/gitea/tea - gitea cli)
- termcap (https://www.gnu.org/software/termutils/ - old standalone gnu termcap library)
- termutils (https://www.gnu.org/software/termutils/ - tabs and tput)
- tetrisbsd (https://github.com/sirjofri/tetris-bsd)
- texinfo (untested, requires perl)
- tig (https://github.com/jonas/tig - console git repo pager/browser/ui, ncurses)
  - tignetbsdcurses (same, netbsdcurses with builtin termcap)
- tinc (https://www.tinc-vpn.org/ - meshed routing compressed/encrypted vpn, openssl+zlib+lzo)
  - tinclibressl (same, with libressl instead of openssl)
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
- tinycurl (https://curl.se/tiny/ - curl but smaller, focus on http/https)
  - tinycurlbearssl (bearssl, zlib, nghttp2)
  - tinycurllibressl (libressl, libssh2, zlib, nghttp2)
  - tinycurlmbedtls (mbedtls, libssh2, zlib, nghttp2)
  - tinycurlopenssl (openssl, libssh2, zlib, nghttp2)
  - tinycurlwolfssl (wolfssl, libssh2, zlib, nghttp2)
  - tinycurl779
    - tinycurl779bearssl (bearssl, zlib, nghttp2)
    - tinycurl779libressl (libressl, libssh2, zlib, nghttp2)
    - tinycurl779mbedtls (mbedtls, libssh2, zlib, nghttp2)
    - tinycurl779openssl (openssl, libssh2, zlib, nghttp2)
    - tinycurl779wolfssl (wolfssl, libsshw, zlib, nghttp2)
  - tinycurl772
    - tinycurl772bearssl (bearssl, zlib, nghttp2)
    - tinycurl772libressl (libressl, libssh2, zlib, nghttp2)
    - tinycurl772mbedtls (mbedtls, libssh2, zlib, nghttp2)
    - tinycurl772openssl (openssl, libssh2, zlib, nghttp2)
    - tinycurl772wolfssl (wolfssl, libsshw, zlib, nghttp2)
  - babycurl (mbedtls, libssh2, zlib)
  - babycurlwolfssl (wolfssl, libssh2, zlib)
  - picocurl (bearssl, zlib)
    - picocurlmbedtls (mbedtls, zlib, libssh2)
- tinyemu (https://bellard.org/tinyemu/ - risc-v 32/64, risc-v 128 on x86_64/aarch64, x86 w/kvm on x86_64/i686; openssl/curl support, no sdl)
  - tinyemulibressl (libressl/curl, no sdl)
- tinyproxy (https://tinyproxy.github.io/ and https://github.com/tinyproxy/tinyproxy)
- tinyscheme (http://tinyscheme.sourceforge.net/home.html)
- tinyssh (https://tinyssh.org and https://github.com/janmojzis/tinyssh - small, pubkey/ed25519, ssh server only)
- tio (https://tio.github.io and https://github.com/tio/tio)
- tmux (https://github.com/tmux/tmux - terminal multiplexer)
- tmuxmisc (https://github.com/ryanwoodsmall/tmux-misc - couple of scripts i use)
- tnftp (ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/)
- tnftpd (ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/ and https://en.wikipedia.org/wiki/Tnftp - formerly lukemftp)
- toybox (static)
- tree (http://mama.indstate.edu/users/ice/tree/)
  - tree1 (tree version 1.x, compatible with pass release 1.7.4)
  - tree2 (tree version 2.x)
- troglobit stuff
  - editline (https://github.com/troglobit/editline)
  - inadyn (https://github.com/troglobit/inadyn - dynamic dns updater, openssl)
    - inadyngnutls (gnutls)
    - inadyngnutlsminimal (gnutlsminimal built with nettleminimal/mini-gmp)
    - inadynlibressl (libressl)
    - inadynmbedtls (mbedtls)
  - libuev (https://github.com/troglobit/libuev)
  - mdnsd (https://github.com/troglobit/mdnsd - multicast dns daemon, mdsresponder, mdns-sd, etc.)
  - mg (see above)
  - minisnmpd (https://github.com/troglobit/mini-snmpd and https://troglobit.com/projects/mini-snmpd/)
  - redir (https://github.com/troglobit/redir)
  - sntpd (https://github.com/troglobit/sntpd - ntp client/server/...)
  - uredir (https://github.com/troglobit/uredir)
- txt2man (https://github.com/mvertes/txt2man - plain text to man page converter?)
- u9fs (https://github.com/Plan9-Archive/u9fs - userspace 9p server, recently updated, works without rhosts stuff)
  - no auth serve w/busybox or toybox: `tcpsvd -E -v 0.0.0.0 564 ./u9fs -D -z -a none -u username /path/to/share`
  - access from remote host w/plan 9 from user space: `9p -a 'tcp!hostname.domain.name!564' ls /`
  - **plan9port9p** recipe provides `9p` client
  - **libixp** recipe provides `ixpc` 9p client
- uacme (https://github.com/ndilieto/uacme - standalone acme/letsencrypt client in c, curl+openssl)
  - uacmelibressl (curl+libressl)
  - uacmegnutls (curl+gnutls)
  - uacmegnutls (curl+gnutlsminimal built with nettleminimal/mini-gmp)
  - uacmembedtls (curl+mbedtls)
- uemacs (https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git/ - micro-emacs)
- unfs3 (https://unfs3.github.io/ and https://github.com/unfs3/unfs3)
- unrar
- unzip
- utillinux
- uucp (https://www.airs.com/ian/uucp.html and https://www.gnu.org/software/uucp/)
- vile (https://invisible-island.net/vile/)
- vim (https://github.com/vim/vim and https://www.vim.org/ - ncurses, with syntax highlighting, which chrome/chromium os vim lacks)
  - vimminimal (termcap lib and database from bash and gnu termcap, no scripting w/lua, no encryption w/libsodium, ...)
  - vimnetbsdcurses (netbsdcurses)
- vultrcli (https://github.com/vultr/vultr-cli - vultr-cli program)
- w3m (https://github.com/tats/w3m)
- wget (https://www.gnu.org/software/wget/ - openssl)
  - wgetgnutls (gnutls variant)
  - wgetgnutlsminimal (gnutls variant with nettleminimal/mini-gmp)
  - wgetlibressl (libressl instead of openssl)
- wget2 (https://www.gnu.org/software/wget/ - openssl)
  - wget2gnutls (full gnutls variant)
  - wget2gnutlsminimal (minimal gnutls with nettleminimal/mini-gmp)
  - wget2libressl (libressl)
  - wget2wolfssl (wolfssl)
- wireguard (https://www.wireguard.com/)
  - wgctrlgo (https://github.com/WireGuard/wgctrl-go - wireguard interface control program in go)
  - wireguardgo (https://git.zx2c4.com/wireguard-go - userspace wireguard go client)
  - wireguardtools (https://git.zx2c4.com/wireguard-tools - wireguard wg and wg-quick tools)
- wolfmqtt (https://www.wolfssl.com/products/wolfmqtt/ and https://github.com/wolfSSL/wolfMQTT - tls-enabled mqtt lib and examples for wolfssl)
- wolfssh (https://www.wolfssl.com/products/wolfssh/ and https://github.com/wolfSSL/wolfssh - ssh lib and examples for wolfssl)
- wolfssl (https://www.wolfssl.com/ and https://github.com/wolfSSL/wolfssl - formerly cyassl)
- x509cert (https://git.sr.ht/~mcf/x509cert and https://github.com/michaelforney/x509cert - bearssl cert/request utility)
- xinetd (https://github.com/openSUSE/xinetd forked from https://github.com/xinetd-org/xinetd)
- xmlstarlet (http://xmlstar.sourceforge.net/)
- xvi (http://martinwguy.github.io/xvi/)
- xxhash (https://github.com/Cyan4973/xxHash)
- xz (https://tukaani.org/xz/)
- yash (http://yash.osdn.jp/ and https://github.com/magicant/yash - yash posix shell, with arrays; netbsdcurses+libedit)
  - yashminimal (no line editing)
- yaegi (https://github.com/traefik/yaegi - go interpreter in go!)
- yj (https://github.com/sclevine/yj - yaml/toml/json/hcl converter in go)
- ynetd (https://github.com/johnsonjh/ynetd and https://yx7.cc/code/ - minimal tcp/inetd server)
- zip
- zlib
- zlibng (https://github.com/zlib-ng/zlib-ng - fork with vector support, compiled static ~and shared~ with `libz.a` compat lib ~and `libz.so.1`~ created as well)
- zstd (https://github.com/facebook/zstd)
- zulu - built-in recipe, glibc-based for bootstrapping (chrome os, centos, debian, ubuntu, ...)
  - zulu8glibc - zulu 8 jdk
  - zulu11glibc - zulu 11 jdk
  - zulu17glibc - zulu 17 jdk
  - zulu8musl - zulu 8 jdk built against musl libc (x86_64, aarch64 only)
  - zulu11musl - zulu 11 jdk built against musl libc (x86_64, aarch64 only)
  - zulu17musl - zulu 17 jdk built against musl libc (x86_64, aarch64 only)
  - zulu21musl - zulu 21 jdk built against musl libc (x86_64, aarch64 only)

## deprecated/broken/disabled recipes

- bsdheaders (https://github.com/bonsai-linux/bsd-headers - from bonsai linux, workaround DECLS for cdefs.h)
  - upstream repo went missing
- (old) ksh93 (https://github.com/att/ast/ via at&t ast)
  - actually ksh2020
  - dormant
- libmetalink (https://github.com/metalink-dev/libmetalink)
  - supported only in wget, which tries to bring in gpgme and its assorted deps; easier to remove for now

<!--
# vim: ft=markdown
-->
