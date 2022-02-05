rname="n2nlibressl"
rver="$(cwver_n2n)"
rdir="$(cwdir_n2n)"
rfile="$(cwfile_n2n)"
rdlfile="$(cwdlfile_n2n)"
rurl="$(cwurl_n2n)"
rsha256=""
rreqs="make zstd libressl"

. "${cwrecipe}/common.sh"

for f in fetch clean extract ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} \
    --with-openssl \
    --with-zstd \
      CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,zstd}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{libressl,zstd}/current/lib) -L. -L.. -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    CC=\"\${CC} \${CFLAGS} -Wl,-s -L. -L..\"\
    CPPFLAGS=\"\$(echo -I${cwsw}/{libressl,zstd}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{libressl,zstd}/current/lib) -L. -L.. -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install PREFIX=\"${ridir}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/n2n/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
