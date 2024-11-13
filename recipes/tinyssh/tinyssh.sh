#
# to use with lshsftpserver:
#   test -e ${cwtop}/etc/tinyssh/ || tinysshd-makekey ${cwtop}/etc/tinyssh/
#   tinysshd-printkey ${cwtop}/etc/tinyssh/
#   env -i ${cwsw}/busybox/current/bin/busybox tcpsvd -vE 0.0.0.0 22222 ${cwsw}/tinyssh/current/sbin/tinysshd -v -x sftp=${cwsw}/lshsftpserver/current/sbin/sftp-server ${cwtop}/etc/tinyssh/
#
rname="tinyssh"
rver="20241111"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/janmojzis/${rname}/archive/refs/tags/${rfile}"
rsha256="c33e0c2a403058c70a279a6c0c0b65fba5d54f9217f51ddce04d0d7fed73abac"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

cwstubfunc "cwconfigure_${rname}"

# XXX - channel tests (at least) break on riscv64...
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -ril /usr/local . | xargs sed -i.ORIG \"/PREFIX/s,/usr/local,\$(cwidir_${rname}),g\"
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS PKG_CONFIG_LIBDIR PKG_CONFIG_PATH
    export CFLAGS='-g0 -Wl,-static -Wl,-s'
    make PREFIX=\"\$(cwidir_${rname})\" CC=\"\${CC}\" LDFLAGS='-static -s'
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
