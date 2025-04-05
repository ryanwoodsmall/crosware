#
# XXX - 1.11.0 conflict with openssl 1.1.x (at least - test with 3.x!!! when i move it to default openssl...)
# XXX - nginx, which brings openssl and libxml2/libxslt, which pull in libgcrypt:
#    /usr/local/crosware/software/statictoolchain/202109250959-x86_64-linux-musl/bin/../lib/gcc/x86_64-linux-musl/9.4.0/../../../../x86_64-linux-musl/bin/ld: /usr/local/crosware/software/libgcrypt/current/lib/libgcrypt.a(mceliece6688128f.o): in function `gf_mul':
#    mceliece6688128f.c:(.text+0xa8de): multiple definition of `gf_mul'; /usr/local/crosware/builds/nginx-1.26.1/openssl-1.1.1w/.openssl/lib/libcrypto.a(f_impl.o):f_impl.c:(.text+0x16): first defined here
#    /usr/local/crosware/software/statictoolchain/202109250959-x86_64-linux-musl/bin/../lib/gcc/x86_64-linux-musl/9.4.0/../../../../x86_64-linux-musl/bin/ld: /usr/local/crosware/software/libgcrypt/current/lib/libgcrypt.a(aria.o): in function `aria_encrypt':
#    aria.c:(.text+0x7e82): multiple definition of `aria_encrypt'; /usr/local/crosware/builds/nginx-1.26.1/openssl-1.1.1w/.openssl/lib/libcrypto.a(aria.o):aria.c:(.text+0x0): first defined here
#    collect2: error: ld returned 1 exit status
#    make[1]: *** [objs/Makefile:426: objs/nginx] Error 1
#    make[1]: Leaving directory '/usr/local/crosware/builds/nginx-1.26.1'
#
rname="libgcrypt"
rver="1.10.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://gnupg.org/ftp/gcrypt/${rname}/${rfile}"
rsha256="8b0870897ac5ac67ded568dcfadf45969cfa8a6beb0fd60af2a9eadc2a3272aa"
rreqs="make libgpgerror slibtool configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
    --disable-asm \
    --with-libgpg-error-prefix=\${cwsw}/libgpgerror/current/ \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
