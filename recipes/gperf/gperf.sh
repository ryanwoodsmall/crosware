rname="gperf"
rver="3.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://ftp.gnu.org/pub/gnu/gperf/${rfile}"
rsha256="588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
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
