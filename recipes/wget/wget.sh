#
# XXX - wget2: wolfssl, bison, flex, xz, ...
# XXX - c-ares support
# XXX - libpsl support
# XXX - gpgme support
# XXX - disabled metalink+expat 20220226
# XXX - metalink has/needs(?) gpgme support, probably not worth it for now
#

rname="wget"
rver="1.21.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="dbd2fb5e47149d4752d0eaa0dac68cc49cf20d46df4f8e326ffc8f18b2af4ea5"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
