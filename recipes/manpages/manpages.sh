rname="manpages"
rver="6.02"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="66d809b62ba8681ebcbd1a8d0a0670776924ab93bfbbb54e1c31170e14303795"
rreqs="make"

. "${cwrecipe}/common.sh"

mpv="man-pages-posix-2017-a"
mpd="${mpv%-a}"

cwstubfunc "cwmake_${rname}"

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
  grep -rl 'INSTALL.*-T' . | xargs sed -i.ORIG '/INSTALL/s/-T//g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install-man prefix=\"${ridir}\"
  cd ${mpd}
  make install prefix=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

unset mpv mpd
