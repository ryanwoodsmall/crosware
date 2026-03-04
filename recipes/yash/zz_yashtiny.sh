rname="yashtiny"
rver="$(cwver_yash)"
rdir="$(cwdir_yash)"
rbdir="$(cwbdir_yash)"
rfile="$(cwfile_yash)"
rdlfile="$(cwdlfile_yash)"
rurl="$(cwurl_yash)"
rsha256="$(cwsha256_yash)"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

for f in clean fetch extract make ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%tiny} ; }"
done
unset f

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwpatch_yash
  sed -i.ORIG '/^INSTALLDATADIRS/s,/completion,,g' Makefile.in
  cwmkdir share.off
  mv share/completion share.off/
  popd &>/dev/null
}
"
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-doc \
    --disable-lineedit \
    --disable-nls \
    --enable-{array,dirstack,double-bracket,help,history,printf,socket,test,ulimit} \
      CC=\"\${CC} \${CFLAGS} -Os -g0 -Wl,-s\" \
      CXX=\"\${CXX} \${CXXFLAGS} -Os -g0 -Wl,-s\" \
      CFLAGS=\"\${CFLAGS} -Os -g0 -Wl,-s\" \
      CXXFLAGS=\"\CXXFLAGS} -Os -g0 -Wl,-s\" \
      LDFLAGS=\"-static -s\" \
      CPPFLAGS= \
      LIBS=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  test -e \"\$(cwidir_${rname})/bin\" && rm -f \$(cwidir_${rname})/bin/* || true
  make install
  mv ${rname%tiny} \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf ${rname} \"\$(cwidir_${rname})/bin/${rname%tiny}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%tiny}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
