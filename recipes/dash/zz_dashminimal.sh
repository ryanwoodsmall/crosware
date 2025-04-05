rname="dashminimal"
rver="$(cwver_dash)"
rdir="$(cwdir_dash)"
rbdir="$(cwbdir_dash)"
rfile="$(cwfile_dash)"
rdlfile="$(cwdlfile_dash)"
rurl="$(cwurl_dash)"
rsha256="$(cwsha256_dash)"
rreqs="bootstrapmake libeditminimal"

. "${cwrecipe}/common.sh"

for f in fetch extract ; do
  eval "function cw${f}_${rname} { cw${f}_${rname%minimal} ; }"
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} \
    --disable-silent-rules \
    --enable-static \
    --with-libedit \
      CC=\"\${CC} -I${cwsw}/libeditminimal/current/include -L${cwsw}/libeditminimal/current/lib\" \
      C{,XX}FLAGS=\"\${CFLAGS} -Os -Wl,-s -Wl,-static\" \
      LDFLAGS=-static \
      LIBS='-ledit -ltermcap -static' \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    CC=\"\${CC} -I${cwsw}/libeditminimal/current/include -L${cwsw}/libeditminimal/current/lib\" \
    C{,XX}FLAGS=\"\${CFLAGS} -Os -Wl,-s -Wl,-static\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}= \
      make -j${cwmakejobs} ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    CC=\"\${CC} -I${cwsw}/libeditminimal/current/include -L${cwsw}/libeditminimal/current/lib\" \
    C{,XX}FLAGS=\"\${CFLAGS} -Os -Wl,-s -Wl,-static\" \
    LDFLAGS=-static \
    CPPFLAGS= \
    PKG_CONFIG_{LIBDIR,PATH}= \
      make install ${rlibtool}
  rm -f \"\$(cwidir_${rname})/bin/${rname}\"
  cat \"\$(cwidir_${rname})/bin/${rname%minimal}\" > \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  ln -sf \"${rtdir}/current/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname%minimal}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
