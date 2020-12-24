rname="manpages"
rver="5.10"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="75102535ba119f2f223f674d84e1dcdaebf0a5ffd639b3c2e6cb0a0e34768762"
rreqs="make"

. "${cwrecipe}/common.sh"

mpv="man-pages-posix-2017-a"
mpd="${mpv%-a}"

eval "
function cwfetch_${rname}() {
  local mpp='man-pages-posix/${mpv}.tar.xz'
  local mpf=\"\${mpp##*/}\"
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl%/*}/\${mpp}\" \"${cwdl}/${rname}/\${mpf}\" \"ce67bb25b5048b20dad772e405a83f4bc70faf051afa289361c81f9660318bc3\"
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
  cd ${mpd}
  make install prefix=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

unset mpv mpd
