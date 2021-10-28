rname="retawqlibressl"
rver="$(cwver_retawq)"
rdir="$(cwdir_retawq)"
rfile="$(cwfile_retawq)"
rdlfile="$(cwdlfile_retawq)"
rurl="$(cwurl_retawq)"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256=""
rreqs="make ncurses libressl zlib pkgconfig"

. "${cwrecipe}/common.sh"

for f in fetch clean extract make ; do
  eval "
  function cw${f}_${rname}() {
    cw${f}_${rname%%libressl}
  }
  "
done
unset f

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  chmod -R u+rw .
  sed -i.ORIG /RAND_egd/d resource.c
  sed -i.ORIG '/pkg-config/s,openssl,openssl zlib,g' tool/tlsmode
  ./configure \
    --disable-textmodemouse \
    --enable-ipv6 \
    --enable-local-cgi \
    --path-prefix=\"${ridir}\" \
    --set-tg=ncurses \
    --set-tls=2 \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{libressl,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
      CC=\"\${CC} \${CFLAGS} -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncurses -L${cwsw}/ncurses/current/lib\" \
      LDFLAGS='-static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmakeinstall_${rname%%libressl}
  ln -sf \"${rname%%libressl}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rname%%libressl}\" \"${ridir}/bin/${rname%%libressl}-${rname##retawq}\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
