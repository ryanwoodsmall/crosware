#
# XXX - libressl variant
# XXX - fix hard-coded python scripts
#
rname="nmap"
rver="7.94"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
rsha256="d71be189eec43d7e099bac8571509d316c4577ca79491832ac3e1217bc8f92cc"
rreqs="make openssl python3 zlib slibtool configgit gettexttiny pkgconfig"

. "${cwrecipe}/common.sh"

#eval "
#function cwpatch_${rname}() {
#  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
#  sed -i.ORIG 's,^#if OPENSSL_API_LEVEL.*,#if 0,g' ncat/http_digest.c
#  popd >/dev/null 2>&1
#}
#"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    ./configure --prefix=\"\$(cwidir_${rname})\" \
      --disable-nls \
      --with-ndiff \
      --with-openssl=\"${cwsw}/openssl/current\" \
      --with-libdnet=included \
      --with-liblinear=included \
      --with-liblua=included \
      --with-libpcap=included \
      --with-libpcre=included \
      --with-libssh2=included \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lssl -lcrypto -lz -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    make ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  env PATH=\"${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    make install ${rlibtool}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
