#
# XXX - 20200902 breaks on some tests, at least with musl: opt-ignore opt-keep-going sh-dots export ...
# XXX - ugh
#
rname="bmake"
rver="20240808"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://www.crufty.net/ftp/pub/sjg/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="b59189251b483decd4492f1f74387b2a584c03d5aa4637cd48b38ec62b9c0848"
rreqs=""
rbdir="${cwbuild}/${rdir}/build"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"${rname}\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  mv \"${rname}\" \"\$(cwdir_${rname})\"
  cwmkdir \"\$(cwbdir_${rname})\"
  popd &>/dev/null
}
"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" &>/dev/null
  rm -rf \"\$(cwbdir_${rname})\"
  rm -rf \"${rdir}\"
  rm -rf \"${rname}\"
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/{/!s/op_test/echo op_test/g' ../boot-strap
  local f
  for f in opt-ignore opt-keep-going sh-dots export ; do
    echo sed -i \"/\${f}/d\" ../unit-tests/Makefile ../FILES
    echo rm -f ../unit-tests/\${f}.{exp,mk}
  done
  unset f
  true
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env CPPFLAGS= LDFLAGS=-static sh ../boot-strap --prefix=\"\$(cwidir_${rname})\" op=build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env INSTALL=install CPPFLAGS= LDFLAGS=-static sh ../boot-strap --prefix=\"\$(cwidir_${rname})\" op=install
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  rm -rf \"\$(cwidir_${rname})/share/man/cat1\"
  install -m0644 ../${rname}.1 \"\$(cwidir_${rname})/share/man/man1/\"
  install -m0644 ../make.1 \"\$(cwidir_${rname})/share/man/man1/\"
  popd &>/dev/null
}
"

eval "
function cwlatestver_${rname}() {
  ${cwcurl} ${cwcurlopts} \"${rurl%${rfile}}\" \
  | cut -f2 -d'\"' \
  | grep '^${rname}-' \
  | sed 's/^${rname}-//g' \
  | cut -f1 -d. \
  | tail -1
}
"

eval "
function cwgenprofd_${rname}() {
  rm -f \"${cwetcprofd}/${rname}.sh\"
  echo 'append_path \"${cwsw}/make/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${cwsw}/bootstrapmake/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
