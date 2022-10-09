#
# XXX - need TERM* environment vars?
# XXX - curses pkg-config files don't set -L or -I?
# XXX - oasis version? https://github.com/oasislinux/netbsd-curses
# XXX - install curses_private.h - see rogue
# XXX - define _curx and _cury
# XXX - fix refs to /usr/share/misc/terminfo and /usr/share/tabset/*
#

rname="netbsdcurses"
rver="0.3.2"
rdir="netbsd-curses-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/netbsd-curses/archive/${rfile}"
rsha256="9d3ebd651e5f70b87b1327b01cbd7e0c01a0f036b4c1371f653b7704b11daf23"
rreqs="bootstrapmake configgit"
# we want this to come after ncurses
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

# XXX - full term list:
#       awk -F'|' '/\|/&&!/^(#|$|\t)/{print $1}' terminfo/terminfo | sort -u
# XXX - diff -Naur libterminfo/genterms{.ORIG,} || true
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/(TERMINFODIR)/ s#TERMINFODIR=#TERMINFO=#g;s#(TERMINFODIR)#(PWD)/terminfo/terminfo#g' GNUmakefile
  cat libterminfo/genterms > libterminfo/genterms.ORIG
  sed -n '/^#/,/^TERMLIST=/p' libterminfo/genterms.ORIG > libterminfo/genterms
  egrep -v '^(#|\\t)' terminfo/terminfo \
  | cut -f1 -d'|' \
  | tr -d ',' \
  | sort -u \
  | egrep '^[a-zA-Z0-9]' >> libterminfo/genterms
  sed -n '/^\"$/,//p' libterminfo/genterms.ORIG >> libterminfo/genterms
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd nbperf
  make nbperf CPPFLAGS='-I.. -DTERMINFO_COMPILE -DTERMINFO_DB -DTERMINFO_COMPAT' LDFLAGS='-static'
  cd ..
  make -j${cwmakejobs} all-static PREFIX=\"\$(cwidir_${rname})\" CPPFLAGS='-I./ -I./libterminfo -DTERMINFO_COMPILE -DTERMINFO_DB -DTERMINFO_COMPAT' LDFLAGS='-static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  # LN=echo will disable libncurses symlinks
  make install-static install-manpages PREFIX=\"\$(cwidir_${rname})\" CPPFLAGS='-I./ -I./libterminfo' LDFLAGS='-static' LN='echo'
  rm -f \$(cwidir_${rname})/lib/pkgconfig/ncurses* \$(cwidir_${rname})/lib/pkgconfig/*w.pc
  make terminfo/terminfo.cdb
  cwmkdir \"\$(cwidir_${rname})/share\"
  install -m 644 terminfo/terminfo.cdb \"\$(cwidir_${rname})/share/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
