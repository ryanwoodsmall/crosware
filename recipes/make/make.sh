rname="make"
rver="4.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="e05fdde47c5f7ca45cb697e973894ff4f5d79e13b750ed57d7b66d8defc78e19"
rreqs="busybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --disable-dependency-tracking \
    --disable-load \
    --disable-nls \
    --without-guile \
      LDFLAGS=-static CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LDFLAGS=-static CPPFLAGS= PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" \"${cwsw}/busybox/current/bin/ash\" ./build.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LDFLAGS=-static CPPFLAGS= PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" ./make install-binPROGRAMS
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/g${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/bin/gnu${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
