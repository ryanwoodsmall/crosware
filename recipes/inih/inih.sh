rname="inih"
rver="r60"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/benhoyt/${rname}/archive/refs/tags/${rfile}"
rsha256="706aa05c888b53bd170e5d8aa8f8a9d9ccf5449dfed262d5103d1f292af26774"
rreqs="meson ninja"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" setup --prefix=\"\$(cwidir_${rname})\" --libdir=\"\$(cwidir_${rname})/lib\" -Ddefault_library=static build
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" install -C build
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
