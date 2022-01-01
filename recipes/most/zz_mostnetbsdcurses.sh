rname="mostnetbsdcurses"
rver="$(cwver_most)"
rdir="$(cwdir_most)"
rfile="$(cwfile_most)"
rdlfile="$(cwdlfile_most)"
rurl="$(cwurl_most)"
rsha256=""
rreqs="make netbsdcurses configgit"

. "${cwrecipe}/common.sh"

for f in fetch clean extract ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%netbsdcurses}
  }
  "
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"s/TERMCAP=-ltermcap/TERMCAP='-lcurses -lterminfo'/g\" configure
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --with-slang=\"${cwsw}/netbsdcurses/current\" \
      LDFLAGS=-static \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf most \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
