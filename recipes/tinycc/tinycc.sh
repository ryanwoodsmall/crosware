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
  ./configure ${cwconfigureprefix} \
    --cc=\"\${CC}\" \
    --enable-static \
    --config-musl \
    --strip-binaries \
    --sysincludepaths=\"${cwsw}/statictoolchain/current/\${m}/include\" \
    --libpaths=\"${cwsw}/statictoolchain/current/\${m}/lib\" \
    --crtprefix=\"${cwsw}/statictoolchain/current/\${m}/lib\" \
    --elfinterp=\"${cwsw}/statictoolchain/current/\${m}/lib/ld.so\"
  unset m
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
