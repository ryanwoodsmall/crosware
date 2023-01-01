#
# to use with lshsftpserver:
#   test -e ${cwtop}/etc/tinyssh/ || tinysshd-makekey ${cwtop}/etc/tinyssh/
#   tinysshd-printkey ${cwtop}/etc/tinyssh/
#   env -i ${cwsw}/busybox/current/bin/busybox tcpsvd -vE 0.0.0.0 22222 ${cwsw}/tinyssh/current/sbin/tinysshd -v -x sftp=${cwsw}/lshsftpserver/current/sbin/sftp-server ${cwtop}/etc/tinyssh/
#
rname="tinyssh"
rver="20230101"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/janmojzis/${rname}/archive/refs/tags/${rfile}"
rsha256="74a434389dd05bf421feb6b6fab241f763b78222750d21100bd81d9ba626b28c"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

# XXX - channel tests (at least) break on riscv64...
if [[ ${karch} =~ ^riscv64 ]] ; then
eval "
function cwinstall_${rname}() {
  cwscriptecho \"recipe ${rname} does not support architecture ${karch}\"
}
"
fi

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  echo \"\$(cwidir_${rname})/sbin\" > conf-bin
  echo \"\$(cwidir_${rname})/share/man\" > conf-man
  echo \"\${AR}\" > conf-ar
  echo \"\${CC}\" > conf-cc
  echo '-Wl,-static' >> conf-cflags
  echo '-static' >> conf-libs
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make CFLAGS= CPPFLAGS= CXXFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
