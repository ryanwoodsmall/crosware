rname="pv"
rver="1.7.24"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/a-j-wood/pv/releases/download/v${rver}/${rfile}"
rsha256="3bf43c5809c8d50066eaeaea5a115f6503c57a38c151975b710aa2bee857b65e"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
      CFLAGS=\"\${CFLAGS} -Os -Wl,-s\" \
      CXXFLAGS=\"\${CXXFLAGS} -Os -Wl,-s\" \
      LDFLAGS=\"-s -static\" \
      PKG_CONFIG_{LIBDIR,PATH}= \
      CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
