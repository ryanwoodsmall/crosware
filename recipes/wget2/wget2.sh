#
# XXX - gpgme support
# XXX - wolfssl seems to leave a port open and never completes a retrieval?
# XXX - --with-included-regex : default, safe to specify/force?
#
rname="wget2"
rver="2.0.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname%2}/${rfile}"
rsha256="2c942fba6a547997aa7aae0053b7c46a5203e311e4e62d305d575b6d2f06411f"

. "${cwrecipe}/${rname}/${rname}.sh.common"
