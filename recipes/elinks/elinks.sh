#
# XXX - this is a mess
# XXX - features...
# XXX   tre
# XXX   spidermonkey
#

rname="elinks"
rver="f86be659718c0cd0a67f88b42f07044c23d0d028"
rdir="${rname}-${rver:0:7}"
rfile="${rver}.tar.gz"
rurl="https://repo.or.cz/elinks.git/snapshot/${rfile}"
rsha256="e8b7cbe09b6df5ad4c1cab3395e117a46239c74cb32ef6fce68513a57e00f889"
rreqs="make perl openssl zlib bzip2 expat xz autoconf automake libtool m4 gettexttiny pkgconfig lua configgit cacertificates libdom"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cat \"${cwsw}/configgit/current/config.guess\" > config/config.guess
  cat \"${cwsw}/configgit/current/config.sub\" > config/config.sub
  sed -i.ORIG '1i\\
#define lua_strlen lua_rawlen' src/scripting/lua/hooks.c
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    bash autogen.sh || true
  env PATH=\"${cwsw}/autoconf/current/bin:${cwsw}/automake/current/bin:${cwsw}/libtool/current/bin:\${PATH}\" \
    autoreconf -fiv \
      -I\"${cwsw}/libtool/current/share/aclocal\" \
      -I\"${cwsw}/gettexttiny/current/share/aclocal\" \
      -I\"${cwsw}/pkgconfig/current/share/aclocal\" \
      -I./config/m4
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-mouse \
    --disable-sysmouse \
    --without-gpm \
    --without-idn \
    --enable-html-highlight \
    --enable-{88,256}-colors \
    --enable-true-color \
    --with-lzma \
    --disable-nls \
    --with-lua=\"${cwsw}/lua/current\" \
    --with-libdom \
      CFLAGS=\"\${CFLAGS} -Wno-pointer-sign\" \
      CPPFLAGS=\"\${CPPFLAGS} \$(pkg-config --cflags libdom libhubbub libwapcaplet)\" \
      LIBS=\"\$(pkg-config --libs libdom libhubbub libwapcaplet)\"
  grep -ril 'sys/signal\\.h' . \
  | egrep -i '\\.(c|h)$' \
  | xargs sed -i.ORIG 's#sys/signal\\.h#signal.h#g'
  sed -i.ORIG 's/^#define VA_COPY.*/#define VA_COPY va_copy/g' src/util/snprintf.h
  cd ./. && autoheader
  cd . && CONFIG_FILES= CONFIG_HEADERS=config.h /bin/sh ./config.status
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
