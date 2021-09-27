rname="mgminimal"
rver="$(cwver_mg)"
rdir="$(cwdir_mg)"
rfile="$(cwfile_mg)"
rdlfile="$(cwdlfile_mg)"
rurl="$(cwurl_mg)"
rsha256=""
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "
    function cw${f}_${rname}() {
      cw${f}_${rname%%minimal}
    }
    "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --enable-size-optimizations \
    --without-curses \
      LDFLAGS=-static \
      CPPFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  sed -i 's/-flto//g' src/Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install-strip
  ln -sf \"${rtdir}/current/bin/${rname%%minimal}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname%%minimal}\" \"${ridir}/bin/${rname%%minimal}-${rname##mg}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/mg/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
