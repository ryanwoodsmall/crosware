rname="tio"
rver="2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="e5826109773a89b267c3484df71234bc6c45715f735e3fdbee5984768faf5836"
rreqs="ninja meson inih pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" --prefix=\"\$(cwidir_${rname})\" build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" install -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
