#
# XXX - require both toybox and busybox since we need xz (indirectly, via tar)
# XXX - prepend toybox to $PATH since chrome/chromium os sed is sandboxed by default
#

rname="sed"
rver="4.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="2885768cd0a29ff8d58a6280a270ff161f6a3deb5690b2be6c49f46d4c67bd6a"
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
