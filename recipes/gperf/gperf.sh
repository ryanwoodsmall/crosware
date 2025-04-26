rname="gperf"
rver="3.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://ftp.gnu.org/pub/gnu/gperf/${rfile}"
rsha256="fd87e0aba7e43ae054837afd6cd4db03a3f2693deb3619085e6ed9d8d9604ad8"
rreqs="configgit bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    LDFLAGS=-static \
    {CPPFLAGS,PKG_CONFIG_{LIBDIR,PATH}}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
