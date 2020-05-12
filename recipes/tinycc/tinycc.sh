#
# XXX - libdir setting?
# XXX - use of musl-gcc path precludes ccache
#

rname="tinycc"
rver="c004e9a34fb026bb44d211ab98bb768e79900eef"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/pub/gnu/guix/mirror/${rfile}"
rsha256="ab6c999d90768b9cb7911f320f5aaf2461fc71b1d94380dabd4274806fb0bfc2"
rreqs="make muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local t=\"${cwsw}/muslstandalone/current\"
  local i=\"\${t}/include\"
  local l=\"\${t}/lib\"
  local s=\"\${l}/ld.so\"
  env CPPFLAGS= CXXFLAGS= LDFLAGS='-static' CFLAGS='-Wl,-static -fPIC' \
    ./configure ${cwconfigureprefix} \
      --cc=\"${cwsw}/muslstandalone/current/bin/musl-gcc\" \
      --enable-static \
      --config-musl \
      --strip-binaries \
      --extra-cflags=\"\${CFLAGS}\" \
      --extra-ldflags=\"-static\" \
      --sysincludepaths=\"\${i}\" \
      --libpaths=\"\${l}\" \
      --crtprefix=\"\${l}\" \
      --elfinterp=\"\${s}\"
  unset t i l s
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CPPFLAGS= CXXFLAGS= LDFLAGS='-static' CFLAGS='-Wl,-static -fPIC' CC=\"${cwsw}/muslstandalone/current/bin/musl-gcc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
