rname="tio"
rver="3.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="efd3e9a406f827ac22d4157e345079dde15ee5a948b24156561d6c97a54e6ec0"
rreqs="ninja meson inih pkgconfig lua glib muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"${cwsw}/muslstandalone/current/bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"\$(cwidir_${rname})\" build
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"${cwsw}/muslstandalone/current//bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    PATH=\"${cwsw}/muslstandalone/current/bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" install -C build
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
