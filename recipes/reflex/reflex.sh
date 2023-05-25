rname="reflex"
rver="20230523"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="312a21529ec28aa1e24583db4d21ac8ad452574e817cc7df3ed3fb22f0f08224"
rreqs="make byacc"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/lex\"
  ln -sf \"${rname}++\" \"\$(cwidir_${rname})/bin/lex++\"
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
