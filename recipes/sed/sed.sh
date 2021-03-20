#
# XXX - require attr, accl, add --enable-acl to configure
# XXX - add --disable-nls to configure
# XXX - require both toybox and busybox since we need xz (indirectly, via tar)
# XXX - prepend toybox to $PATH since chrome/chromium os sed is sandboxed by default
#

rname="sed"
rver="4.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633"
rreqs="bootstrapmake busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --program-prefix=g
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make install
  ln -sf g${rname} ${ridir}/bin/${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
