#
# to use with lshsftpserver:
#   test -e ${cwtop}/etc/tinyssh/ || tinysshd-makekey ${cwtop}/etc/tinyssh/
#   tinysshd-printkey ${cwtop}/etc/tinyssh/
#   env -i ${cwsw}/busybox/current/bin/busybox tcpsvd -vE 0.0.0.0 22222 ${cwsw}/tinyssh/current/sbin/tinysshd -v -x sftp=${cwsw}/lshsftpserver/current/sbin/sftp-server ${cwtop}/etc/tinyssh/
#
rname="tinyssh"
rver="20261001"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/janmojzis/${rname}/archive/refs/tags/${rfile}"
rsha256="f79b1b4b8db16d3b1ecc339828d48c3754e354634ac28d2fbf82c85da56e503e"
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
  : sed -i.ORIG 's/^#define.*sshcrypto_FLAGSTRICTKEX.*/#define sshcrypto_FLAGSTRICTKEX 0x0/g' sshcrypto.h
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
