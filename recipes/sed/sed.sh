#
# XXX - require attr, accl, add --enable-acl to configure
# XXX - add --disable-nls to configure
# XXX - require both toybox and busybox since we need xz (indirectly, via tar)
# XXX - prepend toybox to $PATH since chrome/chromium os sed is sandboxed by default
#

rname="sed"
rver="4.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="b8e72182b2ec96a3574e2998c47b7aaa64cc20ce000d8e9ac313cc07cecf28c7"
rreqs="bootstrapmake busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --program-prefix=g
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make install
  ln -sf g${rname} \$(cwidir_${rname})/bin/${rname}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
