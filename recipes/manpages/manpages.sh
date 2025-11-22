#
# XXX - avoid execution of `git log` for every file? wtf
#
rname="manpages"
rver="6.16"
rdir="man-pages-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://mirrors.edge.kernel.org/pub/linux/docs/man-pages/${rfile}"
rsha256="cfdc7c1d571fa40b1f31b68704e59c0c516ab85b53ebf537c8c8ec1f3b67b974"
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
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG s,/usr/bin/env,${cwsw}/coreutils/current/bin/env,g GNUmakefile
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -rl 'INSTALL.*-T' . | xargs sed -i.ORIG '/INSTALL/s/-T//g'
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    export PATH=\"${cwsw}/coreutils/current/bin:\${PATH}\"
    cwmkdir \"\$(cwidir_${rname})\"
    cwscriptecho \"\$(cwmyfuncname): installing man-pages... this will take awhile\"
    make -j${cwmakejobs} -R install prefix=\"\$(cwidir_${rname})\" &> \$(cwidir_${rname})/man-pages_install.out
    cd ${mpd}
    cwscriptecho \"\$(cwmyfuncname): installing man-pages-posix\"
    make install prefix=\"\$(cwidir_${rname})\" &> \$(cwidir_${rname})/man-pages-posix_install.out
  )
  popd &>/dev/null
}
"

unset mpv mpd
