#
# XXX - xmalloc hack - it's included in libhistory/libreadline
# XXX - libressl variant?
# XXX - netbsdcurses?
#
rname="lftp"
rver="4.9.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rfile="${rdir}.tar.xz"
#rurl="http://lftp.yar.ru/ftp/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
#rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rurl="https://github.com/lavv17/lftp/releases/download/v${rver}/${rfile}"
rsha256="68116cc184ab660a78a4cef323491e89909e5643b59c7b5f0a14f7c2b20e0a29"
rreqs="make slibtool ncurses readline openssl zlib pkgconfig expat configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \$(cwbdir_${rname})/customlib
  grep -ril 'ssh -a -x' . | xargs sed -i.ORIG 's/ssh -a -x/ssh/g'
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --disable-nls \
    --without-gnutls \
    --without-libidn2 \
    --with-expat=\"${cwsw}/expat/current\" \
    --with-openssl=\"${cwsw}/openssl/current\" \
    --with-readline=\"${cwsw}/readline/current\" \
    --with-zlib=\"${cwsw}/zlib/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"-L\$(cwbdir_${rname})/customlib \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lssl -lcrypto -lz -lreadline -lncurses'
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cd customlib
  rm -f *.a *.o
  for l in history readline ; do
    cp ${cwsw}/readline/current/lib/lib\${l}.a .
    busybox ar x -v lib\${l}.a
    rm -f xmalloc.o lib\${l}.a
    busybox ar r lib\${l}.a *.o
    ranlib lib\${l}.a
    rm -f *.o
  done
  cd -
  make -j${cwmakejobs} ${rlibtool}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
