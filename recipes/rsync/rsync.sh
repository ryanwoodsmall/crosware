#
# XXX - for rsync 3.2.x...
#   - lz4
#   - openssl
#   - xxhash
#   - zstd
#

rname="rsync"
rver="3.1.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://download.samba.org/pub/${rname}/src/${rfile}"
rsha256="55cc554efec5fdaad70de921cd5a5eeb6c29a95524c715f3bbf849235b0800c0"
rreqs="make perl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} --with-included-popt --with-included-zlib
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
