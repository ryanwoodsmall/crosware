rname="manpages"
rver="5.05"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="d5b135b1196d9258138610dbc47190d8b9ac9dee7f8ee6d9196f7fc6a036eb47"
rreqs="make"

. "${cwrecipe}/common.sh"

mpv="man-pages-posix-2013-a"

eval "
function cwfetch_${rname}() {
  local mpp='man-pages-posix/${mpv}.tar.xz'
  local mpf=\"\${mpp##*/}\"
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl%/*}/\${mpp}\" \"${cwdl}/${rname}/\${mpf}\" \"19633a5c75ff7deab35b1d2c3d5b7748e7bd4ef4ab598b647bb7e7f60b90a808\"
  unset mpp mpf
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"${cwdl}/${rname}/${mpv}.tar.xz\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install prefix=\"${ridir}\"
  cd ${mpv}
  make install prefix=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

unset mpv
