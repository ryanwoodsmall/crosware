rname="tig"
rver="2.5.6"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/jonas/tig/releases/download/${rdir}/${rfile}"
rsha256="50bb5f33369b50b77748115c730c52b13e79b2de49cba7167bb634eb683d965f"
rreqs="make ncurses readline git pkgconfig pcre2"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-pcre
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
