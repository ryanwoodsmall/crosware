#
# XXX - config from c8 stream: https://git.centos.org/rpms/nginx/blob/c8-stream-1.18/f/SPECS/nginx.spec
# XXX - --with-pcre-opt=\"--enable-jit --enable-pcre8 --enable-pcre16 --enable-pcre32 --enable-unicode-properties --enable-utf\" \
# XXX - no pcre jit on riscv64
# XXX - probably need to remove static bits for dynamic modules
# XXX - libressl variant
# XXX - njs 0.7.0+ openssl support?
#

rname="nginx"
rver="1.20.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://nginx.org/download/${rfile}"
rsha256="958876757782190a1653e14dc26dfc7ba263de310e04c113e11e97d1bef45a42"
rreqs="make perl slibtool pcre"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetch_openssl
  cwfetch_pcre
  cwfetch_zlib
  cwfetch_njs
}
"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  cwextract \"\$(cwdlfile_openssl)\" \"${rbdir}\"
  cwextract \"\$(cwdlfile_pcre)\" \"${rbdir}\"
  cwextract \"\$(cwdlfile_zlib)\" \"${rbdir}\"
  cwextract \"\$(cwdlfile_njs)\" \"${rbdir}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/if.*eq.*-static/s/-static/-blahblahblah/g' \"\$(cwdir_openssl)/Configure\"
  sed -i.ORIG 's/-march=armv7-a/-march=armv7-a -static/g' \"\$(cwdir_openssl)/config\"
  env PATH=\"${cwsw}/perl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      --add-module=\"${rbdir}/\$(cwdir_njs)/nginx\" \
      --with-cc=\"\$(which \${CC})\" \
      --with-cc-opt=\"-fPIC -Wl,-static\" \
      --with-ld-opt=\"-static\" \
      --with-openssl=\"${rbdir}/\$(cwdir_openssl)\" \
      --with-openssl-opt=\"--openssldir=${cwetc}/ssl no-asm no-shared no-zlib no-zlib-dynamic -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS -static\" \
      --with-perl=\"${cwsw}/perl/current/bin/perl\" \
      --with-pcre=\"${rbdir}/\$(cwdir_pcre)\" \
      --with-zlib=\"${rbdir}/\$(cwdir_zlib)\" \
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
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH= NJS_CFLAGS=-static
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/sbin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
