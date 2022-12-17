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

for f in clean fetch extract patch make makeinstall ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%tiny} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%tiny}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
