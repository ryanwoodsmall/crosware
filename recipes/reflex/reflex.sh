rname="reflex"
rver="20191123"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="5623f4a520fa2f51abb23037fbb6b2aafac0e9cc60ddaa70ba727e0e01ef053f"
rreqs="make byacc"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  ln -sf \"${ridir}/bin/${rname}\" \"${ridir}/bin/lex\"
  ln -sf \"${ridir}/bin/${rname}++\" \"${ridir}/bin/lex++\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
