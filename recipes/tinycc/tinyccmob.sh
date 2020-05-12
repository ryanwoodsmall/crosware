#
# XXX - libdir setting?
# XXX - use of musl-gcc path precludes ccache
#

rname="tinyccmob"
rver="8de7c092f0aecf7d94aa4723ea7da1fc2c9d10c8"
rdir="${rname//mob/}-${rver:0:7}"
rfile="${rver}.tar.gz"
rurl="https://repo.or.cz/tinycc.git/snapshot/${rfile}"
rsha256=""
rreqs="make muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

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
      --sysincludepaths=\"\${i}:${ridir}/include:${ridir}/lib/tcc/include\" \
      --libpaths=\"\${l}:${ridir}/lib\" \
      --crtprefix=\"\${l}\" \
      --elfinterp=\"\${s}\"
  ln -s include/tcc_predefs.h .
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
