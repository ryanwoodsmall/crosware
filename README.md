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
  - https://github.com/oriansj/bootstrap-seeds
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
  - bash50 (5.1, netbsdcurses)
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
  - bsdjot (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?jot+1)
  - bsdrs (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?rs+1)
  - bsdunvis (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?unvis+1)
  - bsdvis (from netbsd - https://netbsd.gw.com/cgi-bin/man-cgi?vis+1)
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
- dash (http://gondor.apana.org.au/~herbert/dash/ and https://git.kernel.org/pub/scm/utils/dash/dash.git)
  - dashminimal (libedit with basic termcap)
  - dashtiny (no libedit)
- ddrescue (https://www.gnu.org/software/ddrescue/ - gnu data recovery tool/nicer dd)
- derby
- diffutils
- diction and style (https://www.gnu.org/software/diction/)
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
- elinks (http://elinks.or.cz/ from git: https://repo.or.cz/elinks.git)
  - investigate adding tre, spidermonkey javascript/ecmascript/js, ...
- elvis (https://github.com/mbert/elvis)
- entr (http://entrproject.org/ and https://github.com/eradman/entr)
- es (https://github.com/wryun/es-shell - extensible shell, descended from plan9/rc, with scheme/lisp/other functional programming additions)
- etcd (https://etcd.io/ and https://github.com/etcd-io/etcd)
- ethtool (https://mirrors.edge.kernel.org/pub/software/network/ethtool/)
- expat
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
  - static binary archive
  - built via: https://github.com/ryanwoodsmall/go-misc/blob/master/bootstrap-static/build.sh
- gojq (https://github.com/itchyny/gojq - jq in go)
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
- libressl (https://www.libressl.org/)
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
- libucontext (https://github.com/kaniini/libucontext - glibc compat ucontext, opt-in)
- libunistring (https://ftp.gnu.org/gnu/libunistring/)
- libuv (https://github.com/libuv/libuv)
- libxml2
- libxo (https://github.com/Juniper/libxo and http://juniper.github.io/libxo/libxo-manual.html - html/json/xml output lib and xo cli)
- libxslt
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
  - mbedtls216
- meson (http://mesonbuild.com/)
- mg (https://github.com/troglobit/mg - micro gnuemacs, netbsdcurses)
  - mgminimal (no curses/terminfo/termcap, optimized for size)
- microsocks (https://github.com/rofl0r/microsocks)
- miller (https://github.com/johnkerl/miller - miller, aka mlr, awk/sed/grep/jq/... for csv, etc.)
  - miller5 (mlr, old version in c)
  - miller6 (mlr, reimplemented in go)
- minikube (https://minikube.sigs.k8s.io/)
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
- muslfts (https://github.com/pullmoll/musl-fts)
- muslstandalone (http://musl.libc.org/ - unbundled musl libc and kernel headers with musl-gcc wrapper, possibly different version from statictoolchain)
  - musl11 (musl 1.1.x for compat)
  - musl12 (musl 1.2.x with `oldmalloc` for compat)
- n2n (https://github.com/ntop/n2n and https://www.ntop.org/products/n2n/ - peer-to-peer vpn with edge and supernodes for nat traversal - openssl/zstd/libcap/libpcap)
  - n2nlibressl (libressl and zstd only, no libcap or libpcap)
  - n2nminimal (no optional features)
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
- nginx (https://nginx.org/ - openssl)
  - nginxlibressl (libressl)
  - njs (http://nginx.org/en/docs/njs/index.html - nginx javascript cli tool, with crypto support via libressl and readline shell)
  - njsopenssl (njs built against openssl and readline shell)
  - njsminimal (njs with readline but no crypto support)
  - njstiny (njs with no readline or crypto support)
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
  - openconnectgnutlsminimal (gnutlsminimal)
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
  - see below for notes on newer versions (boost req, yeesh)
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
- tcpproxy (https://github.com/inetaf/tcpproxy - go, contains tlsrouter sni proxy program)
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
- tinycurl (https://curl.se/tiny/ - curl but smaller, focus on http(s) - wolfssl, wolfssh, zlib, nghttp2)
  - tinycurlbearssl (bearssl, zlib, nghttp2)
  - tinycurllibressl (libressl, libssh2, zlib, nghttp2)
  - tinycurlmbedtls (mbedtls, libssh2, zlib, nghttp2)
  - tinycurlopenssl (openssl, libssh2, zlib, nghttp2)
  - tinycurl772 (older version - wolfssl, wolfssh, zlib, nghttp2)
    - tinycurl772bearssl (bearssl, zlib, nghttp2)
    - tinycurl772libressl (libressl, libssh2, zlib, nghttp2)
    - tinycurl772mbedtls (mbedtls, libssh2, zlib, nghttp2)
    - tinycurl772openssl (openssl, libssh2, zlib, nghttp2)
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
- zlibng (https://github.com/zlib-ng/zlib-ng - fork with vector support, compiled static and shared with `libz.a` compat lib and `libz.so.1` created as well)
- zstd (https://github.com/facebook/zstd)
- zulu - built-in recipe, glibc-based for bootstrapping (chrome os, centos, debian, ubuntu, ...)
  - zulu8glibc - zulu 8 jdk
  - zulu11glibc - zulu 11 jdk
  - zulu17glibc - zulu 17 jdk
  - zulu8musl - zulu 8 jdk built against musl libc (x86_64 only)
  - zulu11musl - zulu 11 jdk built against musl libc (x86_64, aarch64 only)
  - zulu17musl - zulu 17 jdk built against musl libc (x86_64, aarch64 only)

## recipes to consider

- 3mux (https://github.com/aaronjanse/3mux - tmux-like multiplex in go)
- 3proxy (https://github.com/3proxy/3proxy - lots of little proxy things)
- 9pfs (https://github.com/mischief/9pfs - fuse 9p driver)
- abs (https://www.abs-lang.org/ and https://github.com/abs-lang/abs - shell like interpreter in go)
- ack (https://beyondgrep.com/)
- acme-dns (https://github.com/joohoi/acme-dns - REST/ACME DNS in go)
  - acme-dns-client (https://github.com/acme-dns/acme-dns-client - go)
- acme labs (http://www.acme.com/software/ - SO MUCH GOOD STUFF)
  - db (http://www.acme.com/software/db/ - gdbm? ndbm/sdbm/dbm?)
  - e (http://acme.com/software/e/ - small emacs-like)
  - js_httpd (http://www.acme.com/software/js_httpd/)
  - lam (http://www.acme.com/software/lam/)
  - mudecode (http://www.acme.com/software/mudecode/)
- acme.sh (https://github.com/acmesh-official/acme.sh - shell cert client with openssl+curl+wget)
  - see `openssl-cert-wrapper` idea in [TODO.md](TODO.md)
  - lots of dns updates in there too...
    - dyn, freedns, etc. update script: https://github.com/acmesh-official/acme.sh/blob/master/dnsapi/dns_freedns.sh
- acmetool (https://github.com/hlandau/acmetool - acme tool in go)
- act (https://github.com/nektos/act - github actions running locally)
  - act_runner (https://gitea.com/gitea/act_runner - gitea runner fork of act!)
- ag (the silver searcher https://geoff.greer.fm/ag/)
- agner fog's stuff
  - https://www.agner.org/optimize/#objconv
- aho (https://github.com/djanderson/aho - git (local-only) in awk - cool!)
- align (and width, perl scripts, http://kinzler.com/me/align/)
- aloa (linter - https://github.com/ralfholly/aloa)
- althttpd (https://sqlite.org/althttpd/doc/trunk/althttpd.md - sqlite web server, xinetd+stunnel)
- amfora (https://github.com/makeworld-the-better-one/amfora - go gemini client)
- angt stuff
  - arply (https://github.com/angt/arply - arp ipv4 response daemon)
  - forwarp (https://github.com/angt/forwarp - arp forward between interfaces)
  - secret (https://github.com/angt/secret - small secret store, uses libhydrogen)
  - slashinit (https://github.com/angt/slashinit - initramfs init, diskless/tunable)
  - totp (https://github.com/angt/totp - small time-based one-time pad)
- ansicurses (https://github.com/byllgrim/ansicurses)
- ansi (https://github.com/fidian/ansi - ansi color codes/tables in bash)
- arachsys stuff (https://arachsys.github.io/)
  - containers (https://github.com/arachsys/containers - small containers with linux namespaces)
  - init (https://github.com/arachsys/init - bsd-ish init with a lot of nice utils - uevent, syslog, etc.)
  - pocketcrypt (https://github.com/arachsys/pocketcrypt - lightweight cryptography lib w/tools for key creation/verification/signing/etc.)
  - skd (https://github.com/arachsys/skd - socket daemon, inetd-like - bind to a udp/tcp port/socket, run something)
  - tinyacme (https://github.com/arachsys/tinyacme - go, acme listener/proxy/redirectory, tls-alpn-01!!!)
  - tube (https://github.com/arachsys/tube - magicwormhole-style peer-to-peer pipe w/Pocketcrypt)
  - ucontain (https://github.com/arachsys/ucontain - shell container manager with unshare and pivot)
- argp-standalone (http://www.lysator.liu.se/~nisse/misc/ and https://git.alpinelinux.org/aports/tree/main/argp-standalone)
- aria2 (https://github.com/aria2/aria2 and https://aria2.github.io/)
- arr (https://github.com/leahneukirchen/arr)
- assemblers?
  - fasm
  - nasm
  - vasm
  - yasm
- asignify (https://github.com/vstakhov/asignify - standalone openbsd signify-like)
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
- awall (https://github.com/alpinelinux/awall - alpine firewall!)
- awka (http://awka.sourceforge.net/index.html - generate c from awk and compile)
- awkcc (https://github.com/nokia/awkcc - awk to c transpiler w/binary executable output)
- axtls (http://axtls.sourceforge.net/ - dead? curl deprecated)
- b2sum (https://github.com/dchest/b2sum)
- babashka (https://github.com/borkdude/babashka - clojure+shell?)
- barebox (https://www.barebox.org/)
- barefoot (https://www.inet.no/barefoot/index.html - tcp/udp port bouncer/redirector)
- bashdb (http://bashdb.sourceforge.net/ - bash debugger)
- basher (https://github.com/basherpm/basher - bash script package manager)
- bashrc (https://github.com/ajdiaz/bashc and https://ajdiaz.me/bashc/ - compile a bash script into static binary)
- bic (https://github.com/hexagonal-sun/bic - c repl)
- big data stuff
  - hadoop (version 2.x? 3.x? separate out into separate versioned recipes?)
  - hbase (version?)
  - spark (included in sdkman)
- binfmt-support (https://git.savannah.gnu.org/cgit/binfmt-support.git - ???)
- bitlbee (https://github.com/bitlbee/bitlbee and https://www.bitlbee.org/ - irc/social network/etc. gateway, supports libpurple)
- blake2 (https://github.com/BLAKE2/BLAKE2)
- bombadillo (https://bombadillo.colorfield.space/ - go gopher, gemini, finger, etc. client)
- boost (...)
  - ```./bootstrap.sh --prefix=${ridir} --without-icu ; ./b2 --prefix=${ridir} --layout=system -q link=static install```
  - it's like a 100MB tgz, 700MB extracted, 900MB during build, 190MB installed
  - yikes
- bootterm (https://github.com/wtarreau/bootterm - small user-friendly serial client/terminal emulator)
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
- bpf stuff
  - bcc (https://github.com/iovisor/bcc)
  - libbpf (https://github.com/libbpf/libbpf)
- bpkg (http://www.bpkg.sh/ and https://github.com/bpkg/bpkg - bash package manager)
- brogue stuff
  - brogue (https://github.com/tsadok/brogue)
  - broguece (https://github.com/tmewett/BrogueCE)
  - brogue-linux (https://github.com/CubeTheThird/brogue-linux)
  - gbrogue (https://github.com/gbelo/gBrogue)
- bsd-coreutils (https://github.com/Projeto-Pindorama/bsd-coreutils - bsd stuff, fork of lobase-old?)
- bsdgames
  - pick and choose?
  - https://github.com/vattam/BSDGames
  - https://github.com/ctdk/bsdgames-osx
  - https://github.com/jj1bdx/bsdgames
  - https://github.com/abakh/nbsdgames (above)
  - https://github.com/chrisevett/bsdgames
  - https://github.com/fritz0705/bsdgames
  - ...
- bsdgames (debian - https://packages.debian.org/buster/bsdgames)
- bsd-headers (http://cgit.openembedded.org/openembedded-core/tree/meta/recipes-core/musl - oe/yocto)
- bsdutils (https://github.com/dcantrell/bsdutils - alternative to coreutils with stuff from freebsd)
  - chimerautils (https://github.com/chimera-linux/chimerautils)
  - other chimera repos... (https://github.com/orgs/chimera-linux/repositories)
- btyacc (https://www.siber.com/btyacc/ - 2.x and 3.x)
- bubblewrap (https://github.com/containers/bubblewrap - user-mode unprivileged sandboxing?)
- build-scripts (https://github.com/noloader/Build-Scripts - useful versions, packaging, etc. stuff)
- buricco stuff
  - lc-subset (https://github.com/buricco/lc-subset - userspace tools, mostly from scratch, mostly unix-like)
  - lunaris (https://github.com/buricco/lunaris - linux distro with svr4 feel)
- busybear-linux (https://github.com/michaeljclark/busybear-linux - small riscv distro, lots of good userspace and /etc config stuff)
- c9 (https://github.com/ftrvxmtrx/c9 - small 9p client/server impl)
  - moved? https://github.com/ftrvxmtrx/o-hai-I-m-moving-to-git.sr.ht
  - https://git.sr.ht/~ft/c9
- c-kermit (http://www.kermitproject.org/, and/or e-kermit...)
- cataclysm: dark days ahead (https://github.com/CleverRaven/Cataclysm-DDA - fork of https://github.com/Whales/Cataclysm)
- cawf (nroff workalike, https://github.com/ksherlock/cawf or https://github.com/0xffea/MINIX3/tree/master/commands/cawf or ???)
- cembed (https://github.com/rxi/cembed - embed files in a c header - useful for tinyscheme/minischeme library in single binary???)
- cepl (https://github.com/alyptik/cepl)
- certviewer (https://github.com/cortiz/certview - certificate, including remote, viewer in go, with text/yaml/json/... output)
- chelf (https://github.com/Gottox/chelf)
- ching (https://github.com/floren/ching - i ching from bsd)
  - needs nroff (heirloom or groff)
  - ```
    sed -i.ORIG s,/usr/local,${ridir},g Makefile phx/pathnames.h ching.sh
    sed -i s,${ridir}/games,${ridir}/bin,g Makefile phx/pathnames.h ching.sh
    make CC="${CC} -static -Wl,-static"
    ```
- chrpath
- c/c++ compiler stuff
  - lots of links to compilers/transpilers/interpreters/... that interact with/output C: https://github.com/dbohdan/compilers-targeting-c
  - 8cc (https://github.com/rui314/8cc)
  - 8cc.go (https://github.com/DQNEO/8cc.go - 8cc ported to go)
  - lambda-8cc (https://github.com/woodrush/lambda-8cc - 8cc c compiler implemented as lambda calculus, with a vm and common lisp, and...)
  - 9cc (https://github.com/rui314/9cc)
  - 9-cc (https://github.com/0intro/9-cc - unix port of plan 9 compiler)
  - andrew chambers's c (https://github.com/andrewchambers/c)
  - c4 (https://github.com/rswier/c4)
    - swieros (https://github.com/rswier/swieros - fully emulated cpu/machine with unix-like os, c compiler, etc. COOL!)
  - cake (https://github.com/thradams/cake - c23 fronted, may be able to compile newer C to c99/c89/...?)
  - chibicc (https://github.com/rui314/chibicc)
  - compcert (https://github.com/AbsInt/CompCert and https://compcert.org - formally verified c compiler)
  - cparse (https://github.com/jafarlihi/cparse)
    - clex (https://github.com/jafarlihi/clex)
  - cproc (https://git.sr.ht/~mcf/cproc and https://github.com/michaelforney/cproc)
  - gofrontend (https://github.com/golang/gofrontend - go frontend for gcc? in c? not sure what verisons it works with?)
  - kefir (https://github.com/protopopov1122/kefir - c17 compiler from scratch)
  - kencc (https://github.com/aryx/fork-kencc)
  - lacc (https://github.com/larmel/lacc)
  - lcc (https://github.com/drh/lcc)
  - mazucc (https://github.com/jserv/MazuCC)
  - musl.cc (https://musl.cc/ - cross and native compilers for all sorts of architectures, useful for bootstrapping openjdk on alpine?)
  - nwcc (http://nwcc.sourceforge.net/ - c89 compiler)
  - plan9-cc (https://github.com/huangguiyang/plan9-cc)
  - qbe (https://c9x.me/compile/)
  - scc (http://www.simple-cc.org/)
  - tendra (https://bitbucket.org/asmodai/tendra/src/default/ https://en.wikipedia.org/wiki/TenDRA_Compiler)
  - wcc (https://github.com/freewilll/wcc)
  - xcc (https://github.com/tyfkda/xcc - toy C compiler for x86-64/aarch64/wasm - linux, xv6?)
    - xv6 bits: https://github.com/tyfkda/xv6 (forked from https://github.com/swetland/xv6)
  - yet another c compiler (https://github.com/lasarus/C-Compiler)
- cfssl (https://github.com/cloudflare/cfssl - cloudflare tls swiss army knife)
- cgpt (google source only?)
- cmark (commonmark markddown - https://github.com/commonmark/cmark)
  - cmark-gfm (github fork - https://github.com/github/cmark-gfm)
- cocker (https://github.com/calvinwilliams/cocker - small container engine in c)
- conty (https://github.com/Kron4ek/Conty - shell containerizer, needs fuse2/3, coreutils, tar (gnu?), gzip (gnu?), bash)
- cparser (https://pp.ipd.kit.edu/git/cparser/)
  - firm (https://pp.ipd.kit.edu/firm/ - related?)
- cpplint (https://github.com/google/styleguide and https://github.com/cpplint/cpplint)
- cpu (https://github.com/u-root/cpu - plan 9-like cpu - "push" local filesystem/program to remote, execute - in go, works over ssh... cool)
- croc (https://github.com/schollz/croc and https://schollz.com/blog/croc6/ - point-to-point filesharing, with a relay)
- cronolog (https://github.com/fordmason/cronolog)
  - maybe a fork? (https://github.com/pbiering/cronolog seems active)
  - another one? (https://github.com/FireBurn/cronolog)
  - svlogd from busybox can do _some_ of the same thing?)
- crosstool-ng toolchain (gcc, a libc, binutils, etc. ?)
  - would be useful to provide gcc with glibc support for more "native" builds
  - base on centos 7? rhel 8? debian 10? ubuntu 20 lts?
  - could be used to bootstrap llvm/clang and bootstrap rust?
- ctop (https://ctop.sh/ and https://github.com/bcicen/ctop - container top)
- curlie (https://github.com/rs/curlie and https://curlie.io/ - curl features with httpie-alike in go)
- cwebsocket (https://github.com/jeremyhahn/cwebsocket - c websocket client/server)
  - other cwebsocket? (https://github.com/m8rge/cwebsocket)
- cwerg (https://github.com/robertmuth/Cwerg - compiler back-end for arm 32- and 64-bit)
- dante (socks proxy client/server https://www.inet.no/dante/)
- dasel (https://github.com/TomWright/dasel - data selector like jq, yq - go)
- dave (https://github.com/micromata/dave - go webdav sever w/tls)
- dehydrated (https://github.com/dehydrated-io/dehydrated - shell acme/letsencrypt client)
- dinit (https://github.com/davmac314/dinit - init and service monitor)
- diod (https://github.com/chaos/diod - 9p fileserver)
  - `attr/xattr.h` -> `sys/xattr.h` - fix multiple files
  - `sys/sysmacros.h` fix in **diod/ops.c**
  - rename `err()` in **libdiod/diod_log.c** (`sed -i.ORIG 's/^err /diod_err /g' libdiod/diod_log.c`?)
  - reqs
    - lua 5.1
    - perl (for metadata creation?)
    - libcap - might be optional?
  - munge (below) for authentication support?
- discount (markdown - https://github.com/Orc/discount)
- dnscrypt-proxy (https://github.com/DNSCrypt/dnscrypt-proxy - doh in go)
- dnscrypt-wrapper (https://github.com/cofyc/dnscrypt-wrapper - libbsd+libsodium+libevent dnscrypt wrapper/proxy, use with unbound?)
- doas
  - opendoas already in
  - looks fine as well: https://github.com/slicer69/doas
    - has `vidoas` editor wrapper
    - PAM only though?
    - rip off vidoas into opendoas?
- docbook?
- dpic (https://ece.uwaterloo.ca/~aplevich/dpic/)
- dumb-init (https://github.com/Yelp/dumb-init)
- duplicity (http://duplicity.nongnu.org/)
- e (https://github.com/hellerve/e - simple editor, syntax highlighting, archived?)
- edbrowse (http://edbrowse.org/ and https://github.com/CMB/edbrowse)
  - cmake, curl, pcre, tidy (cmake), duktape
- editline (https://github.com/richsalz/editline - another editline/libedit)
- elftoolchain (https://github.com/elftoolchain/elftoolchain - bsd licensed elf ar/ld/strings/etc. - binutils-ish)
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
- httpd.bash (https://github.com/emasaka/httpd.bash/blob/master/httpd.bash - a little webserver in bash)
- emulation stuff
  - axpbox (https://github.com/lenticularis39/axpbox - alpha)
  - gxemul (http://gavare.se/gxemul/)
- eris (https://github.com/nealey/eris - small web server)
- faasd (https://github.com/openfaas/faasd - openfaas but smaller? needs runc, etc.)
- fcgiwrap (https://github.com/gnosek/fcgiwrap - standard cgi to fcgi socket wrapper, useful with nginx?)
- felinks (https://github.com/rkd77/elinks - up-to-date fork of elinks)
- firecracker (https://github.com/firecracker-microvm/firecracker - rust, but there are static bins for aarch64/x86_64)
  - firectl (https://github.com/firecracker-microvm/firectl - firecracker vm control, go)
  - firecracker-containerd (https://github.com/firecracker-microvm/firecracker-containerd)
- firejail (https://github.com/netblue30/firejail)
- forgejo (https://forgejo.org/ and https://codeberg.org/forgejo/forgejo - gitea fork)
- forth stuff
  - embed (https://github.com/howerj/embed - small forth interpreter+metacompiler in c, j1 and h2 (virtual) cpu models)
  - libforth (https://github.com/howerj/libforth - forth interpreter and standalone program in c, with libline line editing)
    - libline (https://github.com/howerj/libline - linenoise fork)
  - retro (forth, http://retroforth.org/ and https://github.com/crcx/retroforth)
    - 32-/64-bit support!!!
    - other good forth/smalltalk/... stuff: http://forthworks.com/
  - ueforth (https://github.com/flagxor/eforth - small forth for linux, plus esp32forth for wifi+bt mcu)
- fountain (formerly? http://hea-www.cfa.harvard.edu/~dj/tmp/fountain-1.0.2.tar.gz)
- fq (https://github.com/wader/fq - like jq for binaries in go)
- frontabse (http://openbsd.stanleylieber.com/frontbase - 9base fork?)
- fx (https://github.com/antonmedv/fx - terminal json viewer/navigator in go)
- fzf (https://github.com/junegunn/fzf - fuzzy finder in go)
- gatling (http://www.fefe.de/gatling/ - small web/cgi/ftp/smb server)
- garage (https://git.deuxfleurs.fr/Deuxfleurs/garage and https://garagehq.deuxfleurs.fr/ - distributed s3 object store in rust)
- gcc - other versions, builds, etc.
  - `gcc9`, `gcc10`, `gcc11` - default musl, useful for testing new versions
  - `gcc#glibc` - for gcc+glibc libc/libgcc_s/etc. (jdk, graalvm, ...)
- gcompat (https://code.foxkit.us/adelie/gcompat and https://github.com/AdelieLinux/gcompat)
- geomyidae (http://r-36.net/scm/geomyidae/ - gopher server)
- gdb
- gh-dash (https://github.com/dlvhdr/gh-dash - github cli dashboard w/gh)
- git-crypt (https://github.com/AGWA/git-crypt)
- glow (https://github.com/charmbracelet/glow - terminal markdown renderer in go)
- gmni (https://sr.ht/~sircmpwn/gmni/ and https://git.sr.ht/~sircmpwn/gmni - gemini client)
- gmnisrv (https://sr.ht/~sircmpwn/gmnisrv/ and https://git.sr.ht/~sircmpwn/gmnisrv - gemini server)
- gnulib (https://www.gnu.org/software/gnulib - probably needed to repackage for older gnu projects - shishi, gss, gsasl, ...)
- go stuff
  - https://github.com/avelino/awesome-go
- go9p (https://github.com/knusbaum/go9p - 9p in go)
- go-git (https://github.com/go-git/go-git)
  - pure go, might make for a decent no-frills clone/fetch/merge client?
- gogit (https://github.com/speedata/gogit - read-only git repository thing in go, archived/unmaintained)
- gophernicus (https://github.com/gophernicus/gophernicus - gopher server)
- go-openssl (https://github.com/libp2p/go-openssl - cgo wrapper around openssl? archived/unmaintained)
- gopass (https://github.com/gopasspw/gopass - like pass but in go, uses gpg/git)
- gops (https://github.com/google/gops - running go process analyzer)
- gotty (https://github.com/yudai/gotty - like shellinabox in go)
- go-tunnel (https://github.com/opencoff/go-tunnel - stunnel replacement written in go)
- gowebdav (https://github.com/studio-b12/gowebdav - go webdav sli program)
- goxz (https://github.com/Songmu/goxz - gather deps for cross-compile and archive?)
- gpg
  - etc.
- gplaces (https://github.com/dimkr/gplaces - terminal gemini client, based on delve (https://github.com/kieselsteini/delve) gopher client?)
- graphviz (http://graphviz.org/)
- gron (https://github.com/tomnomnom/gron - greppable json, in go)
  - gron.awk (https://github.com/xonixx/gron.awk - gron, in awk,,,)
- gsasl/libgsasl (https://www.gnu.org/software/gsasl/)
- gsl (gnu scientific library, https://www.gnu.org/software/gsl/)
- gss (https://www.gnu.org/software/gss/)
- gwsocket (https://github.com/allinurl/gwsocket - standalone websocket server in c)
- hcl2json (https://github.com/tmccombs/hcl2json - does what it says on the tin)
- heirloom-ng (https://github.com/Projeto-Pindorama/heirloom-ng - updated heirloom utils with a flatter installation)
- hittpd (https://github.com/leahneukirchen/hittpd - small http server with http-parser library)
- hoedown (markdown lib - https://github.com/hoedown/hoedown)
- hq (https://github.com/rbwinslow/hq)
- http-parser (https://github.com/nodejs/http-parser - no longer active, (useful with libgit2?))
  - llhttp (https://github.com/nodejs/llhttp - continuation on a different parsing platform)
- http servers/proxies/load balancers/etc.
  - apache (https://httpd.apache.org/ - httpd, needs apr, apr-util)
  - caddy (https://caddyserver.com/ and https://github.com/caddyserver/caddy - http server with automatic tls)
  - cherokee (http://cherokee-project.com/)
  - hiawatha (https://www.hiawatha-webserver.org/)
  - lighttpd
    - `lighttpdbig` package with lua+dbi+sqlite+openssl+...
    - can build with: gdbm, zstd, brotli, xxhash, lua, memcache, ...
    - other lighttpd projects:
      - fcgi-cgi (https://redmine.lighttpd.net/projects/fcgi-cgi/repository - run cgi scripts with fastcgi)
      - fcgi-debug (https://redmine.lighttpd.net/projects/fcgi-debug/repository)
      - scgi-cgi (https://redmine.lighttpd.net/projects/scgi-cgi/repository - run cgi scripts in scgi)
      - spawn-fcgi (https://redmine.lighttpd.net/projects/spawn-fcgi/repository)
  - mongoose (https://github.com/cesanta/mongoose)
  - monkey (http://monkey-project.com/)
  - openresty (https://openresty.org/)
  - pen (http://siag.nu/pen/)
  - pound (https://www.apsis.ch/pound.html)
    - cmake, NO!
- ibara's good portable/bsd stuff
  - libterminfo (https://github.com/ibara/libterminfo - standalone terminfo, netbsdcurses-style)
  - m4 (https://github.com/ibara/m4)
  - make (https://github.com/ibara/make)
  - mg (https://github.com/ibara/mg)
  - mgksh (https://github.com/ibara/mgksh - static ksh and mg (emacs) from openbsd in a single bin)
  - nbc (https://github.com/ibara/nbc - netbsd bc)
  - ocsh (https://github.com/ibara/ocsh - openbsd csh)
  - oed (https://github.com/ibara/oed - openbsd ed)
  - sprite (https://github.com/ibara/sprite - curses sprite editor, libpng export support!)
  - tac (https://github.com/ibara/tac)
  - yacc (https://github.com/ibara/yacc)
- ifupdown-ng (ttps://github.com/ifupdown-ng/ifupdown-ng - debian/busybox compatible-ish ifupdown in c w/dep resolver)
- iglunix (https://github.com/iglunix/iglunix - gnu-less linux distribution, musl+llvm, looks useful)
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
- ip2unix (https://github.com/nixcloud/ip2unix - turn ip socket into unix socket... c++)
- java stuff
  - alpine openjdk? 11? 8?
  - ant (included in sdkman)
  - antlr
  - ballerina (https://ballerina.io and https://github.com/ballerina-platform/ballerina-lang - included in sdkman)
  - ceylon (https://ceylon-lang.org and https://github.com/eclipse/ceylon)
  - clojure (leiningen included in sdkman)
  - doppio (https://github.com/plasma-umass/doppio and https://plasma-umass.org/doppio-demo - java 8 jvm, in javascript)
  - ecj (separate compiler from eclipse? native code w/graal, gcj, etc.?)
  - frege (https://github.com/Frege/frege)
  - gradle (included in sdkman)
  - grails (included in sdkman)
  - groovy (included in sdkman)
  - hg4j and client wrapper (https://github.com/nathansgreen/hg4j)
  - ivy (https://ant.apache.org/ivy/)
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
  - avian (https://readytalk.github.io/avian/)
  - cacao
  - corretto (https://github.com/corretto)
  - dragonwell (https://github.com/alibaba/dragonwell8)
  - jamvm
  - jikes rvm
  - liberica (https://www.bell-sw.com/java.html)
    - 64-bit intel/arm and some 32-bit support
    - source downloads from main page, might be easier to rebuild than zulu/upstream?
    - jdk/jre (https://bell-sw.com/pages/downloads/ - supports musl/alpine)
    - embedded jdk (https://bell-sw.com/pages/downloads-embedded/)
    - native image kit (https://bell-sw.com/pages/downloads/native-image-kit/ - graal, supports musl/alpine, language plugins, ...)
  - maxine (https://github.com/beehive-lab/Maxine-VM)
  - ojdkbuild (https://github.com/ojdkbuild/ojdkbuild)
  - openj9 (ibm, eclipse?)
  - temurin (https://adoptium.net/ - eclipse; adoptium, formerly adoptopenjdk)
  - ...
- javascript stuff
  - see: https://notes.eatonphil.com/javascript-implementations.html
  - bun (https://bun.sh/ and https://github.com/oven-sh/bun - javascript runtime/bundler/transpiler/packager in zig/c++/...)
  - colony-compiler (unmaintained - https://github.com/tessel/colony-compiler)
  - dukluv (https://github.com/creationix/dukluv - libuv+duktape)
  - engine262 (https://github.com/engine262/engine262 - js in js)
  - escargot (https://github.com/Samsung/escargot)
  - espruino (https://github.com/espruino/Espruino - pi build?)
    - espruintools (https://github.com/espruino/EspruinoTools)
  - esvu (https://github.com/devsnek/esvu)
  - goja (https://github.com/dop251/goja - go js)
    - goja-nodejs (https://github.com/dop251/goja_nodejs - node.js compat?)
  - iv (https://github.com/Constellation/iv)
  - jerryscript (https://github.com/jerryscript-project/jerryscript and http://jerryscript.net/)
    - needs an `fflush(stdout);` added for the prompt print...
    - compile standalone tool with something like...
      - ```
        gcc \
         -Wl,-static -Wl,-s -g0 -Os \
           -DJERRY_COMMIT_HASH='"-fake"' \
           -DJERRY_BUILTINS=1 \
           -DJERRY_DEBUGGER=1 \
           -DJERRY_LINE_INFO=1 \
           -DJERRY_PROMISE_CALLBACK=1 \
           -DJERRY_SNAPSHOT_{EXEC,SAVE}=1 \
           -DJERRY_{PARSER,REGEXP}_DUMP_BYTE_CODE=1 \
           -DJERRY_ERROR_MESSAGES=1 \
           -DJERRY_LOGGING=1 \
           -DJERRY_CPOINTER_32_BIT=1 \
         $(find */ -name \*.h -exec dirname {} \; | sort -u | grep -vE 'targets|tests|valgrind' | sed s,^,-I${PWD}/,g) \
         -I${PWD}/jerry-ext/include \
           $(find jerry-{core,ext,port/default} -type f -name \*.c) \
           jerry-main/{main-unix,main-utils,main-options,cli}.c \
             -o jerry
        ```
      - jerry-snapshot: as above but with `jerry-main/main-unix-snapshot.c` instead of plain `main-unix.c`
    - config options: https://jerryscript.net/configuration/
    - other jerryscript stuff:
      - iotjs (https://github.com/jerryscript-project/iotjs - iot js platform built w/python?)
      - iotjs-modules (https://github.com/jerryscript-project/iotjs-modules)
      - iotjs-samples (https://github.com/jerryscript-project/iotjs-samples)
  - jsi (jsish - https://jsish.org/)
  - jsvu (https://github.com/GoogleChromeLabs/jsvu)
  - mininode (https://github.com/mininode/mininode - embedded node.js compat on duktape, cool not sure how mature)
  - mjs (formerly v7 - https://github.com/cesanta/mjs and https://github.com/cesanta/v7/)
    - v7 (https://github.com/cesanta/v7 - basis for mjs)
    - elk (https://github.com/cesanta/elk - tiny embedded js engine)
  - otto (https://github.com/robertkrimen/otto - go js)
  - rampart (https://www.rampart.dev/ and https://github.com/aflin/rampart - minimal full-stack built on duktape)
  - quad-wheel (https://code.google.com/archive/p/quad-wheel/)
  - tiny-js (https://github.com/gfwilliams/tiny-js)
- jdbc
  - drivers
    - derby (included in derby.jar)
    - mariadb (https://mariadb.com/kb/en/library/about-mariadb-connector-j/)
    - mssql (https://github.com/Microsoft/mssql-jdbc)
    - mysql (https://dev.mysql.com/downloads/connector/j/)
    - oracle? (probably not)
    - postgresql (https://jdbc.postgresql.org/)
    - sqlite (https://bitbucket.org/xerial/sqlite-jdbc and https://github.com/xerial/sqlite-jdbc)
  - programs/clients/other
    - ha-jdbc (https://github.com/ha-jdbc/ha-jdbc)
    - henplus (https://github.com/neurolabs/henplus - formerly http://henplus.sourceforge.net/)
      - can use/needs(?) java-readline (https://github.com/aclemons/java-readline)
    - jisql (https://github.com/stdunbar/jisql)
    - sqlshell (scala, sbt - https://github.com/bmc/sqlshell)
- jed (https://www.jedsoft.org/jed/)
- jedisct1 stuff
  - encpipe (https://github.com/jedisct1/encpipe - simple encrypted pipe with libhydrogen)
  - libhydrogen (https://github.com/jedisct1/libhydrogen - simple high-level crypto lib from libsodium folks)
  - minisign (https://github.com/jedisct1/minisign - sign/verify files with digital signatures, libsodium+cmake)
   - go implementation: https://github.com/aead/minisign
   - javascript: https://github.com/chm-diederichs/minisign
  - piknik (https://github.com/jedisct1/piknik - network copy/paste)
  - rpdns (https://github.com/jedisct1/rpdns - dns proxy)
  - vtun (https://github.com/jedisct1/vtun - secure virtual tunnel with libsodium instead of openssl)
    - original: https://vtun.sourceforge.net/
- jenkinsfile-runner (https://github.com/jenkinsci/jenkinsfile-runner - run a Jenkinsfile under a FaaS model)
- jimtcl (https://github.com/msteveb/jimtcl and http://jim.tcl.tk/ - small tcl implementation)
- jitter (http://ageinghacker.net/projects/jitter/ - jit/vm/interpreter thing)
- jobflow (https://github.com/rofl0r/jobflow - small gnu parallel alike in c)
- joe (https://joe-editor.sourceforge.io/)
- jqp (https://github.com/noahgorstein/jqp - jq playground, in go w/gojq)
- json-rpc-shell (https://git.janouch.name/p/json-rpc-shell)
- JSON.sh (https://github.com/dominictarr/JSON.sh - json parser in shell/bash)
- juicefs (https://github.com/juicedata/juicefs - distributed filesystem in go on top of redis (transactions) and s3 (objects); cool)
- jujutsu (https://github.com/martinvonz/jj - git-compatible dvcs in rust)
- jumphost (https://github.com/osresearch/jumphost - minimal openssh key-based jump host)
  - linux-builder (https://github.com/osresearch/linux-builder - used to create a minimal vm image?)
- just (https://github.com/just-js/just - small javascript runtime, uses v8 and appears to be a lot of binaries :\)
- k3d (https://github.com/rancher/k3d and https://k3d.io - k3s in docker)
- kakoune (http://kakoune.org/ and https://github.com/mawww/kakoune)
- kerberos
  - heimdal
    - for static musl libraries, **heimdal** likely needs to be built with:
      - libedit (external, or with its _\-D_ workaround); readline may flake out
      - all DB drivers turned off?
      - openssl, or leave default builtin hcrypto based on libtommath stuff?
      - bdb: `- --with-berkeley-db --disable-heimdal-documentation`
      - gdbm, sqlite
      - definitely ncurses
      - replace sys/errno.h with errno.h
      - replace sys/poll.h with poll.h
    - see: http://lists.busybox.net/pipermail/buildroot/2017-July/198737.html
  - mit
  - shishi (https://www.gnu.org/software/shishi/)
- keyutils (http://people.redhat.com/~dhowells/keyutils/)
- kine (https://github.com/k3s-io/kine - "kine is not etcd" - etcd api to rdbms w/sqlite, mysql, postgres, dqlite)
- kineto (https://sr.ht/~sircmpwn/kineto/ and https://git.sr.ht/~sircmpwn/kineto - gemini to http gateway/proxy)
- klipse (https://github.com/viebel/klipse - js-based multi-language code snippet evaluation framework)
- knot
  - knot-dns (https://www.knot-dns.cz - authoritative dns)
    - muacme (https://github.com/jirutka/muacme - uacme wrapper with busybox/openrc/openssl/libressl/wget/knot knsupdate/kdig)
  - knot-resolver (https://www.knot-resolver.cz - caching recursive dns resolver)
- kramdown (markdown, in ruby - https://github.com/gettalong/kramdown)
- ksh-openbsd (https://github.com/levaidaniel/ksh-openbsd - another ksh port)
- kvmtool (https://github.com/kvmtool/kvmtool - standalone native kvm frontend w/o qemu?)
- larn (short roguelike https://en.wikipedia.org/wiki/Larn_(video_game) - maintained/modern https://github.com/atsb/RL_M)
- ldd
  - driver script
  - run toybox to figure out if musl or glibc and get dyld
  - if static just say so
  - depending on dynamic linker...
    - glibc: ```LD_TRACE_LOADED_OBJECTS=1 /path/to/linker.so /path/to/executable```
    - musl: setup **ldd** symlink to **ld.so**, run ```ldd /path/to/executable```
- lego (https://github.com/go-acme/lego - let's encrypt, go)
- lemon (https://www.hwaci.com/sw/lemon/ https://www.sqlite.org/lemon.html https://sqlite.org/src/doc/trunk/doc/lemon.html)
- levee (https://github.com/Orc/levee)
- lf (https://github.com/gokcehan/lf - go)
- libagentcrypt (https://github.com/ndilieto/libagentcrypt - file encryption using ssh-agent)
- libdash (https://github.com/mgree/libdash - shell as a library, ast, etc.)
- libdbi (https://github.com/balabit/libdbi)
- libdbi-drivers (https://github.com/balabit/libdbi-drivers)
- libdeflate (https://sortix.org/libdeflate/)
- libdnet (https://github.com/boundary/libdnet or up-to-date fork at https://github.com/busterb/libdnet)
  - mostly want the dnet binary
- libeconf (https://github.com/openSUSE/libeconf)
- libest (https://github.com/cisco/libest - "enrollment over secure transport" cert distribution, https://en.wikipedia.org/wiki/Enrollment_over_Secure_Transport)
- libfawk (http://repo.hu/projects/libfawk/ - awk like function language/vm/library)
- libfetch (https://git.alpinelinux.org/aports/tree/main/libfetch?h=3.3-stable and https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/net/libfetch/README.html - alpine, netbsd, needs work)
  - https://github.com/Gottox/libfetch - newer combo of netbsd/freebsd versions? no fetchReqHTTP
  - https://git.alpinelinux.org/aports/tree/main/libfetch?h=3.8-stable - _old_ alpine port against netbsd libfetch? no fetchReqHTTP
- libffcall (https://www.gnu.org/software/libffcall/)
- libfixposix (https://github.com/sionescu/libfixposix - common posix wrappers, used by jruby, which bundles glibc build of such - replace?)
- libfuse (https://github.com/libfuse/libfuse - separate userspace? uses meson? `fusermount` needs setuid)
  - need version 2 and 3, probably?
  - ugh?
- libhdate (https://sourceforge.net/projects/libhdate/ - hebrew calendar w/hcal and hdate programs with sunrise/sunset/etc. info)
- libhv (https://github.com/ithewei/libhv - c++ network library with some example programs, support for curl/openssl/gnutls/mbedtls/nghttp2)
- libiconv (https://www.gnu.org/software/libiconv/)
- libixp
  - https://github.com/bwhmather/libixp - fork updated recently?
- libmawk (http://repo.hu/projects/libmawk/ - embeddable mawk library fork)
- libnl-tiny (from sabotage, replacement for big libnl? https://github.com/sabotage-linux/libnl-tiny)
- libntlm (https://www.nongnu.org/libntlm/)
- libpsl (https://github.com/rockdaboot/libpsl https://github.com/publicsuffix/list https://publicsuffix.org/)
- libsigsegv (https://www.gnu.org/software/libsigsegv/)
- libsixel (https://github.com/saitoha/libsixel)
- libslz (http://www.libslz.org/)
- libsodium stuff
  - lots of good stuff on this list: https://doc.libsodium.org/libsodium_users
- libsysdev (https://github.com/idunham/libsysdev)
- libtap (https://github.com/zorgnax/libtap)
- libtom
  - libtomfloat
  - libtompoly
  - tomsfastmath
- libu (https://github.com/koanlogic/libu - network/system/etc. utility library)
- libuargp (https://github.com/xhebox/libuargp - argp-standalone alternative)
- libucl (https://github.com/vstakhov/libucl - universal configuration language parser library)
- libudev-zero (https://github.com/illiliti/libudev-zero)
- libunwind (http://www.nongnu.org/libunwind/ and http://savannah.nongnu.org/projects/libunwind)
- libusb (https://github.com/libusb/libusb)
- libutf (https://github.com/cls/libutf)
- libverto (https://github.com/npmccallum/libverto - main loop/async library, used by mit kerberos)
- libwaive (https://github.com/dimkr/libwaive - tame/pledge-like seccomp perms waiver)
- libwebsock (https://github.com/payden/libwebsock)
- libwebsockets (https://libwebsockets.org/)
- libxcrypt (https://github.com/besser82/libxcrypt - use with openssh for more auth methods? may need perl?)
- libyaml (https://github.com/yaml/libyaml)
- lisp stuff
  - aria (https://github.com/rxi/aria - tiny embeddable language)
  - carp (https://github.com/carp-lang/Carp)
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
  - forthlisp (https://github.com/schani/forthlisp - small lisp in forth)
  - gcl (https://www.gnu.org/software/gcl/)
    - reqs: m4, configgit, gmp?
    - needs ```setarch linux64 -R ...``` with proper linux64/linux32 setting before configure, make
    - not sure if this will work either
  - jscl (https://github.com/jscl-project/jscl and https://jscl-project.github.io/ - javascript common lisp)
  - le-lisp (http://christian.jullien.free.fr/lelisp/)
  - librep (https://github.com/SawfishWM/librep - embeddable lisp)
    - gdbm, gmp, libffi, makeinfo, ncurses, readline
    - **requires** shared lib
  - lisp500 (http://web.archive.org/web/20070722203906/https://www.modeemi.fi/~chery/lisp500/)
  - lispe (https://github.com/naver/lispe)
  - mal (https://github.com/kanaka/mal/ - make a lisp, in a bunch of languages)
    - minimal (https://github.com/kanaka/miniMAL - js impl based on mal!)
  - mankai common lisp (https://common-lisp.net/project/mkcl/)
  - maru (https://github.com/attila-lendvai/maru - small self-hosting lisp, lots of links to other small/bootstrap languages)
  - newlisp (http://www.newlisp.org/ - unnoficial code mirror at https://github.com/kosh04/newlisp)
    - needs libffi, ncurses, readline
    - ```make makefile_build ; sed -i 's/ = gcc$/ = gcc $(CPPFLAGS) $(shell pkg-config --cflags libffi)/g;s/-lreadline/$(LDFLAGS) -lreadline -lncurses/g' makefile_build```
  - picolisp (https://picolisp.com/wiki/?home)
    - picolisp (c, lisp)
    - ersatz picolisp (java)
  - psl (https://github.com/blakemcbride/PSL - "portable standard lisp")
  - roswell (https://github.com/roswell/roswell)
  - scopes (https://hg.sr.ht/~duangle/scopes)
  - sbcl (http://sbcl.org and https://github.com/sbcl/sbcl)
  - stutter (https://github.com/mkirchner/stutter - lisp impl in c, no external libs except editline?)
  - tort (https://github.com/kstephens/tort - tiny object runtime)
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
  - lua versions
    - settle on a version, 5.3 is at least "done?"
    - haproxy, lighttpd, etc., seem to support 5.1
    - `lua5{1,2,3,4}` all compilable/installable/available but not default - opt-in
  - elua (http://www.eluaproject.net/ and https://github.com/elua/elua)
  - lua2c (https://github.com/davidm/lua2c or a fork?)
  - luajit (https://luajit.org/)
  - luau (https://github.com/Roblox/luau - lua 5.1 compatible)
  - terra (https://github.com/zdevito/terra and http://terralang.org/)
- mailx (for sus/lsb/etc. - http://heirloom.sourceforge.net/mailx.html)
  - s-nail (https://www.sdaoden.eu/code.html#s-mailx) - up-to-date w/tls (openssl 1.1+) support
  - or gnu mailutils (https://www.gnu.org/software/mailutils/mailutils.html)
- makeself (https://makeself.io/ and https://github.com/megastep/makeself - bin pkgs? with signing?)
- makesure (https://github.com/xonixx/makesure - make-like goal/task runner in shell and awk)
- makl (https://github.com/koanlogic/makl and http://www.koanlogic.com/makl - build tool for C libs/progs using bourne shell and gnu make)
- man stuff
  - MANPATH settings
  - roffit (https://daniel.haxx.se/projects/roffit/)
- mandown (https://github.com/Titor8115/mandown - man like markdown, markdown like man?)
- maramake (https://maradns.samiam.org/maramake/ and https://github.com/samboy/maramake - pdpmake fork, used in maradns)
- matrixssl (https://github.com/matrixssl/matrixssl)
- mcpp (http://mcpp.sourceforge.net/)
- md4c (https://github.com/mity/md4c - markdown parser, md2html cli, uses cmake)
- memcached (https://memcached.org/ and https://github.com/memcached/memcached - libevent, can use openssl)
- mercurial / hg
  - need docutils: ```env PATH=${cwsw}/python2/current/bin:${PATH} pip install docutils```
  - config/build/install with: ```env PATH=${cwsw}/python2/current/bin:${PATH} make <all|install> PREFIX=${ridir} CPPFLAGS="${CPPFLAGS}" LDFLAGS="${LDFLAGS//-static/}" CFLAGS='' CPPFLAGS=''```
- mes (https://www.gnu.org/software/mes/) and m2 stuff (links above)
- mesalink (https://mesalink.io/ and https://github.com/mesalock-linux/mesalink)
- mg3a (https://github.com/paaguti/mg3a)
- mkcert (https://github.com/FiloSottile/mkcert)
- micro (https://micro-editor.github.io/ and https://github.com/zyedidia/micro - go terminal editor)
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
- mjson (https://github.com/cesanta/mjson - json parser/emitter/json-rpc engine)
  - frozen (https://github.com/cesanta/frozen - json parser/generator)
- mk (go, https://github.com/dcjones/mk)
- mold (https://github.com/rui314/mold - fast linker, gcc 10+ (or clang 12+) for c++20 i think?)
- moreutils (https://joeyh.name/code/moreutils/)
- moscow ml (https://github.com/kfl/mosml)
- mox (https://github.com/mjl-/mox - small mail server in go)
- mqtt-c (https://github.com/LiamBindle/MQTT-C)
- mpg123
- mpg321
- mruby (https://github.com/mruby/mruby)
- mrubyc (https://github.com/mrubyc/mrubyc)
- multimarkdown (https://github.com/fletcher/MultiMarkdown-6)
- munge (https://github.com/dun/munge - hpc auth environment, useful for cred auth against gpg(?) for e.g. diod)
- muon (https://github.com/annacrombie/muon - meson in c)
- muonsocks (https://github.com/niklata/muonsocks - c++ fork/rewrite(?) of microsocks with socks4a client support)
- mupdf (https://mupdf.com/ and https://github.com/ArtifexSoftware/mupdf - muraster, mutool build without X11/GL)
- musl stuff
  - musl-locales (https://github.com/rilian-la-te/musl-locales - cmake? seriously?)
  - musl-obstack (https://github.com/pullmoll/musl-obstack and/or https://github.com/void-linux/musl-obstack)
  - musl-rpmatch (https://github.com/pullmoll/musl-rpmatch - glibc compat rpmatch(3) yes/no response function)
  - musl-utils
    - getconf, getent, iconv
    - currently in **alpinemuslutils** recipe as `alpine-{getconf,getent,iconv}`
    - should these be in statictoolchain, i.e in https://github.com/ryanwoodsmall/musl-misc?
  - muslstack (https://github.com/yaegashi/muslstack)
  - musl-compat (https://github.com/Projeto-Pindorama/musl-compat - missing headers - cdefs, etc.)
  - musl-extra (https://github.com/Projeto-Pindorama/musl-extra - getconf, etc.)
- mutt
- mvi (https://github.com/byllgrim/mvi)
- nanomsg (https://github.com/nanomsg/nanomsg and https://nanomsg.org/)
  - cmake, no.
- nc / ncat / netcat
- ncurses components...
  - terminfo and termcap (http://invisible-mirror.net/archives/ncurses/current/)
  - replace/augment gnutermcap?
- ne (https://github.com/vigna/ne terminal editor)
- neat/litcave stuff (http://litcave.rudi.ir/)
  - neatcc (https://github.com/aligrudi/neatcc)
  - neatld (https://github.com/aligrudi/neatld)
  - neatas (https://repo.or.cz/neatas.git)
  - neatlibc (https://github.com/aligrudi/neatlibc)
  - neatroff (https://github.com/aligrudi/neatroff)
    - neatroff_make (https://github.com/aligrudi/neatroff_make)
  - neateqn (https://github.com/aligrudi/neateqn)
  - neatpop3 (https://github.com/aligrudi/neatpop3)
  - neatpost (https://github.com/aligrudi/neatpost)
  - neatrefer (https://github.com/aligrudi/neatrefer)
  - neatmkfn (https://github.com/aligrudi/neatmkfn)
  - neatsmtp (https://github.com/aligrudi/neatsmtp)
  - fbpdf (https://github.com/aligrudi/fbpdf)
  - fbvis (https://repo.or.cz/fbvis.git)
  - fbff (https://github.com/aligrudi/fbff)
  - fbpad (https://github.com/aligrudi/fbpad)
  - fbvnc (https://repo.or.cz/fbvnc.git)
  - troffp9 (https://github.com/aligrudi/troffp9 - plan 9 troff port)
- neko (https://github.com/m1k1o/neko and https://neko.m1k1o.net/#/ - virtual browser/desktop in docker???)
- netfilter.org stuff
  - ipset (https://www.netfilter.org/projects/ipset/)
  - ulogd (https://www.netfilter.org/projects/ulogd/)
  - xtables-addons
- nethack
- netkit (finger, etc. use rhel/centos srpm? http://www.hcs.harvard.edu/~dholland/computers/netkit.html and https://wiki.linuxfoundation.org/networking/netkit)
- nets (https://github.com/lkundrak/nets - network serial port)
- netsurf stuff
  - netsurf w/framebuffer nsfb? sdl? vnc doesn't seem to work
  - libnsfb (https://www.netsurf-browser.org/projects/libnsfb/)
- nfs-utils (http://git.linux-nfs.org/?p=steved/nfs-utils.git;a=summary and https://mirrors.edge.kernel.org/pub/linux/utils/nfs-utils/)
- nghttp3 (https://github.com/ngtcp2/nghttp3)
- ngtcp2 (https://github.com/ngtcp2/ngtcp2)
- nlnetlabs stuff
  - ldns (https://nlnetlabs.nl/projects/ldns/about/ and https://github.com/NLnetLabs/ldns - nlnet dns library, including drill (dig) client, dane support, etc.)
  - nsd (https://github.com/NLnetLabs/nsd and https://nlnetlabs.nl/projects/nsd/about/ - authoritative dns server)
    - nsd can be built against openssl, libevent, libsodium, nghttp2, expat, etc.
    - nsd can be made to work with uacme for DNS-01 challenges, needed for wildcard certs
      - https://gitlab.alpinelinux.org/alpine/infra/docker/uacme-nsd-wildcard
  - unbound (https://github.com/NLnetLabs/unbound and https://nlnetlabs.nl/projects/unbound/about/ - caching/recurisve dns resolver)
    - `dohclient`, `petal`, `readzone` from testcode dir all look interesting
- nnn (https://github.com/jarun/nnn)
- node / npm (ugh)
- noice (https://git.2f30.org/noice/)
- nopenbsd-curses (https://github.com/tch69/nopenbsd-curses - openbsd ncurses, but portable)
- nopoll (https://github.com/ASPLes/nopoll - websocket toolkit)
- notcurses (https://github.com/dankamongmen/notcurses)
- nq (https://github.com/leahneukirchen/nq)
- nss (ugh)
- nuitka (https://github.com/Nuitka/Nuitka and https://nuitka.net - python compiler using cpython)
- num-utils (http://suso.suso.org/programs/num-utils/index.phtml)
- nyacc (https://www.nongnu.org/nyacc/ and https://savannah.nongnu.org/projects/nyacc)
- obase (https://github.com/leahneukirchen/obase - unmaintained, see outils)
- octosql (https://github.com/cube2222/octosql - query+transform sql, in go)
- odbc?
  - iodbc?
  - unixodbc?
- odhcploc (http://odhcploc.sourceforge.net/ - dhcp locater)
- ofelia (https://github.com/mcuadros/ofelia - scheduler for docker jobs, ala cron)
- oleo (gnu spreadsheet, https://www.gnu.org/software/oleo/oleo.html)
- openadk (https://openadk.org/ and https://github.com/wbx-github/openadk - embedded system toolchain and image creation)
- openbsd-libz (https://github.com/ataraxialinux/openbsd-libz)
- opengit (https://github.com/khanzf/opengit)
  - original gist: https://gist.github.com/ryanwoodsmall/2cbce4664f13b95ec7b0385fcee0b957
  - bmake, libbsd, libmd, zlib, pkgconfig, fetchfreebsd{,libressl}, openssl/libressl
  - compiles with this but doesn't work...
  - ```
    sed -i.ORIG '/Unsure/s,^.*,#include <sha.h>,g' lib/common.h
    grep -ril __unused . | xargs sed -i.ORIG s/__unused//g
    sed -i.ORIG '/}.*__packed;/s, __packed,,g' lib/index.h
    echo '#include <sha.h>' >> src/hash-object.h
    # src/Makefile needs LDADD fixups for libs
    bmake clean
    bmake \
      CC="${CC} -I${PWD} $(pkg-config --{cflags,libs} libbsd-overlay) ${CFLAGS}" \
      CFLAGS="-I${PWD} $(pkg-config --cflags libbsd-overlay) $(echo -I${cwsw}/{libressl,libbsd,libmd,fetchfreebsdlibressl,zlib}/current/include)" \
      LDFLAGS="$(pkg-config --libs libbsd-overlay) $(echo -L${cwsw}/{libressl,libbsd,libmd,fetchfreebsdlibressl,zlib}/current/lib) -static"
    ```
- openresolv (http://roy.marples.name/projects/openresolv/ - resolvconf implementation)
- opensimh (https://github.com/open-simh/simh - pre-license change fork)
  - simtools (https://github.com/open-simh/simtools - tools for simulators/integration)
- openvi (https://github.com/johnsonjh/OpenVi - portable openbsd vi)
- opkg-utils (https://git.yoctoproject.org/opkg-utils - package build, etc.)
- orbitron (https://github.com/xyproto/orbiton - vt100 IDE in go)
- p11-kit (https://p11-glue.github.io/p11-glue/p11-kit.html)
  - probably not...
  - "cannot be used as a static library" - what?
  - needs libffi, libtasn1
  - configure ```--without-libffi --without-libtasn1```
- p9 (https://github.com/hugelgupf/p9 - go 9p client/server, with p9ufs server bin)
- pa (https://github.com/biox/pa - password manager in shell using age!)
- parenj / parenjs
- partcl (https://github.com/zserge/partcl and https://zserge.com/posts/tcl-interpreter/ - a small tcl interpreter)
- pax
- pciutils (https://github.com/pciutils/pciutils)
  - _/usr/share/misc/pci.ids_ file (https://github.com/pciutils/pciids)
- pdsh (https://github.com/chaos/pdsh or https://github.com/grondo/pdsh ?)
- perl-cross (https://github.com/arsv/perl-cross)
- pflask (https://github.com/ghedo/pflask - lightweight process containers)
- picocom (https://github.com/npat-efault/picocom)
- picohttpparser (https://github.com/h2o/picohttpparser - small, fast http protocol parser)
- pigz
- pkgconf (https://github.com/pkgconf/pkgconf - pkg-config-alike in c, opt-in only for now - not yet on path)
- planck (clojurescript repl, https://github.com/planck-repl/planck)
- pocketlang (https://github.com/ThakeeNathees/pocketlang and https://thakeenathees.github.io/pocketlang/)
- poke (http://www.jemarch.net/poke.html - gnu binary data editor/language)
- posixtestsuite (http://posixtest.sourceforge.net/ - old open posix test suite)
- premake (https://github.com/premake/premake-core and https://premake.github.io/ - lua build tool, brotli supports it?)
- privoxy (https://www.privoxy.org/ - filtering http proxy with filtering support, openssl/mbedtls support)
- prngd (http://prngd.sourceforge.net/ - for lxc? dropbear? old? hmm?)
- procps-ng (https://gitlab.com/procps-ng/procps)
  - needs autoconf, automake, libtool, ncurses, pkgconfig, slibtool
  - disable ```man-po``` and ```po``` **SUBDIRS** in _Makefile.am_
  - ```autoreconf -fiv -I${cwsw}/libtool/current/share/aclocal -I${cwsw}/pkgconfig/current/share/aclocal```
  - ```./configure ${cwconfigureprefix} ${cwconfigurelibopts} --disable-nls LIBS=-static LDFLAGS="-L${cwsw}/ncurses/current/lib -static"```
    - ```--disable-modern-top``` for old-style top
  - ```make install-strip LIBTOOL="${cwsw}/slibtool/current/bin/slibtool-static -all-static"```
    - slibtool require should make this automatic
- proot (https://proot-me.github.io/ and https://github.com/proot-me/proot - userspace containerizing/unprivileged reproducible environments+builds)
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
- qalc (https://qalculate.github.io/ - libqalculate and cli/text interface)
- quicssh (https://github.com/moul/quicssh - ssh client/server wrapper/proxy/tunnel using quic, go)
- quictls (https://github.com/quictls/openssl - openssl (3+?) patched with quic support, for ngtcp2+nghttp3)
- ragel (http://www.colm.net/open-source/ragel/)
- ranger (https://ranger.github.io - python)
- rawtar (https://github.com/andrewchambers/rawtar)
- re2c (http://re2c.org/ and https://github.com/skvadrik/re2c)
- redis (https://github.com/redis/redis and https://redis.io - tls, jemalloc, etc., options)
- redo-c (https://github.com/leahneukirchen/redo-c - djb's redo concept implemented in c instead of python)
- redsocks (http://darkk.net.ru/redsocks/ and https://github.com/darkk/redsocks - transparent proxy redirection)
  - requires libevent
  - needs iptables!!!
  - redsocks2 fork (https://github.com/semigodking/redsocks - more features?)
    - mbedtls (polarssl) doesn't seem to work?
    - openssl too new...
    - libressl seems to work
- reeva (https://github.com/ReevaJS/reeva - javascript engine for the jvm in kotlin)
- regx (https://github.com/wd5gnr/regx - regx and litgrep, literate regex)
- relational-pipes (https://relational-pipes.globalcode.info/)
- remake (http://bashdb.sourceforge.net/remake/ and https://github.com/rocky/remake)
- restic (https://github.com/restic/restic and https://restic.net/ - backups, in go, with an rclone REST backend!)
- reverse-ssh (https://github.com/Fahrj/reverse-ssh - reverse ssh/shell in go)
- rocksock-http (https://github.com/rofl0r/rocksock-httpd)
- rocksocks5 (https://github.com/rofl0r/rocksocks5)
- rover (https://lecram.github.io/p/rover)
- rpcbind (https://sourceforge.net/projects/rpcbind/ and http://git.linux-nfs.org/?p=steved/rpcbind.git;a=summary)
- rust (https://www.rust-lang.org/)
  - bootstrap? (https://guix.gnu.org/blog/2018/bootstrapping-rust/ - guix!)
  - mrustc (https://github.com/thepowersgang/mrustc - c++)
  - rust-gcc (https://rust-gcc.github.io/ and https://github.com/Rust-GCC/gccrs)
  - rustup (https://rustup.rs/)
- rvm?
- rw (https://sortix.org/rw/)
- rwc (https://github.com/leahneukirchen/rwc)
- rx (https://github.com/crcx/rx - forth(-ish) userspace! - gone?)
- sacc (https://git.fifth.space/sacc/log.html - gopher client)
- sbang (https://github.com/spack/sbang)
- scc (https://github.com/boyter/scc - sloc/cloc/code, code counter in go)
- scdoc (https://sr.ht/~sircmpwn/scdoc/ and https://git.sr.ht/~sircmpwn/scdoc - simple man page generator)
- scheme stuff:
  - bigloo
  - biwascheme (https://github.com/biwascheme/biwascheme and https://www.biwascheme.org/ - scheme in javascript)
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
  - loko (https://scheme.fail/)
  - micro-lisp (https://github.com/carld/micro-lisp)
  - minilisp (https://github.com/rui314/minilisp)
  - minischeme
    - https://github.com/ignorabimus/minischeme
  - mit/gnu scheme (requires gnu/mit scheme... to build... itself)
  - mosh (https://github.com/higepon/mosh and http://mosh.monaos.org/files/doc/text/About-txt.html)
  - oaklisp (https://github.com/barak/oaklisp)
  - otus lisp (https://github.com/yuriy-chumak/ol - ol, small purely functional scheme)
  - racket
  - rscheme (http://www.rscheme.org/rs)
  - s7 (https://ccrma.stanford.edu/software/snd/snd/s7.html)
  - scheme2c (https://github.com/barak/scheme2c)
  - sharpf (https://github.com/false-schemers/sharpF - minimalist scheme language builder)
  - sigscheme (https://github.com/uim/sigscheme)
  - siod (http://people.delphiforums.com/gjc//siod.html)
  - siof (https://github.com/false-schemers/siof - scheme in one file)
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
  - zuo (https://github.com/mflatt/zuo - small scheme, moving to be a part of racket; useful for bootstrapping?)
- sc-im (https://github.com/andmarti1424/sc-im - sc spreadsheet improved)
- sclient (https://telebit.cloud/sclient/ and https://github.com/therootcompany/sclient and https://git.rootprojects.org/root/sclient - ssl/tls tunneler in go)
- se (http://se-editor.org/ - screen editor)
  - https://github.com/screen-editor/se
  - or http://svn.so-much-stuff.com/svn/trunk/cvs/trunk/local.d/se.d/
  - or http://web.archive.org/web/20150929083830/http://www.gifford.co.uk/~coredump/se.htm
- seaweedfs (https://github.com/seaweedfs/seaweedfs - distributed filesystem/filer/s3/etc. in go, with a k8s csi driver)
- sed-bin (https://github.com/lhoursquentin/sed-bin - posix sed to c??? cool)
- selfdock (https://github.com/anordal/selfdock - container alike)
- selfie (https://github.com/cksystemsteaching/selfie - self-hosting riscv emulator/simulator, compiler, hypervisor, ...)
- shells and shell stuff
  - fish
  - gash (guile as shell, https://savannah.nongnu.org/projects/gash/)
  - ksh2020 (https://github.com/ksh2020/ksh - figure out this vs ast ksh93/forks/etc.)
  - mrsh (https://mrsh.sh/ - https://git.sr.ht/~emersion/mrsh and https://github.com/emersion/mrsh)
    - imrsh (https://git.sr.ht/~sircmpwn/imrsh - interactive mrsh)
  - pure sh bible (https://github.com/dylanaraps/pure-sh-bible - how to do things in shell that would otherwise require external programs)
  - rc (https://github.com/siebenmann/rc - chris siebenmann's rc fork - tobold/rakitzis rc with updates)
  - scsh (https://scsh.net)
  - sh (https://github.com/mvdan/sh - shell parser/formatter in go)
  - smoosh (http://shell.cs.pomona.edu/ and https://github.com/mgree/smoosh - very posix shell with formal mechnanism, in ocaml)
  - tcsh (and/or standard csh)
  - xs (https://github.com/TieDyedDevil/XS - rc+es+scheme/lisp - abandoned see es)
    - xs-library (https://github.com/TieDyedDevil/XS-library)
  - zsh
- shellcheck (https://www.shellcheck.net/ and https://github.com/koalaman/shellcheck - haskell)
- shini (https://github.com/wallyhall/shini - ini parser in shell)
- shit (https://git.sr.ht/~sircmpwn/shit - shell git???)
- shuffle (http://savannah.nongnu.org/projects/shuffle/)
- simplecpp (https://github.com/danmar/simplecpp)
- signify (https://github.com/aperezdc/signify - standalone openbsd signify)
- sish (https://github.com/antoniomika/sish - go tunnel tool)
- skarnet stuff
  - dnsfunnel (https://skarnet.org/software/dnsfunnel/ - dns cache fanout to udp)
  - nsss (https://skarnet.org/software/nsss/ - nscd/nss ish implementation)
- sljit (http://sljit.sourceforge.net/)
- sloccount (https://dwheeler.com/sloccount/)
- slre (https://github.com/cesanta/slre - super light regular expression library)
- smarden stuff
  - ipsvd (http://smarden.org/ipsvd/ - can use matrixssl?)
  - runit (http://smarden.org/runit/)
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
- sqlean (https://github.com/nalgeon/sqlean - useful additions for sqlite)
- squashfs-tools (https://github.com/plougher/squashfs-tools/tree/master/squashfs-tools)
- squid (http://www.squid-cache.org/ - perl, openssl/gnutls/nettle, expat/libxml2, libcap, ...)
  - wip w/config below, crashing on startup, may need dynamic perl...
  - see: https://git.alpinelinux.org/aports/tree/main/squid/APKBUILD
  - ```
    rm -rf $cwtop/tmp/squid-5.7-built
    make clean
    make distclean
    ( time (  ./configure --prefix=${cwtop}/tmp/squid-5.7-built --with-expat=${cwsw}/expat/current --with-openssl=${cwsw}/openssl/current --disable-loadable-modules --disable-optimizations --enable-shared=no --disable-shared --enable-static{=yes,} --enable-{icmp,ipv6,linux-netfilter,auth,esi} --disable-translation --disable-auto-locale --disable-arch-native CC="${CC} -Wl,-s -g0 -Os" CXX="${CXX} -Wl,-s -g0 -Os" CFLAGS="${CFLAGS} -Wl,-s -g0" CXXFLAGS="${CXXFLAGS} -Wl,-s -g0" LDFLAGS="${LDFLAGS} -s" ; echo $? ) ) 2>&1 | tee /tmp/blah.out
    ```
- sredird (https://github.com/msantos/sredird - network serial port redirector)
- srv (https://github.com/joshuarli/srv)
- sshuttle (https://github.com/sshuttle/sshuttle)
- sslwrap (http://www.rickk.com/sslwrap/ way old)
- starlark-go (https://github.com/google/starlark-go - starlark, python-like configuration language in go w/interpreter)
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
- sunwait (sunrise/sundown calculator/figurer - https://github.com/risacher/sunwait)
- svi (https://github.com/byllgrim/svi)
- tab (https://tkatchev.bitbucket.io/tab/)
- tack (https://github.com/davidgiven/ack and http://tack.sourceforge.net/ - the amsterdam compiler kit)
- taggins (https://github.com/bromanbro/taggins - easy, extended attr filesystem user.tags for files)
- taskwarrior (https://taskwarrior.org/ and https://github.com/GothenburgBitFactory/taskwarrior)
- taskserver (https://github.com/GothenburgBitFactory/taskserver)
- t3x.org stuff (nils holm)
  - klisp (http://t3x.org/klisp)
  - s9fes (https://www.t3x.org/s9fes https://github.com/bakul/s9fes and https://github.com/barak/scheme9)
  - subc (https://www.t3x.org/subc)
- tcc (http://repo.or.cz/w/tinycc.git)
  - static compilation is _pretty broken_
- tcpredirect (https://github.com/chengyingyuan/tcpredirect - keyed redirect/proxying?)
- tidy (https://github.com/htacg/tidy-html5 - cmake)
- timewarrior (https://timewarrior.net/ and https://github.com/GothenburgBitFactory/taskwarrior)
- tlsclient (https://git.sr.ht/~moody/tlsclient - plan 9 tlsclient for unix, with openssl?)
  - x9utils (https://github.com/halfwit/x9utils - ditto, with some additions)
- tlse (https://github.com/eduardsui/tlse - c tls impl using libtomcrypt)
- tlsproxy (https://github.com/abligh/tlsproxy - simple gnutls stunnel alike; may need some work, compiles but crashes w/access from chrome; seems to behave with curl?)
- torgo (https://github.com/as/torgo)
- tpm (https://github.com/nmeum/tpm/ - tiny password manager)
- transocks (http://transocks.sourceforge.net/ - transparent socks, needs dante/nec socks libs)
  - transocks_ev (http://oss.tiggerswelt.net/transocks_ev/README - libevent transparent socks-5 with iptables)
- tre (https://github.com/laurikari/tre)
- troglobit stuff
  - finit (https://github.com/troglobit/finit)
  - libite (https://github.com/troglobit/libite - sys/queue, sys/tree interfaces in lite/)
  - merecat (https://github.com/troglobit/merecat)
  - mping (https://github.com/troglobit/mping - multicast ping)
  - smcroute (https://github.com/troglobit/smcroute and https://troglobit.com/projects/smcroute/)
  - ssdp-responder (https://github.com/troglobit/ssdp-responder - windows network thing w/internet gateway device config?)
  - sysklogd (https://github.com/troglobit/sysklogd - bsd syslog on linux, newer rfc compliant)
  - ttinfo (https://github.com/troglobit/ttinfo)
  - uftpd (https://github.com/troglobit/uftpd)
  - uget (https://github.com/troglobit/uget - small wget/curl file fetcher w/openssl support - investigate libressl/wolfssl compat...)
- tsocks (http://tsocks.sourceforge.net/)
- ttdnsd (http://www.mulliner.org/collin/ttdnsd.php - tor tcp dns daemon, can work with socks, udp+tcp, etc. to relay dns)
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
- ublinter (https://github.com/danmar/ublinter)
- ubridge (https://github.com/GNS3/ubridge - udp, ethernet, tap, etc. userspace bridge controller)
- u-config (https://github.com/skeeto/u-config - minimal pkg-config alike)
- udptunnel (http://www.cs.columbia.edu/~lennox/udptunnel/)
- uget (https://github.com/OpenIPC/uget - tiny http-only wget/curl program)
- uniso (from alpine https://github.com/alpinelinux/alpine-conf/blob/master/uniso.c)
- units (https://www.gnu.org/software/units)
- up (https://github.com/akavel/up - ultimate plumber, a pipe explorer in go)
- upx (https://github.com/upx/upx)
- u-root (https://github.com/u-root/u-root - go userland w/bootloaders, may be useful!)
- usbutils (https://github.com/gregkh/usbutils)
- utalk (http://utalk.ourproject.org/)
- uwebsockets (https://github.com/uNetworking/uWebSockets - c++ lib that supports openssl/wolfssl)
- vcluster (https://github.com/loft-sh/vcluster and https://www.vcluster.com - k8s inside a k8s namespace, cluster virtualization)
- vde (virtual distributed ethernet, https://github.com/virtualsquare/vde-2)
- vera / vera++ (bitbucket? github?)
- vifm (https://github.com/vifm/vifm)
- vpnc
  - **vpnc-script** needs to ignore unknown "via ??? ???" output from ```ip route```
  - **config.c** needs proper **vpnc-script** and **default.conf** paths
- wasm stuff... (most need rust and/or cmake, python3, etc.!)
  - awesome-wasm-runtimes (https://github.com/appcypher/awesome-wasm-runtimes - bunch of potential stuff here)
  - binaryen (https://github.com/WebAssembly/binaryen - includes `wasm2js` tool to run wasm on top of javascript)
  - cowasm (https://github.com/sagemathinc/cowasm - collaborative webassembly, shell, in zig, with python, unix ports, etc.!)
  - lucet (https://github.com/bytecodealliance/lucet)
  - posish (https://github.com/bytecodealliance/posish)
  - w2c2 (https://github.com/turbolent/w2c2 - compiles webassembly to c)
  - wabt (https://github.com/WebAssembly/wabt)
  - wasi (https://github.com/bytecodealliance/wasi and https://github.com/WebAssembly/WASI)
  - wasi-libc (https://github.com/WebAssembly/wasi-libc)
  - wasi-sdk (https://github.com/WebAssembly/wasi-sdk - wasm toolchain w/wasi-libc, needs cmake/clang/ninja)
  - wasm3 (https://github.com/wasm3/wasm3)
  - wasmedge (https://github.com/WasmEdge/WasmEdge - wasm runtime from cncf)
  - wasmer (https://github.com/wasmerio/wasmer - cross-platform webassembly binaries everywhere)
    - wapm (https://wapm.io - webassembly package manager)
  - wasmtime (https://github.com/bytecodealliance/wasmtime and https://github.com/bytecodealliance/wasmtime)
  - wasmtime-cpp (https://github.com/bytecodealliance/wasmtime-cpp)
  - wasm-c-api (https://github.com/WebAssembly/wasm-c-api)
  - wasm-micro-runtime (https://github.com/bytecodealliance/wasm-micro-runtime)
  - wasm-tools (https://github.com/bytecodealliance/wasm-tools)
  - wasp (https://github.com/WebAssembly/wasp)
  - wazero (https://github.com/tetratelabs/wazero and https://wazero.io - webassembly runtime in go, zero deps?)
  - web49 (https://github.com/FastVM/Web49)
- watchexec (https://github.com/watchexec/watchexec - notify/event/file watching+execute something, in rust)
- webcat (https://git.sr.ht/~rumpelsepp/webcat - go, see https://rumpelsepp.org/blog/ssh-through-websocket/)
- webhook (https://github.com/adnanh/webhook - webhook to shell server in go)
- websocat (https://github.com/vi/websocat - rust)
- websocket.sh (https://github.com/meefik/websocket.sh - busybox+ash ws server)
- websocketd (go, https://github.com/joewalnes/websocketd)
- websockify (https://github.com/novnc/websockify)
- werc (http://werc.cat-v.org/ - suckless wikiblogthing)
  - useful awk stuff: `md2html.awk`, `urldecode.awk`, and `urlencode.awk`
  - can be coaxed to work with busybox httpd but is unpleasant
  - mini_httpd, thttpd, or lighttpd probably better options
- whatshell.sh (https://www.in-ulm.de/~mascheck/various/whatshell/ and https://www.in-ulm.de/~mascheck/various/whatshell/whatshell.sh)
- wireproxy (https://github.com/octeep/wireproxy - wireguard client that exposes a socks5 proxy)
- wolfssl-examples (https://github.com/wolfSSL/wolfssl-examples - lots of wolfssl docs/demos)
- wolfssl osp (https://github.com/wolfSSL/osp - "open source project" ports for wolfssl)
  - stunnel, etc.
  - nice... some don't seem to work
- wordgrinder (https://github.com/davidgiven/wordgrinder - word processor)
- wrp (https://github.com/tenox7/wrp - web rendering proxy)
  - docker container build instead?
- wren (https://wren.io/ and https://github.com/wren-lang/wren)
- wsServer (https://theldus.github.io/wsServer/ and https://github.com/Theldus/wsServer - websocket server in c)
- wsupp-libc (https://github.com/arsv/wsupp-libc - small wpa supplicant alike?)
- wuffs (https://github.com/google/wuffs - "wrangling unsafe file formats safely," a safe language, with c interop)
  - examples: https://github.com/google/wuffs/tree/main/example
    - bzcat, cbor-to-json, crc32, json-to-cbor, jsonptr, etc.
- xe (https://github.com/leahneukirchen/xe)
- xq (https://github.com/jeffbr13/xq)
- xserver-sixel (https://github.com/saitoha/xserver-sixel)
- yaml-cli (https://github.com/OpenIPC/yaml-cli - r/w mini yaml filter/editing tool)
- yggdrasil (https://github.com/yggdrasil-network/yggdrasil-go - opportunistic ipv6 mesh network in go)
- yq (https://github.com/kislyuk/yq - jq for yaml, python+jq)
- ytalk (http://ytalk.ourproject.org/)
- z3 (https://github.com/Z3Prover/z3)
  - cppcheck can use/may require this for 2.x+
- zeromq (https://github.com/zeromq/libzmq and https://zeromq.org/)
- znc (https://github.com/znc/znc and https://wiki.znc.in/ZNC - irc bouncer)
- zon (https://github.com/Aygath/zon - date/time with sunrise/sunset info)
- zork (https://github.com/devshane/zork - it's zork dude)
- support libraries for building the above
- whatever else seems useful

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
