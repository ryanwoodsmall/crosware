rname="unrar"
rver="5.9.2"
rdir="${rname}"
rfile="${rname}src-${rver}.tar.gz"
rurl="https://www.rarlab.com/rar/${rfile}"
rsha256="73d3baf18cf0a197976af2794a848893c35e7d42cee0ff364c89d2e476ebdaa6"
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
