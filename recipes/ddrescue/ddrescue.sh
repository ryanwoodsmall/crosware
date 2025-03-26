rname="ddrescue"
rver="1.29.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://ftp.gnu.org/pub/gnu/ddrescue/${rfile}"
rsha256="ddd7d45df026807835a2ec6ab9c365df2ef19e8de1a50ffe6886cd391e04dd75"
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
