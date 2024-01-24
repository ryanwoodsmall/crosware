rname="ddrescue"
rver="1.28"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
#rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rurl="http://ftp.gnu.org/pub/gnu/ddrescue/${rfile}"
rsha256="6626c07a7ca1cc1d03cad0958522c5279b156222d32c342e81117cfefaeb10c1"
rreqs="make lunzip"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC}\" \
    CXX=\"\${CXX}\" \
    CFLAGS=\"\${CFLAGS} -g0 -Wl,-s -Os\" \
    CXXFLAGS=\"\${CXXFLAGS} -g0 -Wl,-s -Os\" \
    LDFLAGS='-static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
