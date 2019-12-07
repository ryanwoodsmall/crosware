rname="tinycc"
rver="c004e9a34fb026bb44d211ab98bb768e79900eef"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/pub/gnu/guix/mirror/${rfile}"
rsha256="ab6c999d90768b9cb7911f320f5aaf2461fc71b1d94380dabd4274806fb0bfc2"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local m=\"\$(\${CC} -dumpmachine)\"
  local v=\"\$(\${CC} --version | head -1 | awk '{print \$NF}')\"
  local t=\"${cwsw}/statictoolchain/current\"
  local i=\"\${t}/\${m}/include\"
  local l=\"\${t}/\${m}/lib\"
  local s=\"\${l}/ld.so\"
  local c=\"\${t}/lib/gcc/\${m}/\${v}\"
  env CPPFLAGS= CXXFLAGS= LDFLAGS='-static' CFLAGS='-Wl,-static -fPIC' \
    ./configure ${cwconfigureprefix} \
      --cc=\"\${CC}\" \
      --enable-static \
      --config-musl \
      --strip-binaries \
      --sysincludepaths=\"\${i}\" \
      --libpaths=\"\${l}:\${c}\" \
      --crtprefix=\"\${c}:\${l}\" \
      --elfinterp=\"\${s}\"
  unset m v t i l s c
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make CPPFLAGS= CXXFLAGS= LDFLAGS='-static' CFLAGS='-Wl,-static -fPIC'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
