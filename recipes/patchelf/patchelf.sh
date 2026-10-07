rname="patchelf"
rver="0.19.2"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="78cb26bda2b89fababfe189c2f6507240340f1aa45dec2eb49a39473a50ceea1"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    C{,XX}FLAGS=\"\${CFLAGS} -Wl,-s -Os -g0\" \
    LDFLAGS='-static -s' \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
