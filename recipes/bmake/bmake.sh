rname="bmake"
rver="20200506"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.crufty.net/ftp/pub/sjg/${rfile}"
rsha256="0ac33c9bb00f12e54a3571e492f8c88cd835f6df64533d008e188a47373538e2"
rreqs=""
rbdir="${cwbuild}/${rdir}/build"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  mv \"${rname}\" \"${rdir}\"
  cwmkdir \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  rm -rf \"${rdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  true
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env CPPFLAGS= LDFLAGS=-static sh ../boot-strap --prefix=\"${ridir}\" op=build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env INSTALL=install CPPFLAGS= LDFLAGS=-static sh ../boot-strap --prefix=\"${ridir}\" op=install
  cwmkdir \"${ridir}/share/man/man1\"
  rm -rf \"${ridir}/share/man/cat1\"
  install -m0644 ../${rname}.1 \"${ridir}/share/man/man1/\"
  install -m0644 ../make.1 \"${ridir}/share/man/man1/\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
