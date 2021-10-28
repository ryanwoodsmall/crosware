#
# XXX - netbsdcurses? same problem as rogue, WINDOW underdefined? __STDC_ISO_10646__?
# XXX - openbsd ports patches may be of use: http://cvsweb.openbsd.org/cgi-bin/cvsweb/ports/www/retawq/
# XXX - quit with capital Q, lowercase q is unmapped: http://retawq.sourceforge.net/docu/key.html
#

rname="retawq"
rver="0.2.6c"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://prdownloads.sourceforge.net/${rname}/${rfile}"
rsha256="a42e82494f00e054c2de1b065bbc8fb439d93eb69f9b97cc4868e71e48a9eae0"
rreqs="make ncurses openssl zlib pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  chmod -R u+rw .
  sed -i.ORIG /RAND_egd/d resource.c
  sed -i.ORIG '/pkg-config/s,openssl,openssl zlib,g' tool/tlsmode
  ./configure \
    --disable-textmodemouse \
    --enable-ipv6 \
    --enable-local-cgi \
    --path-prefix=\"${ridir}\" \
    --set-tg=ncurses \
    --set-tls=2 \
      CPPFLAGS= \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{openssl,zlib}/current/lib/pkgconfig | tr ' ' ':')\" \
      CC=\"\${CC} \${CFLAGS} -I${cwsw}/ncurses/current/include -I${cwsw}/ncurses/current/include/ncurses -L${cwsw}/ncurses/current/lib\" \
      LDFLAGS='-static -s'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
