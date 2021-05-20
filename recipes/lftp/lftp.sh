rname="lftp"
rver="4.9.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
#rurl="http://lftp.yar.ru/ftp/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="c517c4f4f9c39bd415d7313088a2b1e313b2d386867fe40b7692b83a20f0670d"
rreqs="make slibtool ncurses readline openssl zlib pkgconfig expat configgit"

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
