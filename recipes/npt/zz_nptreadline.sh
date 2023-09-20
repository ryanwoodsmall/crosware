rname="nptreadline"
rver="$(cwver_npt)"
rdir="$(cwdir_npt)"
rfile="$(cwfile_npt)"
rdlfile="$(cwdlfile_npt)"
rurl="$(cwurl_npt)"
rsha256="$(cwsha256_npt)"
rreqs="make netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

for f in clean fetch extract ; do
eval "
function cw${f}_${rname}() {
  cw${f}_${rname%readline}
}
"
done
unset f

cwstubfunc "cwconfigure_${rname}"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG \"s,-lreadline,\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo -static,g;s,-O3,-Os,g\" build/Makefile.linux_readline_release
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      bash build/linux_readline_release.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwidir_${rname})/bin\"
  install -m 755 ${rname%readline} \"\$(cwidir_${rname})/bin/${rname%readline}\"
  ln -sf ${rname%readline} \"\$(cwidir_${rname})/bin/${rname%readline}-readline\"
  ln -sf ${rname%readline} \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
