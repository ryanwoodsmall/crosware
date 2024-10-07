#
# XXX - libressl variant
# XXX - fix hard-coded python scripts
# XXX - 7.95 introduces some more python3 stuff...
# XXX - which in turn needs to compile native code, using cmake
# XXX - cairo is needed, etc.
# XXX - need to dig in more
#
rname="nmap"
#rver="7.95"
rver="7.94"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://nmap.org/dist/${rfile}"
#rsha256="e14ab530e47b5afd88f1c8a2bac7f89cd8fe6b478e22d255c5b9bddb7a1c5778"
rsha256="d71be189eec43d7e099bac8571509d316c4577ca79491832ac3e1217bc8f92cc"
rreqs="make openssl python3 zlib slibtool configgit gettexttiny pkgconfig automake autoconf libtool"

. "${cwrecipe}/common.sh"

#eval "
#function cwpatch_${rname}() {
#  pushd \"\$(cwbdir_${rname})\" &>/dev/null
#  : sed -i.ORIG 's,^#if OPENSSL_API_LEVEL.*,#if 0,g' ncat/http_digest.c
#  grep -ril 'aclocal-1\\.16' ./libpcre/ | xargs sed -i.ORIG '/aclocal-1\\.16/s,16,17,g' || true
#  popd &>/dev/null
#}
#"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwbdir_${rname})/tmpbin
  : ln -sf \$(which aclocal) \$(cwbdir_${rname})/tmpbin/aclocal-1.16
  : ln -sf \$(which automake) \$(cwbdir_${rname})/tmpbin/automake-1.16
  env PATH=\"\$(cwbdir_${rname})/tmpbin:${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
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
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(cwbdir_${rname})/tmpbin:${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    make ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"\$(cwbdir_${rname})/tmpbin:${cwsw}/python3/current/bin:${cwsw}/gettexttiny/current/bin:${cwsw}/pkgconfig/current/bin:\${PATH}\" \
    make install ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
