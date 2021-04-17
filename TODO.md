# TODO

- allow underscores in recipe names?
  - i.e., `something_special`
  - would make parsing easier for variants
    - special per-recipe handling in ${rname}.sh.common
    - i.e., curl w/bearssl+mbedtls+wolfssl function template templates but generalized
  - not a bad idea
- `${rrealname}`
  - recipe var for when rname is ugly and reinplace ${..//../..} is too ugly?
- `staticfiles` recipe
  - capture stuff under e.g. **/etc/** from other (alpine/busybox:musl/centos/ubuntu/debian) distros
  - would make container construction much more robust
- `cwftpfetch` - detect ftp:// downloads and use `busybox wget -O /path/to/file.download ftp://site.tld/pub/file.download`
  - google deprecated FTP in chrome, which is theirs...
  - but also disabled it in curl, which is just great
  - ugh, sick of this crap
- remove renamed `cwlistreqs_${rname}` functions (now `cwreqs_${rname}`)
- move **FLAGS** vars to `CW_` prefix?
  - avoid polluting environment?
  - explicitly set i.e. `LDFLAGS="${CW_LDFLAGS}"` or similar in builds for configure/make commands
  - complicates things but leaves running environment cleaner
  - flags vars:
    - CFLAGS
    - CPPFLAGS
    - CXXFLAGS
    - LDFLAGS
    - PKG_CONFIG_LIBDIR
    - PKG_CONFIG_PATH
- `cw{{c,cpp,cxx,ld}flags,pkgconfig}_${rname}` functions
  - generated dynamically based on prereqs
  - recursive, so... slow
  - similar to recursive `cheupgradereqs_${rname}`
  - would further cleanup environment - could be turned off completely
  - makes integration with other build systems/tools cleaner...
- `crosware version`
  - output git commit, via `git rev-parse HEAD`
  - git or jgitsh should work
- `cwurl_${rname}` for bootstrap recipes
  - dump the `${rurl}` for easy reference
  - general case done
  - still need to normalize for...
    - jgitsh
    - statictoolchain
    - zulu
- `cwrecipefile_${rname}` function
  - return recipe filename with full path
  - i.e., `crosware run-func cwrecipefile_bash` should return `/usr/local/crosware/recipes/bash/bash.sh`
  - could be useful with `scripts/update-recipe-file.sh`
  - or making `update-recipe-file` a verb with a recipe and version passed in
- most functions should be moved out of `bin/crosware`
  - `etc/functions/cwfuncname.sh` is logical home
  - easier to test, branch, etc.
- musl 1.2.0
  - some breaking changes on 32-bit arch due to 64-bit time type(s)
  - Alpine should be going to 1.2.0 in their 3.12.x series
  - ... so I'm waiting for them to guinea pig and do the hard work
  - mostly untested by me, but don't foresee any showstoppers
  - yes I'm lazy
  - done:
    - ```muslstandalone``` package added to test C-only builds
    - ```-D__STDC_ISO_10646__=201103L``` for libedit/netbsdcurses wchar???
      - ```201206L``` should be defined in stdc-predef.h as well
      - http://lists.busybox.net/pipermail/buildroot/2016-January/149100.html
- eliminate subshells, **``**, ```$(..)``` where possible
  - use bash string manipulation in place of tr/sed/awk
  - speed up sourcing/parsing/execution significantly
- need to set ```set -o pipefail```? prolly
  - and ```trap...```
  - and use ```... ||:``` as a ```... || true``` shortcut
  - `set -o pipefail` breaks this for some reason (subshell, probably? `grep -q` maybe, works fine w/o `-q`?):
    - ```if ! $(set | grep -q "^cwinstall_${recipe} ") ; then ... ; fi```
  - this works in its stead:
    - ```
         set | grep "^cwinstall_${recipe} " >/dev/null 2>&1
         if [ ${?} -ne 0 ] ; then ... ; fi
      ```
- check that we are running as root
  - note on perms if sudo/root is not wanted
- top directory (/usr/local/crosware)
  - will need to checkout repo in ```$(dirname ${cwtop})```
  - software install dir (/usr/local/crosware/software/packagename/packagename-vX.Y.Z)
  - download dir (/usr/local/crosware/download or ~/Downloads)
  - build dir (/usr/local/crosware/build)
  - current/previous symlinks for versioned installs
  - ignore directories with generated files (path, cpp/ld flags, ...)
  - ignore software install dir
- files to source w/path, compiler vars, pkg-config, etc.
  - top-level etc/profile to source
  - sources an etc/local and/or etc/local.d with shell snippets (obvious, local settings)
  - reads in generated shell snippets (one per package) to set:
    - PATH (etc/paths.d)
    - CC, CXX, CFLAGS, CXXFLAGS, CPPFLAGS, LDFLAGS (etc/cppflags.d, etc/ldflags.d, ...)
    - PKG_CONFIG_PATH, PKG_CONFIG_LIBDIR (etc/pkg-config.d)
- dependencies and dependants (maybe?)
  - simple directory of files with pkgname.dependents, pkgname.dependencies
- install must chase down upstream deps
- update may require downstream req/upstream dep updates
  - var/deps/recipename/depname
  - var/reqs/recipename/reqname
  - update-reqs / update-deps commands
    - given a package, update its downstream requirements or upstream dependents
  - prequisites instead of reqs?
  - confusing naming
- etc/local.d - scriptlets, not tracked in git
- var/ - track installs/versions
- update environment without rebootstrap/resourcing `${cwetc}/profile`
- profile.d file writer
- zulu, jgitsh, statictoolchain split out to separate install functions
  - trim down bootstrap/make
  - make them easier to upgrade
  - and cwbootstrap_... for statictoolchain/zulu/jgitsh
  - much easier to do that for manually installed git clones
  - can run individual steps with cwrunfunc
- recipes
  - rname - recipe name
  - rver - recipe version
  - "release" versions
    - rrel - internal release to aid upgrade? default to 0! ```: ${rrel:=0}``` - XXX
    - river - ${rver}-${rrel}, version number plus recipe versioning! ```: ${river:="${rver}-${rrel}"}``` - XXX
    - ${cwtop}/var/inst contains ${river} for easy recipe version change tracking
    - not necessary for bootstrap recipes yet, or ever?
    - install dir needs to reflect installed version? see ridir
  - rbreqs - split rreqs into normal requirements (rreqs) and build requirements
  - rbdir - recipe build dir
  - rtdir - recipe top dir where installs are done
  - ridir - versioned recipe install dir
    - this may need to be versioned for releases, i.e.: ```${ridir}-${river}```?
    - do not like this, complicates configure args, and manual, etc. installs
    - not strictly necessary if upstream/downstream can be easily be computed and stored on install!
  - rprof - profile.d file
  - rdeps / rbdeps? - deps and build deps?
  - rdesc - recipe description?
  - rsite - url for recipe
  - rlicense - license
  - rcommonconfigureopts - recipes that have a common set of options (curl, ncurses, lynx) can bundle these here
  - rconfigureopts - can set here instead of defining custom *cwconfigure_*
  - ropts - gate off common functions with _nomake_, _nomakeinstall_, etc.
  - rarches - list of supported arches, default all
  - rold - list of old versions to clean up recipes that do not fully remove rdir?
  - need to set sane default r* values in common.sh with ```: ${rblah:="blah.setting"}```
  - unset vals after parse so there is no bleed through?
  - generic profile.d generator
    - find bin dir, append_path it
    - find pc files, append_pkgcfg the dirs
    - libs...
    - inclues...
  - custom/pre/post functions
  - ```cwupgradepost_${rname}```
    - default to `true`
    - per-recipe, can call ```cwupgradedeps_${rname}``` to get upstreams who require us
    - i.e., openssl -> curl -> git wouldn't pick up libssh2 until after curl is compiled based on alpha
    - need that _graph_
    - this is mapreduce. ah. ahhh
  - ```cwupgradedeps_${rname}```
    - relies on ordering to rebuild things, not do double upgrades, etc...
    - ```
      for r in ${!cwrecipereqs[@]} ; do
        if $(echo ${cwrecipereqs[${r}]} | tr ' ' '\n' | grep -q "^${rname}$") ; then
          cwupgrade_${r}
        fi
      done
      ```
    - **REALLY NEED THAT GRAPH TO MAKE THIS EFFICIENT**
  - ```cwupgrade_${rname} function```
    - uninstall/reinstall by default, checking downstream reqs to upgrade
    - cwreinstall_... as well? alias/wrapper?
      - reinstall implemented as a global that calls `cwuninstall ${rname} ; cwinstall ${rname}` w/o upgrades
      - could be moved to cwreinstall_${rname} doing the same to customize per recipe
  - ${cwconfigureprefix} leaks through
    - need to unset with r* vars
  - need a ```cwshowenv_${rname}()``` function
    - dumps an installed recipe environment
    - separate out **etc/profile** functions into separate source-able script
  - manifest
    - ```${cwtop}/var/manifest/${recipe}```
    - list of every file with SHA-256 (512?) under ```${cwsw}/${recipe}/current/```
- recipe/function names
  - need _ instead of -
- whatprovides functionality
  - given a program or dir/subdir/blah path pattern dump the all directory names under software/ that match
  - generate index of files at install time
- os detector
  - chrome os/chromium os
  - alpine
  - centos
  - debian
  - ubuntu
- deleted recipes cannot be uninstalled (i.e, break when moving bison.sh to .OFF)
- cppflags/ldflags need to have dupes removed
- setup a sysroot directory structure?
  - perl recipe has a simple example
  - fake /bin, /lib, /usr/bin, /usr/include, /usr/lib from static toolchain
  - link in/bind mount
  - add busybox/toybox (and real bash) for a chroot-able environment?
  - ```sysroot``` command? - create sysroot
  - ```sysroot-archive``` command? - create a sysroot and archive to **crosware-sysroot.tar.gz** or similar
- man wrapper
  - busybox (man), less, groff
  - sets PAGER to (real less) ```less -R```
  - MANPATH?
- need a fallback mirror
- XXX - unset recipe vars should be a list
- XXX - cwinstall() should likely use associative array to only do a single install
  - i.e., ```crosware install make m4 make flex make``` should only install the make recipe *once*
- XXX - zulu/statictoolchain/jgitsh should have cwinstall/cwname/cwver/_... funcs
- XXX - downloads now go into ${cwdl}/${rname}/${rfile}
  - and all fetching should happen in cwfetch_recipe func
  - can run offline after all fetches are done
- XXX - use wget instead of curl?
  - ```wget -O -``` works (as does busybox version, which should be available everywhere
  - ssl/tls with busybox version may be funky
  - curl could theoretically bootstrap itself...
  - ... but openssl req needs perl, which requires things that need curl
    - wolfssl is smaller than openssl
    - mbedtls is smaller still
- make jobs may need common cwmakeopts var
  - i.e., `make -j${cwmakejobs}`
  - environment-friendly, i.e.:
  - ```: ${cwmakejobs:="$(($(nproc)+1))"}```
- ```strip``` script command
  - traverse ${cwtop}/software/*/*/bin/ and run ```strip --strip-all``` on any ELF binaries
  - corresponding ```${cwstrip_recipe}``` stage and ```${rstriptarget}``` recipe var defaulting to _**bin/\***_.
- compiler opts
  - http://www.productive-cpp.com/hardening-cpp-programs-executable-space-protection-address-space-layout-randomization-aslr/
  - pic/pie/...
  - need to explore -fpic/-fPIC and -fpie/-fPIE and -pie
    - -fPIC works on x86_64/aarch64 at least
    - manually specified for now in recipe opt
  - -static-pie in GCC 7/8/+
  - force -static-libgcc -static-libstdc++
- ```archive``` step/script command to save tar of installed binary dir?
- LDFLAGS is over-expanded here, can probably remove \${LDFLAGS}
  - cannot set to bare ```-static``` in etc/profile and remove it from statictoolchain profile.d
  - statictoolchain profile.d file is self-contained, do not need any more environment to use it
  - do not muck with that
  - do something like this in etc/profile after all shell snippet parsing:
    - ```export LDFLAGS="-static ${LDFLAGS//-static /}"```
  - otherwise need a hash of seen flags to trim dupes, that gets slow if generalized
- need CW_EXT_GIT functionality
  - override provided jgit
  - ```CW_GIT_CMD```?
  - jigtsh/git should also provide ```${cwgitcmd}```
  - prefer git over jgitsh?
- hardlinks in statictoolchain archives?
  - should be symlinks, but may not be
- cwgenrecipe list
  - generate an .md with recipe names, versions, sites, etc.
- replace etc/profile append/prepend function subshells with ```if [[ ${1} =~ ${FLAGS} ]]```
  - speeds up processing of environment by ~2x
  - does not work for CPPFLAGS/LDFLAGS? becaues of -I or -L? or...?
  - looks like an early vs late eval thing when pattern matching using ```if [[ ... =~ ... ]]```?
- ```run-command``` function?
  - run a command in the crosware environment
  - useful for pkg-config, etc.
- function to update config.sub, config.guess, etc.
  - add a recipe for it?
  - http://git.savannah.gnu.org/gitweb/?p=config.git
- certs for openssl/wolfssl/mbedtls/gnutls/...
- recipes that need autoreconf/libtoolize/etc. flag
- recipes that are libraries w/--enable-static and the like need a flag
- cwextract
  - which form to use? is this simpler?
  - separate out (de)compressor from (un)archiver?
    - ```bzcat ${archive}    | tar -C ${tgtdir} -xf -```
    - ```gzip -dc ${archive} | tar -C ${tgtdir} -xf -```
    - ```xzcat ${archive}    | tar -C ${tgtdir} -xf -```
  - add decompressors to prereqs check
- per-recipe environment variable listing declared variables
  - unset at end of recipe to discourage env var leaks
  - unset in main script as well to double-check
  - compare before/after environment and bail if anything is left dangling
- log builds
  - something like ```... 2>&1 | tee ${cwtop}/var/log/builds/${TS}-${rname}.out``` on main cwinstall() and for each prereq in cwcheckreqs_${rname}()
  - probably need associated log cleaning command
- native linux32/linux64 personality environment variable based on ${karch} for ```busybox setarch ____ -R cmd``` to disable ASLR
  - or just use util-linux ```setarch $(uname -m) -R cmd```?
- linting, testing
  - bats (https://github.com/sstephenson/bats)
  - shellcheck (https://www.shellcheck.net/ and https://github.com/koalaman/shellcheck)
- static tool chain vars:
  - can be used to contruct a sysroot (i.e., in perl recipe)
  - cwstarch: ```gcc -dumpmachine```
  - cwsttop: ```cd $(dirname $(which gcc))/../ && pwd```
  - cwstbin: ```${cwsttop}/bin```
  - cwstlib: ```${cwsttop}/lib```
  - cwstabin: ```${cwsttop}/${cwstarch}/bin```
  - cwstainclude: ```${cwsttop}/${cwstarch}/include```
  - cwstalib: ```${cwsttop}/${cwstarch}/lib```
- prereqs really need to be a graph
  - ```install```, ```upgrade-all``` need to work on a dag
    - check prereq installed _or_...
    - check if installed prereq needs upgrade
    - recursively chase down to "root", i.e., until prereq graph is empty (or has only **make**)
    - only do this once - expensive
    - per-recipe...
      - ```${rchased[${recipe}]}={0,1}```
        - for each recipe
          - list reqs
            - mark ourself chased
            - mark reqs unchased
          - for each req
            - list reqs
              - recursively
              - append to list
              - chase...
      - ```${rfound[${rceipe}]}={0,1}```
        - if we find our own name as found, cycle?
      - shortest reqs first?
      - flatten list?
    - would `tsort` (coreutils, heirloom, sbase) come in handy here?
- need custom **cwclean_${rname}** for recipes where ```${rdir} != ${rbdir}``` and ```${rbdir} != ${cwbuild}/${rdir}```
- systems where ```/bin/sh``` is not bash...
  - wolfssl autotools-generated configure needs bash?
  - other autoconf/automake/libtool recipes seem fine?
  - right after ```libtool ... ; autoreconf ...``` run:
    - ```sed -i '/^#!/s#/bin/sh#/usr/bin/env bash#g' configure```
  - ...
- versioned symlinks for packages with state...
  - ncurses
  - openssl
  - ???
- evaluation
  - convert all ```${...}``` vars in recipes to ```\${...}``` to force later expansion/evaluation?
  - convert any ```\"...\"``` escapes in **eval** blocks (recipes) to ```'...'```
- binary packaging?
  - possibly build _.ipk_ files and include **opkg** for binary installation?
  - _.tar_ would suffice
  - hosting, ugh, signing, ugh, verification, ugh, ugh,
    - local only _package/_ directory
  - packages have to have a release version
  - packages are obviously per architecture
    - has to be captured in naming
  - naming: **${rname}-${rver}-${rrel}.${rarch}.ext**
    - does this suffice?
    - very RPM-ish
    - _no_ "noarch" packages
    - not worried about duplicates/wasted space
  - would need a reliable way of getting...
    - _software/_ directory for recipe
    - _etc/profile.d_ file
    - _var/inst_ file
  - command set...
    - ```crosware create-package ...``` - (possibly build/install and) archive a recipe
    - ```crosware install-pacakge ...``` - extract the package archive, create the _current/_ symlink
      - need version, release, etc.
  - graph would come in handy here, again
  - this sort of relies on a downstream requirement tracker and ability to rebuild dependents
- recipe patching
  - patch handling...
    - working but needs tweaks
    - if `${cwtop}/recipes/${rname}/${rname}.patches` exists, fetch - `cwfetchpatches_${rname}`, call from `cwinstall_${rname}`
    - apply after `cwextract_${rname}`, before `cwconfigure_${rname}`, flesh out `cwpatch_${rname}` cw_...
    - split patch lines on ','
    - last element **must** be patch level
    - `s=$(echo ${line} | tr , ' ') ; if [ ${#s[@]} == 3 ] ; c=${s[2]} ; else c=0 ; fi`
      - just pass the dang context
    - readline is good new dev, bash for existing
  - AVOID AS MUCH AS POSSIBLE
    - _sed_ in ```cwconfigure_${rname}``` is easy enough
    - sucks for patch series though
  - dummy, unreferenced ```cwpatch_${rname}``` and ```cwfetchpatches_${rname}``` for now
  - bash/bash4 recipes have working implementations
    - **bash.patches** and **bash4.patches** have comma-separted patch urls and sha256sums and context
  - really needs to be bundled in ```cwinstall_${rname}```? before configure?
  - generalize **recipe.patches** files
    - url
      - generate filename (for direct-download files) with something like ```basename ${patchfileurl} | xargs basename | tr '[:punct:]' ' ' | sed 's/ /./;s/ /_/g'```
      - make filename just `${sha256sum}.patch`??? - XXX may make sense...
    - sha256sum
    - need a relative path from the top of **${rdir}**?
    - just apply in order
    - need to pick a delimiter
      - `,`
- cpu translation table
  - x86-64 (qemu)
  - armv8l
  - ...
  - with ```k1om``` qemu x86_64 translation, uname -m returns/karch is set to ```x86-64``` and that is not a supported arch
  - map "uname -m" to supported_arch
- easier url download filename generation
  - url -> filename might look something like:
```shell
#
# cwurltofilename
#   receives a url
#   outputs a filename
#
#   XXX - urlencode url before [[:punct:]] -> _ replacement?
#   XXX - base64 urls/filenames to more uniquely identify output file?
#
function cwurltofilename() {
  local u="${1}"
  local f="${u##*/}"
  if [ -z "${f}" ] ; then
    f="${u}"
  fi
  local o="${f//[[:punct:]]/_}.crosware_download"
  echo "${o}"
}
```
- generalize binary prereq check
  - add ${CW_GIT_CMD} to check if not using jgitsh, i.e. ${CW_USE_JGIT}==false
- add new var to disable automatic installation of statictoolchain
  - CW_USE_STATICTOOLCHAIN
- env var naming
  - names should reflect recipe/package names
    - CW_USE_JAVA should be CW_USE_ZULU
    - CW_USE_JGIT should be CW_USE_JGITSH
- canonical arch?
  - armv6l/armv7l/armv8l (aarch32hf) are the same
  - makes zulu/statictoolchain more complicated than need be
- pkg-config
  - need to figure out curl, zlib, libcrypt/libssl/openssh, libssh2 interplay
    - Requires:?
    - Libs:?
  - .pc verisons need to be masked w/current
    - s#${ridir}#${rtdir}/current#g
- limit path to crosware stuff
  - basically ```env PATH=$(echo ${PATH} | tr ':' '\n' | grep ${cwtop}/ | xargs echo | tr ' ' ':')```
  - cwpath? cwrestrictedpath?
- probably need to do a ```checkbashisms``` thing
- remote version checker for regular urls
  - feed to update recipe file script
- ```update-recipe``` command to check/update/build/commit new versions automatically
  - new ```cwrecipe_checkupdate``` per-recipe function
- ```append_env``` environment wrapper for _profile.d_ files
- cacertificates
  - probably need openssl/c_rehash
    - don't require it in recipe, only if not found ```which c_rehash || cwinstall_openssl ; cwsourceprofile```
    - perl script
    - centos package is openssl-perl, debian is just openssl
  - use alpine c_rehash.c?
    - https://git.alpinelinux.org/ca-certificates/tree/c_rehash.c
    - requires python3?
- mystical single static binary git clone/checkout/fetch/merge/clean (opts? --quiet? -b?) client
  - libgit2 (recipe in crosware now)
  - simplify... use? meh?
    - libulz: https://github.com/rofl0r/libulz
    - libmowgli: https://github.com/atheme/libmowgli-2
- locking?
  - in ```${cwtop}/tmp/crosware.lockfile``` or something?
  - would need a trap and handler to prevent/cleanup stale lockfiles
  - semaphore???
  - what am i doing
- cwtime wrapper
  - seconds elapsed
  - useful for cwinstall_ functions
  - something like...
```
#!/bin/bash

set -eu

function test_func() {
  echo sleeping 3
  sleep 3
}

function test_arg() {
  echo ${#} args
  for a in "${@}" ; do
    echo arg ${a}
  done
  echo sleeping 5
  sleep 5
}

function time_func() {
  local sts
  local ets
  sts="$(date '+%s')"
  "${@}"
  ets="$(date '+%s')"
  echo time elapsed $((${ets}-${sts}))s
}

time_func test_func
time_func test_arg 1 two "three four"
time_func ls -l -A /
```
- cwgenmeta_rname() and cwcheckmeta_rname()
  - crosware check-recipe rname
  - save sha256sum of files in ${ridir} to /var/meta/rname
  - find ${ridir}/ -type f | sort | xargs sha256sum > /var/meta/rname
  - if ! -e /var/meta/rname don't run
- upgrade-all-recursive
  - on upgrade, chase down rreqs updates and install them if any
  - cwupgradable[rname]=0 by default
  - if upgradable, set to 1
  - check by package
  - hash is quicker
  - eliminate expensive calls to get/list installed if possible
- cwisancestor / cwisdescendant
  - cwisancestor a b
    - if b requires a
      - return true
    - return false
    - cwrequires b a
  - cwisdescendant a b
    - if a requires b
      - return true
    - return false
    - cwrequires a b
- cwrequires a b
  - receives two package names
  - if package a requires package b
    - return true
  - return false
- cwupgradereqs / cwupgradedeps
  - really need graph
  - at LEAST a full req expansion (probably recursive descent)
  - requirement ordering matters here too
  - ugh, hard, particulary in this tarpit i adore
  - for every upgradable package
    - for any downstream ancestors
      - check if upgradable, chase if not
      - recurse reqs, upgrading if necessary
    - for upstream descendants
      - check its downstreams, upgrading recursively
      - if there are upstreams
    - too easy to loop forever here, ping ponging between up-/downstream
    - without ordering, can rebuild multiple recipes way too many times
- busybox ssl_helper after 1.13.1 is stable
  - wolfssl: https://git.busybox.net/busybox/tree/networking/ssl_helper-wolfssl/README?h=1_31_stable
  - matrixssl: https://git.busybox.net/busybox/tree/networking/ssl_helper/README?h=1_31_stable
- default to `-Os` for CC-/CXXFLAGS?
  - optimize for size, not perf
  - need to test
- test bootstrap/operation with different userspaces
  - make modular in container build(s)
    - busybox (default)
    - toybox
    - sbase-box/ubase-box
    - coreutils/util-linux
    - heirloom
    - 9base/???
    - ...
- bootstrap other distros
  - deb,rpm busybox workalikes
  - add apk
  - reinstall / leaving crosware intact
  - weird
- sourcing
  - use `.` everywhere
  - https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
  - `(return 0 2>/dev/null) && sourced=1 || sourced=0`
- other shells?
  - had other interop here but only `zsh` and `ksh93` have enough juice to play nicely
  - userspace (i.e., `. ${cwtop}/etc/profile`) might be able to be made to work better with `ash`, `dash`, and `ksh88`
  - nothing except `bash` is a priority, might not be worth the effort
- configs...
  - store in `${rtdir}/etc` or the like? (dropear, lynx, ...)
  - or in `${cwetc}/${rname}` with a subset of known/ignored configs? (ssh, dnsmasq, ...)
  - central is easier to insure upgrade doesn't wipe config but can lead to broken centralized conf
  - bundled with app is cleaner but more dangerous
  - both bad options
- ssh back into chrome os via `~/.ssh/config`:
  - requires busybox, dropbear, screen
  - key auth only
  - workaround VPN DNS using IPs, etc.
  - `ssh-keygen` to generate keys, trust in `~/.ssh/authorized_keys` per usual
  - `ssh-agent` and `ssh-add` to forward generated keys
  - ```
    Host jumphost
      AddKeysToAgent yes
      ForwardAgent yes
      Hostname 1.2.3.4
      EscapeChar @
      RemoteForward 2222 localhost:2222
      ProxyCommand sh -c 'cd /tmp ; busybox fuser -4 2222/tcp || screen -dmS ssh dropbear -R -F -E -B -P 2222 -s -a -G chronos-access; busybox nc %h %p'
    ```
  - can multiplex with Android adb using **sslh**
- probably need `tar -o` to not restore uid/gid in at least:
  - `cwuntar`
  - `cwuntbz2`
  - `cwuntgz`
  - `cwuntxz`
- function dispatch table
  - with default args, etc.
  - templatize function names
  - `x|y|z) ... ;;` pipes are parsed before vars...
    - so can't use like `${x}|${y}|${z}) ... ;;` in case
  - ```
    declare -A cwfunctab
    cwfunctab['install']=cwinstall
    ...
    case "${cmd}" in
      install) ${cwfunctab['install']} "${@}" ;;
    esac
    ```
  - can use a catch-all here with `\*)`
- "epoch" for packages
  - changes (for most recipes) when compilers are updated
  - main epoch stored in `/bin/crosware` or `/etc/profile` or `/recipes/common.sh`
    - `: ${cwepoch:=""}` then set based on compiler date if `test -z`
    - track `${cwoldepochs[@]}` (1 2 3 ...) and `${cwallepochs[@]}` (c 1 2 3 ...)
    - `epoch` command - current epoch
    - `show-epochs` command - dump `${cwallepochs[@]}` in "current : old1 old2 old3 ..." format
  - `/var/epoch/recipe` stores installed recipe epoch?
  - packages without deps (java, go, bin jars, etc.) have separate epoch?
  - "release" per recipe
    - default to epoch
    - forces a big rebuild on compiler+libc update
    - can be set per package, in `common.sh` ... `: ${rrelease:="${cwepoch}"}`
    - in `${rname}.sh` ... `rrelease="${cwepoch}-0"`
  - could silently store and manipulate epoch in inst file?
    - delimeter? `|` here
    - recipe **abc** version _1.2.3_ at epoch 202104200609
    - `/var/inst/abc` has...
    - **1.2.3|202104200609**
    - installed version is just recipe version
    - epoch if blank defaults to current epoch
    - can signify that package tracks i.e. compiler or not
      - statictoolchain still a manual upgrade though, nothing REQUIRES requires it...
    - `${repochreq}` - recipe var to signify epoch required, default to true
    - upgrade, version check, version write, etc., will need to reflect this
    - can be considered in-memory? kind of ugly. ugly elegance
- downstream upgrades... - **DONE???**
  - not a full graph
  - on `crosware upgrade recipe` or `crosware upgrade-all`...
    - `local r ; cwreqs_${rname} | while read -r r ; do cwlistupgradable | grep -q "^${r} : " && cwupgrade_${r} || true ; done ; unset r`
- upstream upgrades
  - dependents
  - actually need a graph here?
  - hard
- `check-upgradable`
  - command to see if a package needs an upgrade
  - memoize upgrade status
  - separate from upgrade state
  - if an upgrade is requested, we want to run it once regardless of necessity
  - `cwupgradable[${rname}]` hash
    - 1 if upgradable
    - 0 if not, or upgraded
    - some overlap with `cwupgraded[${rname}]`
- `cwsourcerecipes` should be run once
  - safe to run/idempotent on subsequent runs
  - speed things up?
- common function instrumentation
  - help find hotspots/redundancy
  - "heavy" functions to start with, "opt-in"
  - ```
    declare -A cwfunccounts
    for f in cwsourceprofile cwsourcerecipes ... ; do
      cwfunccounts[${f}]=0
    done
    ...
    function cwsourcerecipes() {
      cwfunccounts[${FUNCNAME[@]}]=$((${cwfunccounts[${FUNCNAME[@]}]}+1))
      ...
    }
    ```
- username/primary group getters
  - `at` recipe has basic version
  - given `${UID}`, get the `${USER}`
  - given `${UID}`, get the primary `${GID}` (`${GROUPS[0]}`?), and get the `${GROUPNAME}`
- help/usage per command
  - ```
    $ crosware help install
    install a crosware recipe
    usage: crosware install <pkgname1> [<pkgname2> <...>]
    ```
- niceties
  - `bash` and `dash` bind mounts to kill annoying security
  - `sysctl kernel.dmesg_restrict=0` to enable dmesg
  - `TERM` is funky with copy/paste in vim on xterm-256color? use screen-256color as workaround
  - google is doing everything they can to make this shit unusable
- libressl variants of openssl packages
  - mbedtls, wolfssl, bearssl too, for anything that supports it/them?
  - see "bundling" of curl, libssh2 w/libressl
  - gnutls? what else?
- `recipes/overrides/recipe.sh`
  - locally override settings
  - rurl, rver, etc.
  - normal flow: recipe.sh -> common.sh -> recipe.sh.common
  - would have to include at top of common.sh
  - separate out vars/settings and functions?
  - functions could then be included at bottom of common.sh or recipe.sh.common
  - no one size solution here for var+function override

<!--
# vim: ft=markdown
-->
