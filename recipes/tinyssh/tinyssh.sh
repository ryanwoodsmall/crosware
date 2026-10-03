#
# to use with lshsftpserver:
#   test -e ${cwtop}/etc/tinyssh/ || tinysshd-makekey ${cwtop}/etc/tinyssh/
#   tinysshd-printkey ${cwtop}/etc/tinyssh/
#   env -i ${cwsw}/busybox/current/bin/busybox tcpsvd -vE 0.0.0.0 22222 ${cwsw}/tinyssh/current/sbin/tinysshd -v -x sftp=${cwsw}/lshsftpserver/current/sbin/sftp-server ${cwtop}/etc/tinyssh/
#
# XXX - something in this commit breaks dropbear
#   commit b24aba92a84d700fcb8d6defccae41c5f32c48cd (HEAD)
#   Author: Jan Mojžíš <jan.mojzis@gmail.com>
#   Date:   Sat Sep 5 14:48:32 2026 +0000
#
#       sshcrypto: add sntrup761x25519-sha512 KEX
#
# client:
#   $ dbclient -V
#   Dropbear v2025.89
#   $ dbclient -yy user0host/22223
#   dbclient: Connection to user@host:22223 exited: Bad hostkey signature
#
# server:
#   tcpsvd: listening on 0.0.0.0:22223, starting
#   tcpsvd: status 1/30
#   tcpsvd: start 1087509 10.0.0.1:22223-10.0.0.2:33694
#   tinysshd: oMP07ohV: info: connection from 10.0.0.2:33694 {main_tinysshd.c:179}
#   tinysshd: oMP07ohV: debug: hello: server: SSH-2.0-tinyssh oMP07ohV {packet_hello.c:39}
#   tinysshd: oMP07ohV: debug: hello: client: SSH-2.0-dropbear_2025.89 {packet_hello.c:72}
#   tinysshd: oMP07ohV: debug: kex: server: kex algorithms: curve25519-sha256,curve25519-sha256@libssh.org,sntrup761x25519-sha512,sntrup761x25519-sha512@openssh.com,kex-strict-s-v00@openssh.com {sshcrypto_kex.c:199}
#   tinysshd: oMP07ohV: debug: kex: server: key algorithms: ssh-ed25519 {sshcrypto_key.c:165}
#   tinysshd: oMP07ohV: debug: kex: server: cipher algorithms: chacha20-poly1305@openssh.com {sshcrypto_cipher.c:133}
#   tinysshd: oMP07ohV: debug: kex: server: cipher algorithms: chacha20-poly1305@openssh.com {sshcrypto_cipher.c:133}
#   tinysshd: oMP07ohV: debug: kex: server: mac algorithms: hmac-sha2-256 {sshcrypto_cipher.c:144}
#   tinysshd: oMP07ohV: debug: kex: server: mac algorithms: hmac-sha2-256 {sshcrypto_cipher.c:144}
#   tinysshd: oMP07ohV: debug: kex: client: kex algorithms: sntrup761x25519-sha512,sntrup761x25519-sha512@openssh.com,mlkem768x25519-sha256,curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1,diffie-hellman-group1-sha1,diffie-hellman-group16-sha512,kexguess2@matt.ucc.asn.au,ext-info-c,kex-strict-c-v00@openssh.com {sshcrypto_kex.c:122}
#   tinysshd: oMP07ohV: debug: kex: pseudokex selected: kex-strict-s-v00@openssh.com {sshcrypto_kex.c:133}
#   tinysshd: oMP07ohV: debug: kex: kex selected: sntrup761x25519-sha512 {sshcrypto_kex.c:158}
#   tinysshd: oMP07ohV: debug: kex: client: key algorithms: ssh-ed25519,sk-ssh-ed25519@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,sk-ecdsa-sha2-nistp256@openssh.com,rsa-sha2-256,ssh-rsa,ssh-dss {sshcrypto_key.c:112}
#   tinysshd: oMP07ohV: debug: kex: key selected: ssh-ed25519 {sshcrypto_key.c:133}
#   tinysshd: oMP07ohV: debug: kex: client: cipher algorithms: chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes128-ctr,aes256-cbc,aes128-cbc,3des-ctr,3des-cbc {sshcrypto_cipher.c:73}
#   tinysshd: oMP07ohV: debug: kex: cipher selected: chacha20-poly1305@openssh.com {sshcrypto_cipher.c:92}
#   tinysshd: oMP07ohV: debug: kex: client: mac algorithms: hmac-sha1-96,hmac-sha1,hmac-sha2-256,hmac-sha2-512 {sshcrypto_cipher.c:105}
#   tinysshd: oMP07ohV: debug: kex: mac selected: hmac-sha2-256 (ignored for chacha20-poly1305@openssh.com) {sshcrypto_cipher.c:106}
#   tinysshd: oMP07ohV: fatal: strict KEX mode: rejecting non-SSH_MSG_NEWKEYS packet {packet_kexdh.c:107}
#   tinysshd: oMP07ohV: fatal: unable to process kexdh {main_tinysshd.c:247}
#   tcpsvd: end 1087509 exit 111
#   tcpsvd: status 0/30
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
cwprependfunc "cwinstall_${rname}" 'if [[ "${karch}" == ^riscv64 ]] ; then cwfailexit "tinyssh may fail on riscv64" ; fi'

## XXX - channel tests (at least) break on riscv64...
#if [[ ${karch} =~ ^riscv64 ]] ; then
#  eval "function cwinstall_${rname}() { cwscriptecho \"recipe ${rname} does not support architecture ${karch}\" ; }"
#fi

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwscriptecho 'patching in ${cwsw}'
  grep -ril /usr/local . | xargs sed -i.ORIG \"/PREFIX/s,/usr/local,\$(cwidir_${rname}),g\"
  cwscriptecho 'custom workaround for dropbear'
  patch -p1 < \"${cwrecipe}/tinyssh/patches/b24aba92a84d700fcb8d6defccae41c5f32c48cd-dropbear_workaround.patch\"
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

# vim: set ft=bash:
