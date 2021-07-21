rname="manpages"
rver="5.12"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="7af5c960a05a7fac56813fe5bfa564a1c280e934363ae03911b67b0b8e23371e"
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/INSTALL/s/-T//g' Makefile
  popd >/dev/null 2>&1
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
