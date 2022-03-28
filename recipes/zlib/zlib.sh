rname="zlib"
rver="1.2.12"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://zlib.net/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
#rurl="https://downloads.sourceforge.net/project/libpng/${rname}/${rver}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="d8688496ea40fb61787500e863cc63c9afcbc524468cedeb478068924eb54932"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env CFLAGS=\"\${CFLAGS} -fPIC\" ./configure ${cwconfigureprefix} --static
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
