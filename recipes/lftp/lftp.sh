rname="lftp"
rver="4.9.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="http://lftp.yar.ru/ftp/${rfile}"
rsha256="5969fcaefd102955dd882f3bcd8962198bc537224749ed92f206f415207a024b"
rreqs="make slibtool ncurses readline openssl zlib pkgconfig expat"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -ril 'ssh -a -x' . | xargs sed -i.ORIG 's/ssh -a -x/ssh/g'
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
    --without-gnutls \
    --without-libidn2 \
    --with-expat=\"${cwsw}/expat/current\" \
    --with-openssl=\"${cwsw}/openssl/current\" \
    --with-readline=\"${cwsw}/readline/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
      LIBS='-lssl -lcrypto -lz -lreadline -lncurses'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
