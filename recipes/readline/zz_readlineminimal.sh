rname="readlineminimal"
rver="$(cwver_readline)"
rdir="$(cwdir_readline)"
rfile="$(cwfile_readline)"
rdlfile="$(cwdlfile_readline)"
rurl="$(cwurl_readline)"
rsha256="$(cwsha256_readline)"
rreqs="bootstrapmake bashtermcap"
#rpfile="${cwrecipe}/${rname%minimal}/${rname%minimal}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

# XXX - warning on patching: readline like bash needs gnu patch, this is minimal
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i '/^install-static:/s,install-doc,,g' Makefile.in
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}_termcap() {
  cwmkdir \"\$(cwidir_${rname})/include\"
  cwmkdir \"\$(cwidir_${rname})/lib\"
  install -m 644 \"${cwsw}/bashtermcap/current/include/termcap.h\" \"\$(cwidir_${rname})/include/\"
  install -m 644 \"${cwsw}/bashtermcap/current/lib/libtermcap.a\" \"\$(cwidir_${rname})/lib/\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwinstall_${rname}_termcap
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-install-examples \
    --without-curses \
    --without-shared-termcap-library \
      CFLAGS=\"\${CFLAGS} -fPIC\" \
      CXXFLAGS=\"\${CXXFLAGS} -fPIC\" \
      CPPFLAGS=\"-I\$(cwidir_${rname})/include\" \
      LDFLAGS=\"-L\$(cwidir_${rname})/lib -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
