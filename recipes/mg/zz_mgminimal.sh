rname="mgminimal"
rver="$(cwver_mg)"
rdir="$(cwdir_mg)"
rfile="$(cwfile_mg)"
rdlfile="$(cwdlfile_mg)"
rurl="$(cwurl_mg)"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in clean fetch extract patch make ; do
  eval "
    function cw${f}_${rname}() {
      cw${f}_${rname%%minimal}
    }
    "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-size-optimizations \
    --without-curses \
      LDFLAGS=-static \
      CPPFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  sed -i 's/-flto//g' src/Makefile
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install-strip
  ln -sf \"${rtdir}/current/bin/${rname%%minimal}\" \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%%minimal}\" \"\$(cwidir_${rname})/bin/${rname%%minimal}-${rname##mg}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/mg/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
