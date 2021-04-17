rname="thttpd"
rver="2.29"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.acme.com/software/${rname}/${rfile}"
rsha256="99c09f47da326b1e7b5295c45549d2b65534dce27c44812cf7eef1441681a397"
rreqs="bootstrapmake configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's/-o bin -g bin//g' Makefile.in
  cat extras/Makefile.in > extras/Makefile.in.ORIG
  sed -i /chgrp/d extras/Makefile.in
  sed -i '/cp.*MANDIR/s,cp,install -D -m 0644,g' extras/Makefile.in
  sed -i '/cp.*BINDIR/s,cp,install -D -m 0755,g' extras/Makefile.in
  env LDFLAGS=-static CPPFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH= \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
