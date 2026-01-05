#
# XXX - gpgme support
# XXX - wolfssl seems to leave a port open and never completes a retrieval?
# XXX - --with-included-regex : default, safe to specify/force?
# XXX - libressl (at least 3.7.x, haven't tested with 3.8.x) breaks with wget2: https://github.com/rockdaboot/wget2/issues/271
#
rname="wget2"
rver="2.2.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="d7544b13e37f18e601244fce5f5f40688ac1d6ab9541e0fbb01a32ee1fb447b4"

. "${cwrecipe}/${rname}/${rname}.sh.common"
