rname="uacme"
rver="1.7.5"
rdir="${rname}-upstream-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ndilieto/${rname}/archive/refs/tags/upstream/${rfile}"
rsha256="596b2fba75fedc7a410dd71583c828642ecd486dfdcfde109dfebb82a374abbe"
rreqs="make curl zlib openssl libssh2 cacertificates nghttp2 pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/curl/current/bin:\${PATH}\" \
    ./configure \
      ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --disable-docs \
      --with-libcurl=\"${cwsw}/curl/current\" \
      --with-openssl=\"${cwsw}/openssl/current\" \
      --without-gnutls \
      --without-mbedtls \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lssh2 -lnghttp2 -lz -lssl -lcrypto -static' \
        PKG_CONFIG=\"${cwsw}/pkgconfig/current/bin/pkg-config\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname}\" \"\$(cwidir_${rname})/bin/${rname}-openssl\"
  ln -sf \"ualpn\" \"\$(cwidir_${rname})/bin/ualpn-openssl\"
  \$(\${CC} -dumpmachine)-strip \"\$(cwidir_${rname})/bin/${rname}\" \"\$(cwidir_${rname})/bin/ualpn\"
  cwmkdir \"\$(cwidir_${rname})/share/man/man1\"
  cwmkdir \"\$(cwidir_${rname})/share/doc/txt\"
  cwmkdir \"\$(cwidir_${rname})/share/doc/html\"
  for p in uacme ualpn ; do
    install -m 644 \${p}.1 \"\$(cwidir_${rname})/share/man/man1/\"
    install -m 644 \${p}.1.txt \"\$(cwidir_${rname})/share/doc/txt/\"
    install -m 644 docs/\${p}.html \"\$(cwidir_${rname})/share/doc/html/\"
  done
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
