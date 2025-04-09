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
# XXX - need to set PID file location - defaults to /var/run
#

rname="openssh"
rver="10.0p1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rurl="https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/${rfile}"
rsha256="021a2e709a0edf4250b1256bd5a9e500411a90dddabea830ed59cef90eb9d85c"

sslprov="openssl"

. "${cwrecipe}/${rname%${sslprov}}/${rname%${sslprov}}.sh.common"
