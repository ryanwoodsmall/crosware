#
# XXX - regularly get a "failed to compute RSA public exponent" - bearssl?
# XXX - gen an rsa cert w/dropbearkey+dropbearconvert+x509cert
#   rm -f ${cwtop}/tmp/{key,cert}.{dropbear,pem}
#   dropbearkey -t rsa -f ${cwtop}/tmp/key.dropbear -s 2048
#   dropbearconvert dropbear openssl ${cwtop}/tmp/key.{dropbear,pem}
#   x509cert -a $(hostname) -d $((100*366*24*60*60)) ${cwtop}/tmp/key.pem CN=$(hostname) | tee ${cwtop}/tmp/cert.pem
# XXX - mbedtls gen_key is
#   mbedtls_gen_key format=pem type=rsa rsa_keysize=2048 filename=${cwtop}/tmp/key.pem
# XXX - ecdsa key is something like
#   dropbearkey -t ecdsa -f key.dropbear -s 521
#

rname="x509cert"
rver="0.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/${rname}/releases/download/${rver}/${rfile}"
rsha256="8317ec09b6f207f18a9e7309e18c7c384a432033164aef169c6d8019c3cc50cb"
rreqs="make bearssl"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetch \"${rurl}\" \"${rdlfile}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG 's,^PREFIX=.*,PREFIX=${ridir},g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make \
    CC=\"\${CC} \${CFLAGS} -I${cwsw}/bearssl/current/include\" \
    LD{FLAGS,LIBS}=\"-L${cwsw}/bearssl/current/lib -lbearssl -static\" \
    CPPFLAGS= \
    PKG_CONFIG_LIBDIR= \
    PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install
  \$(\${CC} -dumpmachine)-strip --strip-all \"${ridir}/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
