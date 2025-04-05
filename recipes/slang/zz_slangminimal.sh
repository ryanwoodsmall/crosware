rname="slangminimal"
rver="$(cwver_slang)"
rdir="$(cwdir_slang)"
rfile="$(cwfile_slang)"
rdlfile="$(cwdlfile_slang)"
rurl="$(cwurl_slang)"
rsha256="$(cwsha256_slang)"
rreqs="bootstrapmake bashtermcap zlib configgit"
rpfile="${cwrecipe}/${rname%minimal}/${rname%minimal}.patches"
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
  pushd \"\$(cwbdir_slang)\" &>/dev/null
  cwinstall_${rname}_termcap
  cat configure > configure.ORIG
  sed -i s/ncurses5-/off_ncurses5-/g configure
  sed -i s/ncursesw5-/off_ncursesw5-/g configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I\$(cwidir_${rname})/include\" \
    LDFLAGS=\"-L\$(cwidir_${rname})/lib -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_slang)\" &>/dev/null
  make -j${cwmakejobs} static ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_slang)\" &>/dev/null
  make install-static ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
