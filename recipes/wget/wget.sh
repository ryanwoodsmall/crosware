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
rver="1.24.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="fa2dc35bab5184ecbc46a9ef83def2aaaa3f4c9f3c97d4bd19dcb07d4da637de"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
