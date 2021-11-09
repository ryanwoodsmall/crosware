rname="par"
rver="1.53.0"
rdir="Par-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://www.nicemice.net/${rname}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="c809c620eb82b589553ac54b9898c8da55196d262339d13c046f2be44ac47804"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat protoMakefile > protoMakefile.ORIG
  sed -i \"/^LINK1/s/=.*/= \${CC} -static/g\" protoMakefile
  sed -i \"s/ cc / \${CC} \${CFLAGS} /g\" protoMakefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -f protoMakefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/bin\"
  cwmkdir \"${ridir}/share/doc/${rname}\"
  cwmkdir \"${ridir}/share/man/man1\"
  install -m 0755 \"${rname}\" \"${ridir}/bin/${rname}\"
  install -m 0644 \"${rname}.doc\" \"${ridir}/share/doc/${rname}/${rname}.doc\"
  install -m 0644 \"${rname}.1\" \"${ridir}/share/man/man1/${rname}.1\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
