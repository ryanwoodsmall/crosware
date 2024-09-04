rname="tio"
rver="3.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="dbaef5dc6849229ce4eb474d4de77a7302cd2b0657731a8df86a44dd359e6afb"
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
