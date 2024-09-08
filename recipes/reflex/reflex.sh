rname="reflex"
rver="20240906"
rdir="${rname}-${rver}"
rfile="${rdir}.tgz"
rurl="https://invisible-mirror.net/archives/${rname}/${rfile}"
rsha256="4e69f0e358da742e72de3996bbfc0f3ed2d438a5c16ee52e24667b07b566222e"
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
