#
# XXX - require attr, accl, add --enable-acl to configure
# XXX - add --disable-nls to configure
# XXX - require both toybox and busybox since we need xz (indirectly, via tar)
# XXX - prepend toybox to $PATH since chrome/chromium os sed is sandboxed by default
#

rname="sed"
rver="4.9"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="6e226b732e1cd739464ad6862bd1a1aba42d7982922da7a53519631d24975181"
rreqs="bootstrapmake busybox toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" ./configure ${cwconfigureprefix} --program-prefix=g
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make -j${cwmakejobs}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/busybox/current/bin:\${PATH}\" make install
  ln -sf g${rname} \$(cwidir_${rname})/bin/${rname}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
