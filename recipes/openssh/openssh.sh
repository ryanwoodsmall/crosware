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
# XXX - https://gist.github.com/ryanwoodsmall/1bd42c1323d23b77845fef30afcc2d46
#

rname="openssh"
rver="9.1p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="19f85009c7e3e23787f0236fbb1578392ab4d4bf9f8ec5fe6bc1cd7e8bfdd288"

sslprov="openssl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"
