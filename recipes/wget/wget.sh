#
# XXX - c-ares support
# XXX - libpsl support
# XXX - libidn support
# XXX - gpgme support
# XXX - disabled metalink+expat 20220226
# XXX - metalink has/needs(?) gpgme support, probably not worth it for now
# XXX - --without-included-unistring for full-fat gnutls
#

rname="wget"
rver="1.21.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="3683619a5f50edcbccb1720a79006fa37bf9b9a255a8c5b48048bc3c7a874bd9"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
