rname="unrar"
rver="6.0.1"
rdir="${rname}"
rfile="${rname}src-${rver}.tar.gz"
rurl="https://www.rarlab.com/rar/${rfile}"
rsha256="43e4d3ac762e2f58bfa9e37693efa342c1363eb1029fab409dfdf69171201450"
rreqs="make"
ridir="${cwsw}/${rname}/${rname}-${rver}"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cp makefile{,.ORIG}
  sed -i \"/^CXX=/s#^CXX=.*#CXX=\${CXX}#g\" makefile
  sed -i \"/^DESTDIR=/s#^DESTDIR=.*#DESTDIR=${ridir}#g\" makefile
  sed -i '/^CXXFLAGS=/s/$/ -Wl,-static -fPIC/g' makefile
  sed -i '/^LDFLAGS=/s/$/ -static/g' makefile
  sed -i 's/\$(CPPFLAGS)//g' makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
