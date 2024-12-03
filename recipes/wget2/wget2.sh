#
# XXX - gpgme support
# XXX - wolfssl seems to leave a port open and never completes a retrieval?
# XXX - --with-included-regex : default, safe to specify/force?
# XXX - libressl (at least 3.7.x, haven't tested with 3.8.x) breaks with wget2: https://github.com/rockdaboot/wget2/issues/271
#
rname="wget2"
rver="2.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
nsha256="fake"

. "${cwrecipe}/${rname}/${rname}.sh.common"
