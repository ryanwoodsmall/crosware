#
# XXX - "small" variant w/--enable-small
#
rname="oksh"
rver="7.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ibara/${rname}/releases/download/${rdir}/${rfile}"
rsha256="9f176ff6841435a55f27bfd3ebbfc951c8cca6fdf3638f0123f44617e3992f93"
rreqs="make netbsdcurses"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's/ncurses\.h/curses.h/g' configure emacs.c var.c vi.c
  sed -i 's/-lncurses/-lcurses -lterminfo/g' configure
  env \
    CPPFLAGS= \
    CFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -lcurses -lterminfo -static\" \
      ./configure \
        --prefix=\"\$(cwidir_${rname})\" \
        --bindir=\"\$(cwidir_${rname})/bin\" \
        --mandir=\"\$(cwidir_${rname})/share/man\" \
        --enable-curses \
        --enable-ksh \
        --enable-sh \
        --enable-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  find \$(cwidir_${rname})/bin/ ! -type d | grep 'sh$' | xargs rm -f &>/dev/null || true
  make install
  mv \"\$(cwidir_${rname})/bin/ksh\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/ksh\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/sh\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
