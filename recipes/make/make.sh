#
# XXX - 4.4 changes: MAKE_TMPDIR, etc.; https://lists.gnu.org/archive/html/info-gnu/2022-10/msg00008.html
#
rname="make"
rver="4.4.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="dd16fb1d67bfab79a72f5e8390735c49e3e8e70b4945a15ab1f81ddb78658fb3"
rreqs="busybox sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-dependency-tracking \
    --disable-load \
    --disable-nls \
    --without-guile \
      LDFLAGS=-static \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    LDFLAGS=-static \
    CPPFLAGS= \
    PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" \
      \"${cwsw}/busybox/current/bin/ash\" ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    LDFLAGS=-static \
    CPPFLAGS= \
    PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" \
      ./make install-binPROGRAMS
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/g${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/gnu${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export MAKE_TMPDIR=\"${cwtop}/tmp\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
