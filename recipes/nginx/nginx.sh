#
# XXX - config from c8 stream: https://git.centos.org/rpms/nginx/blob/c8-stream-1.18/f/SPECS/nginx.spec
# XXX - --with-pcre-opt=\"--enable-jit --enable-pcre8 --enable-pcre16 --enable-pcre32 --enable-unicode-properties --enable-utf\" \
# XXX - no pcre jit on riscv64
# XXX - probably need to remove static bits for dynamic modules
# XXX - libressl variant, see:
#  - https://gist.github.com/Belphemur/3c022598919e6a1788fc
#  - https://github.com/nginx-modules/docker-nginx-libressl/blob/master/stable/alpine/Dockerfile
#

rname="nginx"
rver="1.23.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://nginx.org/download/${rfile}"
rsha256="a80cc272d3d72aaee70aa8b517b4862a635c0256790434dbfc4d618a999b0b46"
rreqs="make perl slibtool pcre2"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetch_openssl
  cwfetch_pcre2
  cwfetch_zlib
  cwfetch_njs
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_openssl)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_pcre2)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_zlib)\" \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_njs)\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' \"\$(cwdir_openssl)/Configure\"
  sed -i.ORIG 's/-march=armv7-a/-march=armv7-a -static/g' \"\$(cwdir_openssl)/config\"
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --add-module=\"\$(cwbdir_${rname})/\$(cwdir_njs)/nginx\" \
      --with-cc=\"\$(which \${CC})\" \
      --with-cc-opt=\"-fPIC -Wl,-static\" \
      --with-ld-opt=\"-static\" \
      --with-openssl=\"\$(cwbdir_${rname})/\$(cwdir_openssl)\" \
      --with-openssl-opt=\"--openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS -static\" \
      --with-perl=\"${cwsw}/perl/current/bin/perl\" \
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
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
