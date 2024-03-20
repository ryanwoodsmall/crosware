rname="manpages"
rver="6.7"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="19436880d78b6d876736faad94736a0edf390dbd1bdc81153e484d62ae33cfe1"
rreqs="make coreutils"

. "${cwrecipe}/common.sh"

mpv="man-pages-posix-2017-a"
mpd="${mpv%-a}"

cwstubfunc "cwmake_${rname}"

eval "
function cwfetch_${rname}() {
  local mpp='man-pages-posix/${mpv}.tar.gz'
  local mpf=\"\${mpp##*/}\"
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl%/*}/\${mpp}\" \"${cwdl}/${rname}/\${mpf}\" \"8ba538e91db62622c507e34899e1e7d560e870505c00cd4d7f8d5048e54d056e\"
  unset mpp mpf
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"${cwdl}/${rname}/${mpv}.tar.gz\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG s,/usr/bin/env,${cwsw}/coreutils/current/bin/env,g GNUmakefile
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  grep -rl 'INSTALL.*-T' . | xargs sed -i.ORIG '/INSTALL/s/-T//g'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  (
    export PATH=\"${cwsw}/coreutils/current/bin:\${PATH}\"
    cwmkdir \"\$(cwidir_${rname})\"
    cwscriptecho \"\$(cwmyfuncname): installing man-pages\"
    make install-man prefix=\"\$(cwidir_${rname})\" &> \$(cwidir_${rname})/man-pages_install.out
    cd ${mpd}
    cwscriptecho \"\$(cwmyfuncname): installing man-pages-posix\"
    make install prefix=\"\$(cwidir_${rname})\" &> \$(cwidir_${rname})/man-pages-posix_install.out
  )
  popd >/dev/null 2>&1
}
"

unset mpv mpd
