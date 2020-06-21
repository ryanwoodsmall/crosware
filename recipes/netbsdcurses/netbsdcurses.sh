#
# XXX - need global terminfo db?
# XXX - i.e., "make terminfo/terminfo.cdb && cp terminfo/terminfo.cdb ${ridir}/share/"
# XXX - need TERM* environment vars?
# XXX - readline version bundled in install - hacky but ehh
# XXX - bundle slang?
# XXX - curses pkg-config files don't set -L or -I?
# XXX - include... all terms? in compiled lib? hmm
# XXX - include all terms with a scriptlet like...
#   sed -n '/^TERMLIST="$/,/^"$/d;p' libterminfo/genterms > libterminfo/genterms.NEW
#   sed -i '/^echo$/a\
#   TERMLIST=|\
#   |' libterminfo/genterms.NEW
#   egrep -v '^(#|$|\t)' terminfo/terminfo | grep '|' | cut -f1 -d'|' | sort -u | while read -r t ; do
#     sed -i "/^TERMLIST=|/a\
#     ${t}" libterminfo/genterms.NEW
#   done
#   sed -i 's/|/"/g' libterminfo/genterms.NEW
#   cat libterminfo/genterms.NEW > libterminfo/genterms
#   chmod 755 libterminfo/genterms
#

rname="netbsdcurses"
rver="0.3.1"
rdir="netbsd-curses-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/netbsd-curses/archive/${rfile}"
rsha256="bebaf1656440409b0b0e40b5a336c97dcd142e2368b47840a353040fe34d987f"
rreqs="make"
# we want this to come after ncurses
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_readline
  cwfetch_libedit
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"${cwdl}/readline/readline-\$(cwver_readline).tar.gz\" \"${rbdir}\"
  cwextract \"${cwdl}/libedit/libedit-\$(cwver_libedit).tar.gz\" \"${rbdir}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
#  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
#  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
#  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"

eval "
function cwconfigure_${rname}() {
  true
}
"

# XXX - full term list:
#       awk -F'|' '/\|/&&!/^(#|$|\t)/{print $1}' terminfo/terminfo | sort -u
eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/(TERMINFODIR)/ s#TERMINFODIR=#TERMINFO=#g;s#(TERMINFODIR)#(PWD)/terminfo/terminfo#g' GNUmakefile
  sed -i.ORIG '/^screen$/a\\
screen-256color\\
tmux\\
tmux-256color\\
ansi+enq\\
ansi+rca\\
ansi+pp\\
ansi+tabs\\
dec+sl\\
vt220\\
vt220-w\\
vt220-8bit\\
vt220+keypad\\
vt320\\
vt340\\
vt400\\
vt420\\
vt420f\\
vt420pc\\
vt420pcdos\\
vt510\\
vt510pc\\
vt510pcdos\\
vt520\\
vt525\\
vt520ansi' libterminfo/genterms
  diff -Naur libterminfo/genterms{.ORIG,} || true
  cd nbperf
  make nbperf CPPFLAGS='-I..' LDFLAGS='-static'
  cd ..
  make -j${cwmakejobs} all-static PREFIX="${ridir}" CPPFLAGS='-I./ -I./libterminfo' LDFLAGS='-static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  # LN=echo will disable libncurses symlinks
  make install-static PREFIX="${ridir}" CPPFLAGS='-I./ -I./libterminfo' LDFLAGS='-static' LN='echo'
  rm -f ${ridir}/lib/pkgconfig/ncurses* ${ridir}/lib/pkgconfig/*w.pc
  make terminfo/terminfo.cdb
  cwmkdir \"${ridir}/share\"
  install -m 644 terminfo/terminfo.cdb \"${ridir}/share/\"
  cwmakeinstall_${rname}_readline
  cwmakeinstall_${rname}_libedit
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_readline() {
  pushd "${rbdir}" >/dev/null 2>&1
  cd readline-\$(cwver_readline)/
  env PATH=\"${ridir}/bin:\${PATH}\" ./configure \
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    --with-curses \
    ${cwconfigurefpicopts} \
      CPPFLAGS=\"-I${ridir}/include\" \
      LDFLAGS=\"-L${ridir}/lib -static\" \
      LIBS=\"-lcurses -lterminfo\" \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  make -j${cwmakejobs}
  make install
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}_libedit() {
  pushd "${rbdir}" >/dev/null 2>&1
  cd libedit-\$(cwver_libedit)/
  env PATH=\"${ridir}/bin:\${PATH}\" ./configure \
    ${cwconfigureprefix} \
    ${cwconfigurelibopts} \
    ${cwconfigurefpicopts} \
      CFLAGS=\"\${CFLAGS} -D__STDC_ISO_10646__=201206L\" \
      CPPFLAGS=\"-I${ridir}/include\" \
      LDFLAGS=\"-L${ridir}/lib -static\" \
      LIBS=\"-lcurses -lterminfo\" \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  make -j${cwmakejobs}
  make install
  popd >/dev/null 2>&1
}
"
