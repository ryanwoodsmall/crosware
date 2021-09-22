rname="htop"
rver="3.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="https://bintray.com/${rname}/source/download_file?file_path=${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="9b90697c091b2981c9123530e46a93d45d4277c22200fdaee41cd2e73ebe0420"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --enable-static \
    --disable-dependency-tracking \
      CC=\"\${CC} \${CFLAGS} \${LDFLAGS}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
