rname="libeditminimal"
rver="$(cwver_libedit)"
rdir="$(cwdir_libedit)"
rfile="$(cwfile_libedit)"
rdlfile="$(cwdlfile_libedit)"
rurl="$(cwurl_libedit)"
rsha256="$(cwsha256_libedit)"
rreqs="bootstrapmake bashtermcap"
rpfile="${cwrecipe}/${rname%minimal}/${rname%minimal}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

# XXX - warning on patching: this'll need to be moved to configure if a patchfile needs applying
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i 's, install-man ,,g' Makefile.in
  sed -i '/DIRS/s, doc,,g' Makefile.in
  cwpatch_libedit
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
  env PATH=\"${cwsw}/minimal/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
      CFLAGS=\"\${CFLAGS} -fPIC -D__STDC_ISO_10646__=201206L\" \
      CXXFLAGS=\"\${CXXFLAGS} -fPIC -D__STDC_ISO_10646__=201206L\" \
      CPPFLAGS=\"-I\$(cwidir_${rname})/include\" \
      LDFLAGS=\"-L\$(cwidir_${rname})/lib -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"
