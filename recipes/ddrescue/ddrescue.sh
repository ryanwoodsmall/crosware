rname="ddrescue"
rver="1.29"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://ftp.gnu.org/pub/gnu/ddrescue/${rfile}"
rsha256="01a414327853b39fba2fd0ece30f7bee2e9d8c8e8eb314318524adf5a60039a3"
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
