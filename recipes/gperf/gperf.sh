rname="gperf"
rver="3.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://ftp.gnu.org/pub/gnu/gperf/${rfile}"
rsha256="e0ddadebb396906a3e3e4cac2f697c8d6ab92dffa5d365a5bc23c7d41d30ef62"
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
