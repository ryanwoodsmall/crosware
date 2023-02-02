rname="ddrescue"
rver="1.27"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="http://download.savannah.gnu.org/releases/${rname}/${rfile}"
rsha256="38c80c98c5a44f15e53663e4510097fd68d6ec20758efdf3a925037c183232eb"
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
