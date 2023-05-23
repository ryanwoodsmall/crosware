rname="reflex"
rver="20230521"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="5d0556d5f1833f3ce679d1ff67d579a4bf003c520274c4f886f7a0264ed3e321"
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
