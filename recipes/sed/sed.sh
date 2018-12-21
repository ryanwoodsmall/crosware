#
# XXX - require both toybox and busybox since we need xz (indirectly, via tar)
# XXX - prepend toybox to $PATH since chrome/chromium os sed is sandboxed by default
#

rname="sed"
rver="4.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="beff6acf1c7838cc722714d143a64e706e2fd3bd1e00d3cd75152f596b09bb9e"
rreqs="make busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/toybox/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --program-prefix=g
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/toybox/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/toybox/current/bin:\${PATH}\" make install
  ln -sf g${rname} ${ridir}/bin/${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
