#
# XXX - zstd support
#
rname="file"
rver="5.46"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://astron.com/pub/file/${rfile}"
rsha256="c9cc77c7c560c543135edc555af609d5619dbef011997e988ce40a3d75d86088"
rreqs="make zlib bzip2 xz"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
