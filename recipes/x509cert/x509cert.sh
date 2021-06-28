#
# XXX - gen an rsa key+cert with bearssl+x509cert
#   rm -f ${cwtop}/tmp/bearssl.{key,crt}
#   brssl skey -gen rsa:2048 -rawpem ${cwtop}/tmp/bearssl.key
#   x509cert -a $(hostname) -d $((100*366*24*60*60)) ${cwtop}/tmp/bearssl.key CN=$(hostname) | tee ${cwtop}/tmp/bearssl.crt
# XXX - regularly get a "failed to compute RSA public exponent" - bearssl works?
#   dropbearkey (tomcrypt) and mbedtls both exhibit this, cannot reliably reproduce yet
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
rver="0.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/michaelforney/${rname}/releases/download/${rver}/${rfile}"
rsha256="10199016a96931146a7b488ac3797ab761c6a0d72fb0ceebe89838f19f10ff88"
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
