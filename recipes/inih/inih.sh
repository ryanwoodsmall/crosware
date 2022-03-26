rname="inih"
rver="r55"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/benhoyt/${rname}/archive/refs/tags/${rfile}"
rsha256="ba55f8ae2a8caf0653f30f48567241e14ea916acfc13481f502d8a9c8f507f68"
rreqs="meson ninja"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" --prefix=\"${ridir}\" --libdir=\"${ridir}/lib\" -Ddefault_library=static build
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"${cwsw}/meson/current/bin:${cwsw}/ninja/current/bin:\${PATH}\" \
    \"${cwsw}/meson/current/bin/meson\" compile -C build
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
