rname="reflex"
rver="20210808"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="6b30a09557776cbc7435d974e5cfc50cb6c63da804f3ae2b4065466da0581c21"
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
