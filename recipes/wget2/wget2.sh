#
# XXX - gpgme support
# XXX - wolfssl seems to leave a port open and never completes a retrieval?
# XXX - --with-included-regex : default, safe to specify/force?
# XXX - libressl (at least 3.7.x, haven't tested with 3.8.x) breaks with wget2: https://github.com/rockdaboot/wget2/issues/271
#
rname="wget2"
rver="2.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="bc034194b512bb83ce0171d15a8db33e1c5c3ab8b3e343e1e6f2cf48f9154fad"

. "${cwrecipe}/${rname}/${rname}.sh.common"
