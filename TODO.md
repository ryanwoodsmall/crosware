# TODO

- `cwneedupgrade_${rname}` function
  - recipes responsible for checking themselves if they need an upgrade
  - then chasing recursively
  - could simplify `cwupgradereqs_${rname}`?
  - should be faster and may lead to fewer recursive loops during req upgrade checks
  - almost like message passing to a recipe
    - hey if you need to be upgraded, go for it, tell your friends, i'll wait
    - otherwise, thanks, take it easy, you can go
    - and then "hey already saw you, thanks for checking in"
  - as always, would benefit from a (fast) graph here!
- rss links for source releases
  - would make tracking updates significantly easier
  - github, gitlab, etc.
- add `rinfo` to recipes
  - free-form string
  - can be used to generate recipe list
  - separate out from README.md
- allow underscores in recipe names?
  - i.e., `something_special`
  - would make parsing easier for variants
    - special per-recipe handling in ${rname}.sh.common
    - i.e., curl w/bearssl+mbedtls+wolfssl function template templates but generalized
  - not a bad idea
  - ```${rname}_${provider}``` : recipe provider normalization
    - for i.e. netbsdcurses or ncurses, libressl or openssl, etc.
    - last element split on _ is considered to be a provider - automatic reqs, special handling, etc.
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
- `cw{{c,cpp,cxx,ld}flags,pkgconfig,rpath}...${rname}` functions
  - or just a single `cwdevenv_${rname}` - more straightforward, less extensible?
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
  - rsite - url for recipe
  - rmessage - generic message to push into an array shown at end of run
  - rdeps / rbdeps? - deps and build deps?
  - rdesc - recipe description?
  - rlicense - license
  - rcommonconfigureopts - recipes that have a common set of options (curl, ncurses, lynx) can bundle these here
  - rconfigureopts - can set here instead of defining custom *cwconfigure_*
  - ropts - gate off common functions with _nomake_, _nomakeinstall_, etc.
  - rarches - list of supported arches, default all
  - rold - list of old versions to clean up recipes that do not fully remove rdir?
  - rext - ${rfile} extension - .tar.gz, etc. - would make (de-)construction easier
  - rlibdir / rincdir - use for cwgenprofd_ and encode in functions for reflection
    - could help separate out dev deps from bin/progs
    - much slimmed down CPPFLAGS/LDFLAGS on recipes where it's custom
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
    - install dir as well ```${cwtop}/var/ridir/${recipe}```
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
  - user space selection "busybox" "toybox+busybox" etc.
    - stackable with preference i.e, prefer toybox over busybox
    - busybox, toybox, sbase, ubase, suckless (sbase+ubase), coreutils, utillinux, gnu (coreutils+utillinux), heirloom (svr4/posix), bsd (baseutils+outils)
  - add in bash and curl and ... bins, make sure tar/gzip/bzip2/unzip are available to reconstitute crosware in a sysroot from a .zip
  - shell configuration
    - bash is always available as `bin/bash`
    - symlink to `bin/sh`
    - ash, bash, dash, jsh (heirloom), ksh93, loksh, mksh, oksh, yash
  - make configuration - gmake, bmake, heirloom
  - ccache, cc (gcc, tcc, pcc, ...), etc.
  - plan9 bits - plan9port, 9base
- man wrapper
  - busybox (man), less, groff
  - sets PAGER to (real less) ```less -R```
  - MANPATH?
- need a fallback mirror
  - generalized way of handling a _list_ of mirrors
  - `cwmirrorfetch` and `cwmirrorfetchcheck`
    - `cwmirrorfetch`: url, path, mirrorlist (semicolon-delimited)
    - `cwmirrorfetchcheck`: url, path, sha-256, mirrorlist (semicolon-delimited)
  - `cwmirrorfetchcheck` is safe to just naively run over the full list of mirrors since it'll short-circuit on file existence+sha256sum match
  - `cwmirrorfetch` needs some idempotency safety-baked in?
  - ```
    function cwmirrorfetch() {
      local u="${1}"
      local f="${2}"
      local l="${3}"
      local m s
      for m in ${l//;/ } ; do
        s+="cwfetch \"${m}\" \"${f}\" || "
      done
      s+="cwfailexit 'failed to download ${f} from mirrors'"
      cwfetch "${u}" "${f}" || eval "${s}"
      unset u f l m s
    }
    ```
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
  - XXX - this is getting _slow_ with lots of installed recipes
  - speeds up processing of environment by ~2x
  - does not work for CPPFLAGS/LDFLAGS? becaues of -I or -L? or...?
  - looks like an early vs late eval thing when pattern matching using ```if [[ ... =~ ... ]]```?
  - maybe try this...
  - ```
    # p is CPPFLAGS,LDFLAGS,PATH,PKG_CONFIG_LIBDIR,PKG_CONFIG_PATH
    : ${d:=" "}
    if [ ${#} -ge 2 ] ; then
      d="${2}"
    fi
    t="${d}${p}${d}"
    if [[ ${1} =~ ${p} ]] ; then
      return
    fi
    p+="${d}${1}"
    export p
    ```
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
    - epoch <-> release for opkg?
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
  - new ```cwcheckupdate_${rname}``` per-recipe function
  - **caextract** would be an easy place to start
  - base (**bash**, **busybox**, **toybox**, **curl**) would be great to have "baked-in"
  - git client, maven, etc. could be used for respective recipes
  - and base container could indicate it needs an update, for example
  - hmm
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
- cwdepends too...
- cwupgradereqs / cwupgradedeps
  - done-ish, `cwupgradereqs_${rname}` and `cwupgradedeps_${rname}`
  - upgrading deps could cause a world of hurt on `make`, `bootstrapmake`, etc.
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
      ProxyCommand sh -c 'cd /tmp ; busybox fuser -4 2222/tcp || screen -dmS ssh env -i /usr/local/crosware/software/dropbear/current/sbin/dropbear -m -R -F -E -p 2222 -P /tmp/dropbear.pid -s -a -G chronos-access; busybox nc %h %p'
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
    - releases for **opkg** _.ipk_ files too?
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
- python stuff...
  - use venv with copies to encapsulate programs that require python
  - pyinstaller to generate binaries?
  - pyinstaller needs shared python
- stop special casing ${cwbootstraprecipes[@]}
  - var is necessary for e.g. generating functions
  - but bootstrap recipes can be included in ${cwrecipes[@]}
  - avoid forgetting them when building out new functions that act on all recipes
- generalized "patching" with a filename and regex
  - wrap sed but don't require `sed -i` support (i.e., allow sbase/9base)
  - same for `awk` and `ed` and ...?
- `cwsourcemirror` top-level var to avoid duplication
- `unsafe_source` in etc/functions
  - checks if `set -eu` is in effect
  - if it is, save state, toggle off, source, toggle back on
  - ```
    # posixy
    unsafe_source() {
      echo $- | grep -q u && u=1 || u=0
      echo $- | grep -q e && e=1 || e=0
      set +eu
      # XXX - need a "|| true" here? shouldn't...
      . "${1}"
      test ${e} -eq 1 && set -e || true
      test ${u} -eq 1 && set -u || true
    }
    ```
  - probably need `toggle_safe_on` and `toggle_safe_off`
  - but don't really want that...
- "register recipe"
  - on source of a recipe file, the recipe performs all array/hash manipulation itself
  - sort of inversion-of-controlish
  - would allow external recipes in e.g etc/local.d/recipename.sh without needing direct support
  - and would reduce manual work
  - could be used with unsafe_source too, failing softly/quietly/non-fatally?
- ```cwlatestver_${rname}```
  - dump latest version number using some probably custom checker
  - can be used with `update-recipe-file.sh` for somewhat automatic updates
- **golang** recipes
  - `GOCACHE` and `GOMODCACHE` settings/overrides
  - `GOPATH` too?
  - multiarch standardization
  - see minikube, nebula for source
  - see kubernetes, k3s for bin
  - setting in **recipes/common.sh**:
    - something like : `${cwgobuild:="env GOCACHE=${rbdir}/gocache GOMODCACHE=${rbdir}/gomodcache ${cwsw}/go/current/bin/go build -ldflags='-s -w'"}`
- **openssl** versions
  - old programs only support older stuff/APIs, even though they're out of support
  - add `openssl110`, `openssl102`, `openssl100`, `openssl098`, etc.
  - move main recipe to `openssl111` or have a separate one? (**lua**-recipe-like)
  - makes openssl 3+ easier in the future?
  - same for **mbedtls**, **libressl**, **gnutls**, etc., and other tls providers?
  - same issue for `lua##` and `python#` and the like...
- `openssl-cert-wrapper` (doesn't exist)
  - enough rsa/x509/ecc (via mbedtls, bearssl/x509cert, px5g, gnutls, dropbear, plan9port, lsh, ...) for key/cert generation
  - for acme.sh and other tools that require openssl for key and cert generation
- *__BEGIN_DECLS* and *__END_DECLS*
  - glibc header specific
  - something like...
    - `CC="${CC} -D__BEGIN_DECLS='' -D__END_DECLS=''"`
    - `CXX="${CXX} -D__BEGIN_DECLS='extern "C" {' -D__END_DECLS='}'"
  - figure out quoting.
  - function for prepending headers?
    - given a file, undef/define the DECLS at the top of the file
- `binonly/` directories for busybox, toybox, ccache, sbase, ubase, dropbear, ...
  - symlink for primary binary as a cleaner alternative for adding a recipe to path
  - explicitly run with `boxbinary program -options arguments`
- hard to support recipes
  - need an ongoing update strategy for stuff that is necessary but a pain to update/slow build/etc. or that i don't personally use
    - perl
    - qemu
    - glib
    - python python python
    - cmake
- arch-specific recipes
  - `${cwtop}/recipes/${karch}/${rname}/${rname}.sh`
  - simplify single-arch layouts
  - could use symlinks for multi-arch but not ALL arches
  - hmm
- `${CW_ARCH}` - override bash-detected arch
  - karch / uarch - 32- and 64-bit intermingling
  - cross-install
  - hmm
- sequestered "package" builds in a container
  - could run as usual with caches/etc. BUT just tar the whole thing (`${cwsw}`, var/inst, etc/profile.d, ...) up and extract
  - easy in-place FULL-ish upgrades
  - "full" build container with vim/git/lynx/links/tmux/screen/...
  - snapshot git hash of repo for state/tracking
  - sysroot idea would come in super duper handy here - avoid necessity for docker/runc/lxc/podman/...?
- `cwreinplace "pattern" "file1" ... "fileN"`
  - encapsulate `sed -i` - some seds don't rewrite inplace!
  - or `cwreinplacefile` with separate `cwreinplace` doing the sed?
  - create file backup with `.crosware_ORIG` extension
  - create new file with `.crosware_NEW` extension
  - swap `.crosware_NEW` file contents to original filename with `cat`
  - remove `.crosware_{ORIG,NEW}` files?
  - could get _very_ ugly with patterns containing quotes, escapes, backtracking, etc.
- `cwupgrade_downstreams`
  - use `cwupgradereqs_${rname}` and `cwupgradedeps_${rname}`
  - does what it says
    - for anything that requires a package...
    - check that it's installed
    - if it is, run `cwupgrade_${downstream}`
  - opt-in **only**
    - default to `true`
    - `rupgradedownstreams` flag
    - avoids problem of like a `make` upgrade rebuilding _literally  everything_
    - also avoids a full graph or map/reduce thing, should be simpler/faster
  - run at end of `cwupgrade_${recipe}`
- `${cwoptimze:="-Os"}`
  - don't do optimization by default, except per-recipe
  - make that an overridable, global var (size opt by inherited default)
- `${cwskipfetchcheck:="FALSE"}` or similar
  - explicitly be able to skip a fetch check with ugly default
  - would allow local build of new compilers without having to upload to github
- `rtriggerdownstream="function1 function2 ..."`
  - and `cwtriggerdownstreams_${rname}()`
  - implicitly call some functions after `cwmakeinstall_${rname}()`
  - e.g. libressl, openssl updates trigger cacertificates, caextract reinstalls
  - might require a bit of `cwcheckuniq` finesse? for `cwreinstall`? hmm
- save/set/restore `CFLAGS/CPPFLAGS/CXXFLAGS/LDFLAGS/PKG_CONFIG_{LIBDIR,PATH}`
  - add to main script
  - completely sequester environment...
- "aggregate" script
  - amalgamation
  - essentially:
    - main `bin/crosware` script
    - output of `set` starting with functions
    - set recipes sourced
    - set functions sourced
    - disable `cwchecktop` - return true
  - function marker in `set` output
    - for easier detection and to know where to cut environment vars
  - array or hash of top-level directories
    - easier dir creation
    - setup basic `etc/profile{,.d}/`, `bin/`, `tmp/`, `var/`, ...
  - all recipe references to `${karch}` and `${uarch}` would need to be escaped
- shared-static concept
  - creation of .so from .a is simple-ish, if _everything_ is PIC
  - basically take an archive lib, extract, compile .o files to shared object (done)
  - drop the lib.so into the _sequestered installation dir_ of the _target recipe_
    - i.e., copy up; a-requires-b-requires-c, so libs (at least) for c end up in b and both end up in a
  - set the `-rpath` appropriately and force include with `LIBS='-lblah'`
    - rpath would probably have to be recursive into downstream reqs
    - add to `cw{{c{,pp,xx},ld}flags,pkgconf}_${rname}` functions
  - only _external_ shared object is libc.so...
    - and that could be overcome with some `patchelf` magic
  - allows dynamic modules and/or _fully-encapsulated pacakge directories with ALL lib dependencies_ that could be composed
  - not reproducible builds by any means... but could be used as a base
  - also look into combining multiple `lib.a` static libs into a single "uber lib"
    - a shared lib created out of this could be like `librname-reqs.so` or something
    - insane
- use `stat` to detect if rebuild needed?
  - installation state files in `var/inst/` should be relatively static
  - e.g., a-requires-b-requires-c
    - if `var/inst/b` is newer than `var/inst/a`, upgrade it
    - recursive...???
  - could also force rebuild by touching file and running like `upgrade-out-of-date`
  - very touchy, messing around with installation files could lead to full rebuild
- function to fetch static `bash`, `busybox`, `curl` and `toybox` binaries
  - new command
  - https://github.com/ryanwoodsmall/static-binaries
  - setup a temporary `bin/` dir with a userspace in `/usr/local/tmp` or `/usr/local/crosware/tmp`
  - override local binaries for bootstrap purposes
  - position before bin req check (i.e., can grab busybox and setup `xz` and `bzip2` symlinks)
  - possibly automatically
  - really just need curl
  - to do safe-ish, would need checksums
- `${cwtop}/etc/functions.d/*.sh`
  - local functions override
  - `${cwtop}/etc/local.d/*.sh` get pulled into interactive environment
  - functions.d are for script usage
  - dump a full "local" recipe in a single file
  - aye
- make cert bundle path configurable
  - default to `${cwtop}/etc/ssl/cert.pem`
  - cert directory too?
  - would make generating system-independent binaries easier
  - i.e., `/etc/ssl/...` paths on debian, etc.
- file serializer
  - basically read `uuencode < file | base64`
  - would help with amalgamation idea
  - read into a variable, linear or array?
  - reconstitute from driver script
  - like a very limited version of shar
  - would have to do regular var for posix...
- add shar support to cwextract
- split out `cwgenprofd_...` into an "shower" and a "writer"
  - would make buildtime `CPPFLAGS/LDFLAGS/PKG_CONFIG_{LIBDIR,PATH}` more dynamic
  - could pull FLAGS out of the runtime environment completely
  - better sequestration, smaller environment, less screwing with include/lib dirs on real systems
  - semi- dev/bin split, not sure i like that
- `cwoldversions_${rname}`
  - setup symlinks to oldversions for e.g. forcing `pkg-config` or `${rname}-config` script reification
  - similar to **ncurses**
- `cwpostinstall_${rname}`
  - function to run after `cwmakeinstall_`
  - or end of `cwinstall_`?
- remove unused functions from recipes
  - basically just do `undef -f ${func}`?
  - or `true` them out so they're _there_ but don't do anything?
  - `rundeffunctions` per-recipe setting or similar?
- function overrides
  - basically save old name to new function, override function name with body calling new function
    - save original: `. <(declare -f orig_func | sed 's/^orig_func/function orig_func_real/g')`
    - declare new: `function orig_func() { echo 'calling orig_func_real' ; orig_func_real "${@}" ; echo 'called orig_func_real' ; }`
  - that's it
  - override from profile, only for the `crosware` program...
    - ```
        # place in i.e. /usr/local/crosware/etc/local.d/zz_localoverrides.sh
        # "declare -F newfunc &>/dev/null || . <(declare -f oldfunc | sed s,oldfunc,newfunc,g)" should be effectively idempotent too...
        if [[ "${BASH_SOURCE[$((${#BASH_SOURCE[@]}-1))]}" == "${cwtop}/bin/crosware" ]] ; then
          : ${CWOVERRIDES:=0}
          if [[ ${CWOVERRIDES} == 0 ]] ; then
            . <(declare -f cwinstall_alpinemuslutils | sed s,cwinstall_alpinemuslutils,cwinstalldefault_alpinemuslutils,g)
            eval "function cwinstall_alpinemuslutils() { cwscriptecho hello from a function override : \${FUNCNAME[0]} ; cwinstalldefault_alpinemuslutils ; }"
            CWOVERRIDES=1
          fi
        fi
      ```
  - support `${cwtop}/recipes/blah/blah.sh.overrides` or similar during recipe parcing?
    - .gitignore, allow local function overrides
    - easy but could be ugly
- `cwsavevars()` or similar for dumping `source`-able environment
  - could basically just `set grep -i "^cw"` or similar
  - would help with amalgamation build
  - `cwsaveenv`?
  - `cwsaveenvvars`?
  - bash posix way, should only dump vars? `( set -o posix ; set )`
    - https://askubuntu.com/questions/275965/how-to-list-all-variables-names-and-their-current-values
  - could build a hash of var keys at the beginning of the script, then at the end; save anything created during run
- safer `rm`?
  - should probably only do `rm -rf ...` on relative paths, _not_ absolute
  - wrap in `cwrmrf` or similar to force it
  - iterate over `${@}` instead?
  - need to check whatever's to be removed is under **/usr/local/crosware** (similar to `cwcreatesharedlib`)?
  - something like...
    - ```
      function cwrmrf() {
        cwscriptecho "removing ${1}"
        local parentdir="$(dirname ${1})"
        local targetdir="$(basename ${1})"
        pushd "${parentdir}" &>/dev/null
        rm -rf "${targetdir}"
        test -e "${targetdir}" || cwfailexit "could not remove directory ${1}"
        popd &>/dev/null
      }
      ```
- split `cwupdate` into
  - `cwupdate_git` - check for `${CW_UPDATE_USE_GIT} == true`
  - `cwupdate_tar` - check for `${CW_UPDATE_USE_TAR} == true`
  - `cwupdate_zip` - check for `${CW_UPDATE_USE_ZIP} == true`
  - restructure like:
    - ```
      function cwupdate() {
        cwupgrade_git && return || true
        cwupgrade_tar && return || true
        cwupgrade_zip && return || true
        cwfailexit "don't know how to update"
      }
      ```
- flag to ignore `cwchecktop`
- flag to set locks
  - `CW_OBEY_LOCK` or similar
    - have a wait or just bail?
    - bail is much easier
    - without decent queue, could get into odd scenarios
      - where packages are built numerous times
      - where jobs are fighting over a download?
      - simple is better (and faster) here
    - separate waiter and checker/claimer
  - semaphore file in `${cwtop}/tmp`
  - checked at startup, removed in a trap
  - compare-and-swapish
  - flag that keeps "did-i-set"
  - on trap if "did-i-set" is true, give up lock
  - otherwise bail with a non-0 exit code
  - `crosware remove-lock` or similar command
  - as usual, a real (and fast) graph could come in very handy here
    - compute full graph of installation
    - lock each _recipe_ with dependents
    - start with the smallest req, mark it installed, move on
    - could run concurrently
      - i.e., a branch(?) in a graph/between two graphs could spin up more builds
      - distributed
      - run over ssh+ccache+distcc+...
      - pubsub claims. wtf
    - i am crazy
- `crosware vars` command
  - dump the `CW_...` environment vars
  - map of var to purpose
  - map of var to default setting
- site/repo/etc. settings
  - `cworg` - me `ryanwoodsmall`
  - `cwrepo` - `crosware`
  - `cwbaseurl` - github.com/org/repo?
  - `cwsite` - github.com? github.com/org?
  - `cwrawurl` - repo raw access for remote scripts
- `${cwtop}/var/deps/${rname}/{dep1,dep2,..}`
  - track installed dependencies via `var/inst/${rname}` style files
  - one extra level
  - use symlinks?
  - just remove `var/deps/${rname}/` dir on uninstall
  - individual packages would have to create/remove their own `var/deps/${req}/${rname}` files
- `${rname}` at runtime
  - encode recipe name in function
  - could `eval` most of a function with single ticks to stop var processing entirely?
  - easier to create a more generic function
    - or a function dispatcher...
  - could branch based on function name
  - might greatly reduce duplicated variant configure, make install, etc.
  - `verb_target_extra` notation?
    - see: https://github.com/ryanwoodsmall/shell-ish/blob/master/examples/verbtargetextracallerstack.bash
  - callbacks as well
    - simple: append something to the end of a function
    - save func as array, then `l=${#fa[@]} ; fa[${l}]='}' ; fa[$((${l}-1))]="custom command to run"`
      - ( use `declare -i` for integers to ease math/force type??? posix but i'm way more accustomed to bash `$((..))` math at this point )
    - `eval` to further expand?
    - harder: full array-based "original" function tracking mechanism with `hash[function]=( [0]="cmd1 arg1" [1]="cmd2 arg2" ... )`
    - save a copy of original function as an array in a hash
    - save a list of callbacks per function to a hash of list
    - read original function, bounce down callback hash keys, plugging in each list element in order as the last command in a function
    - close out the function with '}' and eval...
- serialize/deserialize
  - ```
    function cwserialize() {
      declare -a s
      # detect type w/ declare -f and declare -p
      # act accordingly - set flag
      # - serealize array, hash, function, value, ...
      # leave 'declare -${type} var=...' bits in to eval? yes?
      # recursive? decorator for saying "keep expanding?"
      readarray -t s < <(declare -${typeflag} ${1})
      echo $s
    }
    ```
- wrapper around var checking and creating/saving vars/funcs
  - exists
    - vars: `function cwisvar() { declare -p ${1} &>/dev/null || return 1 && return 0 ; }`
    - funcs: `function cwisfunc() { declare -f ${1} &>/dev/null || return 1 && return 0 ; }`
    - specific ones for hashes, arrays, integers, ...
    - wrappers for creating if it doesn't exist
- `cwdetectcycle` - already there, just need to tweak and make more general
- generic eval-able `cwevalable() { while [[ ${#} != 0 ]] ; do println "${1}\n" ; shift ; done | eval ; }` or simpler
  - arrays to functions
  - anything really
  - need helper functions for array handling to limit loops in functions (serialize, deserialize, ...)
  - need quoting helpers too, ugh. - basically capture semi-interpreted strings in `"'${...}'"` for eval
  - helpers for "anonymous" serialized arrays/hashes to pass as evalable literals
  - with types (`type -t`)
  - what am i doing
- functions...
  - can be marked readonly!
    - see notes on OO super stuff in shell-ish doc/script
  - function stub generator
    - `function cwstubfunction() { eval < <(echo "function ${1}() { true ; }) ; }"`
    - or `cwstubfunc() { while [[ ${#} != 0 ]] ; do eval "function ${1}() { : ; }" ; shift ; done ; }`
  - function aliasing
    - ordering?
      - "alias source target" - i.e., like `ln -s source target`
      - "alias target source" - i.e., like `alias fakecmd="realcmd"`
    - arguments? - i.e., `{ ${2} "${@}" ; }`
    - ex:
      - ```
        # 'alias' type is easier and would allow loop... `{ ${2} ; ${3} ; ... ; }`
        function cwaliasfunc() {
          eval "function ${1}() { ${2} ; }"
        }
        cwaliasfunc new_function_name source_function
        ```
  - save/restore - save function to a hash
    - with state tracker, would have idempotency
  - and copier
    - ```
      # XXX - cannot lose space/fidelity! echo won't cut it, printf
      function cwcopyfunc() {
        declare -a func
        readarry -t func < <(declare -f ${1})
        func[0]="${2} () "
        for i in ${!func[@]} ; do echo "${func[${i}]}" ; done | eval
      }
      ```
  - (rename would just be copy to new tmp name, replace original name, delete tmp name)
  - and wrapper...
    - given a function name, a prefix command, and a postfix command, insert at beginning end
    - `function cwfuncwrap() { savefunc $1 tmpfunc ; insert at top of tmpfunc $2 ; insert at bottom of tmpfunc $3 ; copyfunc tmpfunc $1 ; delfunc tmpfunc ; }`
    - individual prepender, appender funcs
    - would allow for:
      - temporary functions
      - functions that can delete themeselves
        - `cwdeletablefunc() { while [[ ${#} != 0 ]] ; do eval "function ${1}() { : ; unset -f \"\${FUNCNAME[0]}\" ; }" ; shift ; done ; }`
        - ```
          cwtmpfunc() {
            local tmpfuncname=''
            while true ; do
              tmpfuncname="tmpfunc_${RANDOM}"
              checktmpfunchashkey ${tmpfuncname} || continue && break
            done
            cwdeletablefunc ${funcname}
            cwappendfunc "unset cwtmpfuncs[${func
          }
          ```
        - need a hash key checker - generic or specialized? `cwcheckhashkey hash key` - cwcontains won't cut it
      - array -> function builder, easy?
        - `cwarraytofunc() { while [[ ${#} != 0 ]] ; do echo "${1}" ; shift ; done | eval ; }`
        - build with `cwbuildfunc() { declare -a f=() ; a[0]="function ${1}() {" ; while ${@} ; do a+=( "${1}" ) ; shift ; done ; a=( "}" ) ; eval ... }`
  - idiom:
    - no args: generate a randomly-named stub function and print the name
    - one arg: generate named stub function
      - if $1=- read name from stdin, shift
    - two+ args: genarate a named function with stdin/"${@}" args stored as body of function
      - if $1=- read name from stdin, shift
      - if $1=- read body from stdinm shift
      - if $1!=-- && ${#} save stdin to end of body
      - if $1=-- stop parsing stdin, start processing args, pushing each arg to body end
      - keep a tmparray with "declare -a body=([0]="function name () ",[1]="{",[2]="cmd 1",[3]="cmd 2",...,[n-1]="}") ; eval < <(while [ ${#} -gt 0 ] ; do ..."
      - eval own body with stack canary (depth) and stdin+args
- `cwclone` - git clone wrapper; basically:
  - `( cd ${wherever} ; ${CW_GIT_CMD} clone ${url} [${optionaldir}])`
- `${rfdir} / cwfdir_${rname}` - final dir, `${rtdir}/current`
- simplify (not necessarily speed up) bash list bits with substrings
  - https://unix.stackexchange.com/questions/413976/how-to-shift-array-value-in-bash
  - dereference in function? i.e. `${${arrayname}[...` ??? (will help in function cerealization
  - use substrings for chomping off end too?
  - shift: `function arrayshift() { r="${a[0]}" ; a=( "${a[@]:1}" ) ; return "${r}" ; }`
  - unshift: `for i in $(eval echo {1..$((${#a[@]}-1))}) ; do a[${#a[@]}-${i}]="${a[${#a[@]}-1-${i}]}" ; done ; a[0]="$newelement"`
  - pop (with arithmetic) `r="${a[${#a[@]}-1]}" ; unset a[${#a[@]}-1] ; return "${r}"`
  - push `a[${#a[@]}]="$value"`
  - array dumper...
  - ```
    function dumparray() {
      # this just echoes its args, declare -p to get copy of "raw" array by name
      i=0
      while $(test $# -ne 0) ; do
        echo $i : $1
        shift
        ((i++))
      done
    }
    ```
- bash functions and arrays can have the same name
  - opens up "smart datatype operators"
  - `${varname} serialize` - dump
  - `${varname} append value` - append
  - `${varname} verb argument` - dispatch: run something with arguments...
- file appender/prepender
  - `cwappendfile filename "something to append" "something else"`
  - `cwprependfile filename "something to prepend"
    - only handle single args on prepend
    - otherwise things have to be passed in reverse order
- check for `cwpostinstall_${rname}` and run at end of `cwinstall_${rname}`
  - `declare -f cwpostinstall_${rname} &>/dev/null && cwpostinstall_${rname} || true`
- for generated functions (cwstubfunc, cwechofunc, ...), have an indicator?
  - basically replace the last '}' of a function with `: generated by ${FUNCNAME[0]} ; }`
  - opt-in since it's heavy
  - `CW_MARK_GENERATED_FUNCTIONS` or something else onerous to type
- `etc/functions.d/`
  - local functions/overrides
  - only sourced by `bin/crosware`
  - e.g., use a different patchset for a recipe
  - hook install function to archive/package dated builds
- `cwrepeatfunc # cwfuncname [cwtargetfuncname?]`
  - rename/copy `cwfuncname` to `cwfuncname_real`
  - ```
    function cwrepeatfunc {
      # XXX - or detect $# and act accordingly?
      cwcopyfunc "${2}" "${2}_real"
      local -a funcbody=()
      a[0]="function ${2}() {"
      for i in $(seq 1 ${1}) ; do
        a+=( "${2}_real && return 0 || true" )
      done
      a+=( "false" )
      a+=( "}" )
    }
    ```
- local build tool/system utility config points+overrides
  - set common tool locations, and "meta" tools in like `etc/tools`
  - ```
    # lex
    : ${CW_FLEX="${cwsw}/flex/current/bin/flex"}
    : ${CW_REFLEX="${cwsw}/reflex/current/bin/reflex"}
    : ${CW_LEX="${CW_...}"} # CW_(FLEX|REFLEX)
    # yacc
    : ${CW_BISON="${cwsw}/bison/current/bin/bison"}
    : ${CW_BYACC="${cwsw}/byacc/current/bin/byacc"}
    : ${CW_YACC="${CW_...}" # CW_(BISON|BYACC)
    # ...
    ```
  - then use in recipes in `./configure... (LEX|YACC)=...` lines
  - easier to override in env... but may not declare req, so mostly for testing?
  - harder for ncurses/netbsdcurses, etc.
  - could also do sorta meta/dynamic/templatized variants?
  - _and_ could use similar scheme to replace "userspace"
    - prefer + supplement + override via different combinations
    - LOTS of different permutations
      - busybox+toybox
      - toybox first, then busybox, then ..., then ..., ...
      - sbase/ubase/...
      - coreutils+utillinux
      - baseutils+other bsd stuff
      - heirloom
      - etc.
  - could get complicated, or straight-up out-of-hand
- ssl/tls tests/checks?
  - https://www.howsmyssl.com/
  - https://check-tls.akamai.io/
  - https://check-tls.akamaized.net/v1/tlssni.json
- cron...
  - `sbase` uses **/etc/crontab**
  - `busybox` and `toybox` use **/var/spool/cron/crontabs** (i think?)
  - standardize in **${cwtop}/etc/crontab** and **${cwtop}/var/spool/cron**
- use `awk '!seen[$0]'` to get unique elements while retaining order
- `cwsplit "<delim>" "string<delim>string<delim>..." "string<delim>..."`
  - split any input into newlines on `<delimiter>`
  - `cwjoin "<delim>" "<string1>" "<strings2>" "..."`
    - join args w/delimiter
  - name on `cut`/`paste`/`join`/`split` shell commands? conflation here...
- `cwsha256fetch` (naming?)
  - two-step download
  - get SHA-256 checksummed `filename.sha256` or similar
  - verify its checksum
  - substitute `awk '{print $NF}' filename.sha256` for last element of `https://domain.tld/path/to/filename.sha256`
  - allows single-file download with caching
  - and multi-arch if in separate `.sha256` files
  - with multi-file checksum files, have to know the filename in advance?
  - not really, have the sha256sum, just look it up in the checksum file
  - new `rsha256file` config setting?
  - this may be too much work for little gain
  - doing something like this w/k3s, k0s, ... other such bin recipes
- openbsd nc
  - included with tls support in `libressl` and `otools` (with bearssl+libtls)
  - for a proxy example see: https://gist.github.com/m1tk4/bb626dcf2bc1bfade170a38b3085cdbd
  - tls version:
    - ```
      #!/bin/sh -e
      if [ $# != 3 ]
      then
          echo "usage: $0 <src-port> <dst-host> <dst-port>"
          exit 0
      fi
      nc=/usr/local/crosware/software/otools/current/bin/nc
      TMP=`mktemp -d`
      PIPE=$TMP/pipe
      trap 'rm -rf "$TMP"' EXIT
      mkfifo -m 0600 "$PIPE"
      ${nc} -c -R /usr/local/crosware/etc/ssl/cert.pem -C /usr/local/crosware/tmp/lighttpd_cert.pem -K /usr/local/crosware/tmp/lighttpd_key.pem -N -l "$1" <"$PIPE" \
      | ${nc} -w 3 -N "$2" "$3" > "$PIPE"
      ```
    - unusable w/connections that don't automatically close (http, ssh, ..., keepalive?)
    - port and/or connection stay open
    - same issue w/little libtls proxy i've been working on and non-tls- or proxy-aware servers
    - stdin/stdout are easy-ish, it's when you're forking (ala inetd) or opening a r/w pipe where things go south
- command to list profile.d files
  - `list-recipe-profds`?
  - e.g. `recipe : /usr/local/crosware/etc/profile.d/recipe.sh`
- make ssl/tls ca/certs/etc. configurable
  - `CW_CERT_PATH` or some such
- `${cwsw}/${rname}/${rver}/lbin` - "link directory"
  - basically ```bin/*``` with `${rname}-` prepended
  - easy, would solve a few yacc, lex, m4, et al. issues?
- `/usr/local/crosware/software` should contain an arch...
  - would allow for coexistence of multiple architectures
    - i.e., fully shared install - could do similar for...
    - `builds`, `var/inst`, and so-on
    - `etc` would be hard to share though? yeah. not really possible.
    - `downloads` would needs locks/semaphors, and also traps to cleanup on exit
    - oof, maybe this isn't a great idea?
  - karch or uarch? karch...
  - `${cwsw}` becomes `/usr/local/crosware/${karch}`
  - need short arch? go/java style, but which?
    - aarch64 -> arm64
    - armv#{l,a,...} -> arm32 (assume hf, softfloat is just not worth it for now)
    - i{3..6}86 -> x86 (386?)
    - x86_64 - > amd64 (x64? )
- `cwifinstalled ${recipe} ${program/function} ${args} ...`
  - if a recipe is installed, do something; if not, just return/`true`/`:`
  - cosmetic wrapper around `cwcheckinstalled`
  - ```
    function cwifinstalled() {
      local r="${1}"
      shift
      if cwcheckinstalled "${r}" &>/dev/null ; then
        eval "${@}"
      fi
    }
    ```

<!--
# vim: ft=markdown
-->
