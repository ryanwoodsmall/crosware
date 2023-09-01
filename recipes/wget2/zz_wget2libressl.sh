#
# XXX - if wget2 2.1.x or libressl gets fixed, revert back!
#
rname="wget2libressl"
rver="2.0.1"
rdir="${rname%libressl}-${rver}"
rfile="${rdir}.tar.lz"
rurl="https://ftp.gnu.org/gnu/${rname%2libressl}/${rfile}"
rsha256="2c942fba6a547997aa7aae0053b7c46a5203e311e4e62d305d575b6d2f06411f"

. "${cwrecipe}/${rname%libressl}/${rname%libressl}.sh.common"

# XXX - remove!!!
cwstubfunc "cwpatch_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rbdir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool}
  popd >/dev/null 2>&1
}
"
