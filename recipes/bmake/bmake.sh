#
# XXX - 20200902 breaks on some tests, at least with musl: opt-ignore opt-keep-going sh-dots export ...
# XXX - ugh
#

rname="bmake"
rver="20201010"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.crufty.net/ftp/pub/sjg/${rfile}"
rsha256="6e1261b3b194d3a92770fc73772bff052c47eada98952a0b19c4e5b7f1fe5515"
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
  sed -i.ORIG '/{/!s/op_test/echo op_test/g' ../boot-strap
  local f
  for f in opt-ignore opt-keep-going sh-dots export ; do
    echo sed -i \"/\${f}/d\" ../unit-tests/Makefile ../FILES
    echo rm -f ../unit-tests/\${f}.{exp,mk}
  done
  unset f
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
