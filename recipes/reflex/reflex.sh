rname="reflex"
rver="20210510"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="96f1b1740489d52dcbbd51a78dbe68360bdcdafc380ed302ec503bcc5eb6b36b"
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
