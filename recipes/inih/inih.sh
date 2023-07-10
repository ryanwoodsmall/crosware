rname="inih"
rver="r57"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/benhoyt/${rname}/archive/refs/tags/${rfile}"
rsha256="f03f98ca35c3adb56b2358573c8d3eda319ccd5287243d691e724b7eafa970b3"
rreqs="meson ninja"

. "${cwrecipe}/common.sh"

# XXX - remove when fixed upstream
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG s,56,57,g meson.build
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" --prefix=\"\$(cwidir_${rname})\" --libdir=\"\$(cwidir_${rname})/lib\" -Ddefault_library=static build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" install -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_cppflags \"-I${rtdir}/current/include\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
