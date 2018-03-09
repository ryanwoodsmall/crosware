rname="ed"
rver="1.14.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="f57962ba930d70d02fc71d6be5c5f2346b16992a455ab9c43be7061dec9810db"
rreqs="make lzip"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  pushd "${cwbuild}" >/dev/null 2>&1
  lzip -dc "${cwdl}/${rname}/${rfile}" | tar -xf -
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} CC=\"\${CC}\" CFLAGS=\"\${CFLAGS}\" CPPFLAGS=\"\${CPPFLAGS}\" LDFLAGS=\"\${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
