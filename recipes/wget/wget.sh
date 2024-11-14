#
# XXX - c-ares support
# XXX - libpsl support
# XXX - libidn support
# XXX - gpgme support
# XXX - disabled metalink+expat 20220226
# XXX - metalink has/needs(?) gpgme support, probably not worth it for now
# XXX - --without-included-unistring for full-fat gnutls
# XXX - make virtual
#
rname="wget"
rver="1.25.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/wget/${rfile}"
rsha256="766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
