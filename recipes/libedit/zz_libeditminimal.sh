rname="libeditminimal"
rver="$(cwver_libedit)"
rdir="$(cwdir_libedit)"
rfile="$(cwfile_libedit)"
rdlfile="$(cwdlfile_libedit)"
rurl="$(cwurl_libedit)"
rsha256="$(cwsha256_libedit)"
rreqs="bootstrapmake"
rpfile="${cwrecipe}/${rname%minimal}/${rname%minimal}.patches"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch_bash
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_bash)\" \"\$(cwbdir_${rname})\"
}
"

# XXX - warning on patching: this'll need to be moved to configure if a patchfile needs applying
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i 's, install-man ,,g' Makefile.in
  sed -i '/DIRS/s, doc,,g' Makefile.in
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}_termcap() {
  pushd \"\$(cwbdir_${rname})/\$(basename \$(cwbdir_bash))\" >/dev/null 2>&1
  ./configure \
    --prefix=\"\$(cwidir_${rname})\" \
    --disable-nls \
    --disable-separate-helpfiles \
    --enable-readline \
    --without-curses \
    --enable-static-link \
    --without-bash-malloc \
      {{C{,XX,PP},LD}FLAGS,PKG_CONFIG_{LIBDIR,}}=
  cd lib/termcap
  make
  cwmkdir \"\$(cwidir_${rname})/include\"
  cwmkdir \"\$(cwidir_${rname})/lib\"
  install -m 644 termcap.h \"\$(cwidir_${rname})/include/\"
  install -m 644 libtermcap.a \"\$(cwidir_${rname})/lib/\"
  popd >/dev/null 2>&1
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
