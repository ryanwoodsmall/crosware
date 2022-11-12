rname="lessminimal"
rver="$(cwver_less)"
rdir="$(cwdir_less)"
rfile="$(cwfile_less)"
rdlfile="$(cwdlfile_less)"
rurl="$(cwurl_less)"
rsha256="$(cwsha256_less)"
rreqs="bootstrapmake bashtermcap"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

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
  pushd \"\$(cwbdir_less)\" >/dev/null 2>&1
  cwinstall_${rname}_termcap
  cat configure > configure.ORIG
  sed -i '/^TERMLIBS=/s,=,=-ltermcap,' configure
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    ac_cv_header_termcap_=yes \
    CC=\"\${CC} -g0 -Os -Wl,-s\" \
    CFLAGS=\"\${CFLAGS} -g0 -Os -Wl,-s\" \
    CPPFLAGS=\"-I\$(cwidir_${rname})/include\" \
    LDFLAGS=\"-L\$(cwidir_${rname})/lib -static\" \
    LIBS='-ltermcap' \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

# note prepend_ - swap order of "real" vs minimal
eval "
function cwgenprofd_${rname}() {
  echo -n > \"${rprof}\"
  echo 'prepend_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'prepend_path \"${cwsw}/${rname%minimal}/current/bin\"' >> \"${rprof}\"
  echo 'export PAGER=\"less -Q -L\"' >> \"${rprof}\"
  echo 'export MANPAGER=\"less -R -Q -L\"' >> \"${rprof}\"
  echo 'alias less=\"less -Q -L\"' >> \"${rprof}\"
}
"
