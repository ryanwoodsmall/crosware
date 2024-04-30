rname="tio"
rver="3.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="b7ec8eab6c29a3821e3f1239cf6baa84ef634ea2188ffa93d7a276c89338961e"
rreqs="ninja meson inih pkgconfig lua glib muslstandalone"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/muslstandalone/current/bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"\$(cwidir_${rname})\" build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/muslstandalone/current//bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    PATH=\"${cwsw}/muslstandalone/current/bin:${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:${cwsw}/lua/current/bin:\${PATH}\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      \"${cwsw}/meson/current/bin/meson\" install -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
