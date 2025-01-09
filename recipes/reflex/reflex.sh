rname="reflex"
rver="20241231"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="06a8c57fb666d74c8450e6aa2e471835a0ca2995b3621fb64f9cc4ce9daad6b6"
rreqs="make byacc diffutils"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwidir_${rname})/share/man/man1
  make install
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/lex\"
  ln -sf \"${rname}++\" \"\$(cwidir_${rname})/bin/lex++\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
