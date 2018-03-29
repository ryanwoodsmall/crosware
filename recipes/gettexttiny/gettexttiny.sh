#
# XXX - use musl libintl
#   - make LIBINTL=MUSL
#

rname="gettexttiny"
rver="0.2.0"
rdir="gettext-tiny-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/sabotage-linux/gettext-tiny/archive/${rfile}"
rsha256="1e0b57c4befb76f8f5c55f57ea4f1c2dbe62f57b80c34276fd49d870edf03dcb"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG \"s#^prefix=.*#prefix=${ridir}#g\" Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LIBINTL=MUSL make -j$(($(nproc)+1))
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env LIBINTL=MUSL make install
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
