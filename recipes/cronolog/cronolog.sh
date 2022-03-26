rname="cronolog"
rver="1.6.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="65e91607643e5aa5b336f17636fa474eb6669acc89288e72feb2f54a27edb88e"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CFLAGS=\"\${CFLAGS} -Wl,-s\" LDFLAGS='-s -static' CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}= \
    ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
