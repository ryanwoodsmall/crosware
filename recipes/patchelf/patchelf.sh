rname="patchelf"
rver="0.19.0"
rdir="${rname}-${rver}"
rfile="${rname}-${rver}.tar.gz"
rurl="https://github.com/NixOS/${rname}/releases/download/${rver}/${rfile}"
rsha256="4782e58d7dd5deae3f8d215f86f94fda0e3d072b583f5ad443846f3381fb472a"
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
