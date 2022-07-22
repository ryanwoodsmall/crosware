rname="pv"
rver="1.6.20"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/a-j-wood/pv/releases/download/v${rver}/${rfile}"
rsha256="b5f1ee79a370c5287e092b6e8f1084f026521fe0aecf25c44b9460b870319a9e"
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
