rname="unrar"
rver="7.2.6"
rdir="${rname}"
rfile="${rname}src-${rver}.tar.gz"
rurl="https://www.rarlab.com/rar/${rfile}"
rsha256="d1afa67ef4121ebc5986815699e05db0ce8648499e5dca854f282a4c3f72c003"
rreqs="make"
ridir="${cwsw}/${rname}/${rname}-${rver}"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cp makefile{,.ORIG}
  sed -i \"/^CXX=/s#^CXX=.*#CXX=\${CXX}#g\" makefile
  sed -i \"/^DESTDIR=/s#^DESTDIR=.*#DESTDIR=\$(cwidir_${rname})#g\" makefile
  sed -i '/^CXXFLAGS=/s/$/ -Wl,-static -fPIC/g' makefile
  sed -i '/^LDFLAGS=/s/$/ -static/g' makefile
  sed -i 's/\$(CPPFLAGS)//g' makefile
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
