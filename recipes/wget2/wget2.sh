#
# XXX - gpgme support
# XXX - wolfssl seems to leave a port open and never completes a retrieval?
# XXX - --with-included-regex : default, safe to specify/force?
# XXX - libressl (at least 3.7.x, haven't tested with 3.8.x) breaks with wget2: https://github.com/rockdaboot/wget2/issues/271
#
rname="wget2"
rver="2.3.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="4f1915b2a55a789a15f2f9ada7cc44bca81418e648f76fd88a7f4dd028b2149f"

. "${cwrecipe}/${rname}/${rname}.sh.common"
