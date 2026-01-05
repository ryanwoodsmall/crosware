rname="ddrescue"
rver="1.30"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://ftp.gnu.org/pub/gnu/ddrescue/${rfile}"
rsha256="2264622d309d6c87a1cfc19148292b8859a688e9bc02d4702f5cd4f288745542"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CC=\"\${CC}\" \
    CXX=\"\${CXX}\" \
    CFLAGS=\"\${CFLAGS} -g0 -Wl,-s -Os\" \
    CXXFLAGS=\"\${CXXFLAGS} -g0 -Wl,-s -Os\" \
    LDFLAGS='-static -s'
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
