#
# XXX - zstd support
#
rname="file"
rver="5.47"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://astron.com/pub/file/${rfile}"
rsha256="45672fec165cb4cc1358a2d76b5d57d22876dcb97ab169427ac385cbe1d5597a"
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
