rname="tio"
rver="2.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="bf8fe434848c2c1b6540af0b42503c986068176ddc1a988cf02e521e7de5daa5"
rreqs="ninja meson inih pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"\$(cwidir_${rname})\" build
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
