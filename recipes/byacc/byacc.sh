rname="byacc"
rver="20191119"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="e21a530e664e88d062530fbe4b1a308ddf65db7ec55c7372e0968e755ef20832"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  rm -f \"${ridir}/bin/{b,}yacc\"
  make install
  mv \"${ridir}/bin/yacc\" \"${ridir}/bin/byacc\"
  ln -sf \"${rtdir}/current/bin/byacc\" \"${ridir}/bin/yacc\"
  popd >/dev/null 2>&1
}
"
