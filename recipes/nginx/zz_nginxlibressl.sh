rname="nginxlibressl"
rver="$(cwver_nginx)"
rdir="$(cwdir_nginx)"
rfile="$(cwfile_nginx)"
rdlfile="$(cwdlfile_nginx)"
rurl="$(cwurl_nginx)"
rsha256="$(cwsha256_nginx)"
rreqs="make slibtool libressl libgpgerror libgcrypt libxml2 libxslt zlib xz pkgconfig"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

for f in fetch clean extract patch ; do
  eval "function cw${f}_${rname}() { cw${f}_${rname%libressl} ; }"
done
unset f

eval "
function cwinstall_${rname}_libressl() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwdir_libressl)\"
  cd \"\$(cwdir_libressl)\"
  ln -sf \"${cwsw}/libressl/current\" .openssl
  echo | tee config Makefile
  chmod 755 config
  echo all: >> Makefile
  echo clean: >> Makefile
  echo install_sw: >> Makefile
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwinstall_${rname}_libressl
  cwinstall_${rname%libressl}_zlib
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --add-module=\"\$(cwbdir_${rname})/\$(cwdir_njs)/nginx\" \
    --with-cc=\"\$(which \${CC})\" \
    --with-cc-opt=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -fPIC -Wl,-static -g0 -Os -Wl,-s\" \
    --with-ld-opt=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
    --with-openssl=\"\$(cwbdir_${rname})/\$(cwdir_libressl)\" \
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
    --with-http_v3_module \
    --with-http_xslt_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make -j${cwmakejobs} ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH= NJS_CFLAGS=-static
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool} CC=\"\${CC}\" CPPFLAGS= LDFLAGS= PKG_CONFIG_LIBDIR= PKG_CONFIG_PATH=
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/sbin/${rname%libressl}\"
  ln -sf \"${rname%libressl}\" \"\$(cwidir_${rname})/sbin/${rname}\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%libressl}/current/sbin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
