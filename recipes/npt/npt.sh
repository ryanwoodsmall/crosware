rname="npt"
rver="1.1.1"
rdir="${rname}-${rver}"
rfile="v${rver}.tar.gz"
rurl="https://github.com/nptcl/npt/archive/refs/tags/${rfile}"
rsha256="f154eb622b0fd96efde678d8292ac2bdbb899be64221441eadf0a963b4fc0429"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s,-lm,-lm -static,g;s,-O3,-Os,g\" build/Makefile.linux_terme_release
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}= \
      bash build/linux_terme_release.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname} \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/${rname}terme\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/${rname}-terme\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
