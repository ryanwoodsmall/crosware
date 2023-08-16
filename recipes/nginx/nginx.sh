#
# XXX - config from c8 stream: https://git.centos.org/rpms/nginx/blob/c8-stream-1.18/f/SPECS/nginx.spec
# XXX - --with-pcre-opt=\"--enable-jit --enable-pcre8 --enable-pcre16 --enable-pcre32 --enable-unicode-properties --enable-utf\" \
# XXX - no pcre jit on riscv64
# XXX - probably need to remove static bits for dynamic modules
# XXX - need nginxstable varianet?
#

rname="nginx"
rver="1.25.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://nginx.org/download/${rfile}"
rsha256="05dd6d9356d66a74e61035f2a42162f8c754c97cf1ba64e7a801ba158d6c0711"
rreqs="make openssl slibtool pcre2 libgpgerror libgcrypt libxml2 libxslt zlib xz pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_pcre2
  cwfetch_zlib
  cwfetch_njs
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_pcre2)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_zlib)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_njs)\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat \$(cwdir_njs)/auto/libxml2 > \$(cwdir_njs)/auto/libxml2.ORIG
  sed -i 's,/usr/local,${cwsw}/libxml2/current,g' \$(cwdir_njs)/auto/libxml2
  sed -i 's,-lxml2,-lxml2 -llzma -lz,g' \$(cwdir_njs)/auto/libxml2
  cat auto/lib/libxslt/conf > auto/lib/libxslt/conf.ORIG
  sed -i \"s, /usr/local/include, ${cwsw}/libxml2/current/include/libxml2 \$(echo ${cwsw}/{${rreqs// /,}}/current/include),g\" auto/lib/libxslt/conf
  sed -i \"s,-L/usr/local/lib,\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib),g\" auto/lib/libxslt/conf
  sed -i 's,-lxslt,-lxslt -lgcrypt -lgpg-error -lxml2 -llzma -lz,g' auto/lib/libxslt/conf
  sed -i 's,-lxml2 -lxslt,-lxslt,g' auto/lib/libxslt/conf
  sed -i 's,-lexslt,-lexslt -lxslt -lgcrypt -lgpg-error -lxml2 -llzma -lz,g' auto/lib/libxslt/conf
  popd >/dev/null 2>&1
}
"

eval "
function cwinstall_${rname}_openssl() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwdir_openssl)\"
  cd \"\$(cwdir_openssl)\"
  ln -sf \"${cwsw}/openssl/current\" .openssl
  echo | tee config Makefile
  chmod 755 config
  echo all: >> Makefile
  echo clean: >> Makefile
  echo install_sw: >> Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwinstall_${rname}_openssl
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --add-module=\"\$(cwbdir_${rname})/\$(cwdir_njs)/nginx\" \
      --with-cc=\"\$(which \${CC})\" \
      --with-cc-opt=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -fPIC -Wl,-static\" \
      --with-ld-opt=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      --with-openssl=\"\$(cwbdir_${rname})/\$(cwdir_openssl)\" \
      --with-pcre=\"\$(cwbdir_${rname})/\$(cwdir_pcre2)\" \
      --with-zlib=\"\$(cwbdir_${rname})/\$(cwdir_zlib)\" \
      --with-compat \
      --with-http_addition_module \
      --with-http_auth_request_module \
      --with-http_dav_module \
      --with-http_degradation_module \
      --with-http_flv_module \
      --with-http_gunzip_module \
      --with-http_gzip_static_module \
      --with-http_mp4_module \
      --with-http_random_index_module \
      --with-http_realip_module \
      --with-http_secure_link_module \
      --with-http_slice_module \
      --with-http_ssl_module \
      --with-http_stub_status_module \
      --with-http_sub_module \
      --with-http_v2_module \
      --with-http_xslt_module \
      --with-mail \
      --with-mail_ssl_module \
      --with-stream \
      --with-stream_realip_module \
      --with-stream_ssl_module \
      --with-stream_ssl_preread_module
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH= NJS_CFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/sbin/${rname}\"
  unset p
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
