#
# XXX - alpine patches: https://git.alpinelinux.org/aports/tree/main/openssh
# XXX - move config to $cwtop/etc/openssh
#
# for old servers/keys, something like this should suffice - XXX - somewhat insecure!
#
#   KexAlgorithms +diffie-hellman-group1-sha1
#   PubkeyAcceptedKeyTypes +ssh-rsa
#   HostKeyAlgorithms +ssh-rsa
#

rname="openssh"
rver="8.8p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="4590890ea9bb9ace4f71ae331785a3a5823232435161960ed5fc86588f331fe9"
rreqs="groff"

sslprov="openssl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"
