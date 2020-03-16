rname="help2man"
rver="1.47.13"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/pub/gnu/${rname}/${rfile}"
rsha256="b7f8bbad1f2c405db747e3f5a4d5e1eddc63b360221c824bf79748f27b560523"
rreqs="make perl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" make
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" make install
  sed -i 's#${cwsw}/perl/perl-.*/bin/perl #${cwsw}/perl/current/bin/perl #g' \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
